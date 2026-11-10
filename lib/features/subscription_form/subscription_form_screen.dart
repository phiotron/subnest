import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/logos/logo_providers.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../catalog/catalog_helpers.dart';
import '../catalog/widgets/library_rows.dart';
import '../catalog/widgets/plan_sheet.dart';
import 'form_format.dart';
import 'widgets/currency_sheet.dart';
import 'widgets/form_parts.dart';
import 'widgets/organize_parts.dart';
import 'widgets/custom_logo_picker.dart';
import 'widgets/tile_sheet.dart';

/// S4 Add / edit subscription (mockup v13 png 26–33, 36–37). One screen for both: pre-filled from
/// the Catalog (`serviceId`/`planId`, price region of the library tab it was picked from), a custom
/// name, or an existing subscription (`subscriptionId`). v13 groups: Category (the user's
/// Categories), Labels + Payment method (from the list, quick add), Remind me (several offsets),
/// Worth it?, More details (cancel link, notes); Delete at the end when editing.
/// Business rules stay in [SubscriptionDraft] (validation, My share, next dates, applying edits).
class SubscriptionFormScreen extends ConsumerStatefulWidget {
  const SubscriptionFormScreen({super.key, this.subscriptionId, this.serviceId, this.planId, this.initialName});

  /// Edit mode when set.
  final String? subscriptionId;

  /// Pre-fill from the Catalog.
  final String? serviceId;
  final String? planId;

  /// Pre-filled name for a custom service.
  final String? initialName;

  @override
  ConsumerState<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends ConsumerState<SubscriptionFormScreen> {
  SubscriptionDraft? _draft;
  Subscription? _original;

  /// Catalog service behind the subscription (library colour, plans).
  CatalogService? _service;

  /// Chosen plan when the service has several — the name field then holds the service name and
  /// the saved name is "Netflix Premium" (same rule as the Catalog).
  CatalogPlan? _plan;

  /// Catalog price region for pre-fill and the plan chip (library tab, else the device region).
  late String _region = ref.read(catalogRegionProvider);

  /// Pre-filled Catalog price when it is a Reference price (chip while the price is unchanged).
  CatalogPrice? _refPrice;

  /// Price in major units; `null` = empty.
  double? _price;
  bool _urlFromLibrary = false;
  bool _validated = false;
  bool _more = false;
  bool _saving = false;

  /// Custom logo picked in the tile sheet, saved with the subscription; [_photoRemoved] = remove
  /// the saved one on save.
  Uint8List? _newPhoto;
  bool _photoRemoved = false;

  final _name = TextEditingController();
  final _every = TextEditingController();
  final _url = TextEditingController();
  final _notes = TextEditingController();
  final _scroll = ScrollController();
  final _trialKey = GlobalKey();

  bool get _isEdit => widget.subscriptionId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_name, _every, _url, _notes]) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  // ---- Loading -----------------------------------------------------------------------------

  Future<void> _load() async {
    final today = ref.read(todayProvider);
    final primary = ref.read(primaryCurrencyProvider);
    final catalog = ref.read(catalogRepositoryProvider);
    var name = '';
    SubscriptionDraft draft;
    if (_isEdit) {
      final s = await ref.read(subscriptionRepositoryProvider).get(widget.subscriptionId!);
      if (!mounted) return;
      if (s == null) {
        context.pop();
        return;
      }
      _original = s;
      draft = SubscriptionDraft.fromSubscription(s, today);
      name = s.name;
      final service = s.serviceId == null ? null : await catalog.byId(s.serviceId!);
      _service = service;
      if (service != null && service.plans.length > 1) {
        final byLength = [...service.plans]..sort((a, b) => b.name.length.compareTo(a.name.length));
        for (final p in byLength) {
          if (s.name.endsWith(' ${p.name}')) {
            _plan = p;
            name = s.name.substring(0, s.name.length - p.name.length - 1);
            break;
          }
        }
      }
    } else if (widget.serviceId != null) {
      final service = await catalog.byId(widget.serviceId!);
      _service = service;
      _region = ref.read(libraryPickRegionProvider.notifier).take() ?? _region;
      final region = _region;
      final plan = service == null
          ? null
          : (service.plans.where((p) => p.id == widget.planId).firstOrNull ?? CatalogView.defaultPlan(service, region));
      final sub = (service == null || plan == null)
          ? null
          : subscriptionFromCatalog(
              service,
              plan,
              region: region,
              id: 'draft',
              today: today,
              now: ref.read(clockProvider)(),
            );
      if (sub != null) {
        draft = SubscriptionDraft.fromSubscription(sub, today);
        final price = plan!.priceFor(region);
        if (price != null && price.isReference) _refPrice = price;
      } else {
        draft = SubscriptionDraft.blank(currency: primary, today: today, name: service?.name ?? '');
        if (service != null) {
          draft
            ..serviceId = service.id
            ..category = service.category
            ..colorValue = service.colorValue
            ..iconText = service.monogram
            ..manageUrl = service.cancelUrl ?? service.manageUrl;
          if (plan != null) draft.cycle = plan.cycle;
        }
      }
      name = draft.name;
      if (service != null && plan != null && service.plans.length > 1) {
        _plan = plan;
        name = service.name;
      }
      _urlFromLibrary = draft.manageUrl != null;
    } else {
      draft = SubscriptionDraft.blank(currency: primary, today: today, name: widget.initialName ?? '')
        ..colorValue = AppColors.tilePalette[5].toARGB32();
      name = draft.name;
    }
    if (!mounted) return;
    _name.text = name;
    _price = draft.priceMinor > 0 ? toMajorUnits(draft.priceMinor, draft.currency) : null;
    _every.text = '${draft.cycle.every}';
    _url.text = draft.manageUrl ?? '';
    _notes.text = draft.notes ?? '';
    setState(() => _draft = draft);
  }

  // ---- State helpers -----------------------------------------------------------------------

  String get _fullName {
    final base = _name.text.trim();
    if (_plan == null || base.isEmpty) return base;
    return '$base ${_plan!.name}';
  }

  /// Copies the text fields into the draft.
  void _sync() {
    final d = _draft!;
    d.name = _fullName;
    d.priceMinor = toMinorUnits(_price ?? 0, d.currency);
    d.manageUrl = _url.text;
    d.notes = _notes.text;
  }

  void _update(VoidCallback change) => setState(change);

  void _setCycle(BillingCycle cycle) => _update(() {
    _draft!.cycle = cycle;
    if (_every.text != '${cycle.every}') _every.text = '${cycle.every}';
  });

  // ---- Sheets & pickers --------------------------------------------------------------------

  Future<void> _pickPlan() async {
    final service = _service;
    if (service == null) return;
    final region = _region;
    final plan = await showPlanSheet(context, service: service, region: region, initial: _plan);
    if (plan == null || !mounted) return;
    final price = plan.priceFor(region);
    _update(() {
      _plan = plan;
      _refPrice = price != null && price.isReference ? price : null;
      if (price != null) {
        _draft!.currency = price.currency;
        _price = price.amount;
      }
      _draft!.cycle = plan.cycle;
      _every.text = '${plan.cycle.every}';
    });
  }

  /// A photo can be the tile only when the service has no bundled logo (custom services, and
  /// Catalog services the app has no logo for).
  bool _canUsePhoto(BuildContext context) {
    final id = _draft?.serviceId;
    return id == null || ServiceLogoScope.of(context).serviceLogo(id) == null;
  }

  /// The Custom logo the tile shows now: picked in this form, else the saved one (unless removed).
  ImageProvider? _photoImage(BuildContext context) {
    if (!_canUsePhoto(context)) return null;
    if (_newPhoto != null) return MemoryImage(_newPhoto!);
    final o = _original;
    final file = o?.customLogoFile;
    if (_photoRemoved || file == null) return null;
    return ServiceLogoScope.of(context).customLogo(file);
  }

  Future<void> _pickTile() async {
    final l = context.l10n;
    final d = _draft!;
    _sync();
    final choice = await showTileSheet(
      context,
      name: d.name,
      colorValue: d.colorValue,
      iconText: d.iconText,
      previewMeta: '${l.money(Money(d.myShareMinor, d.currency))}${perCycle(l, d.cycle)}',
      libraryColor: _service?.colorValue,
      libraryName: _service?.name,
      canUsePhoto: _canUsePhoto(context),
      photo: _photoImage(context),
      pickPhoto: ref.read(customLogoPickerProvider),
    );
    if (choice == null || !mounted) return;
    _update(() {
      d.colorValue = choice.colorValue;
      d.iconText = choice.iconText;
      if (choice.photo != null) {
        _newPhoto = choice.photo;
        _photoRemoved = false;
      } else if (choice.removePhoto) {
        _newPhoto = null;
        _photoRemoved = true;
      }
    });
  }

  /// [s] with the Custom logo change applied: a picked picture is written first (so the saved
  /// `customLogoFile` never names a missing file), a removed one clears the name. A write failure
  /// never blocks saving the subscription (it just keeps its previous logo).
  Future<Subscription> _withLogo(Subscription s, {required bool canUsePhoto}) async {
    if (_newPhoto != null && canUsePhoto) {
      try {
        return s.copyWith(customLogoFile: await ref.read(customLogoStoreProvider).save(s.id, _newPhoto!));
      } catch (_) {
        return s; // disk full / file system error
      }
    }
    if (_photoRemoved || !canUsePhoto) return s.copyWith(customLogoFile: null);
    return s;
  }

  /// Deletes the previous picture once the subscription no longer points at it.
  Future<void> _dropOldLogo(String? previous, String? now) async {
    if (previous == null || previous == now) return;
    try {
      await ref.read(customLogoStoreProvider).delete(previous);
    } catch (_) {
      // Left over → removed by the start-up clean-up (app.dart).
    }
  }

  Future<void> _pickCurrency() async {
    final l = context.l10n;
    final d = _draft!;
    final primary = ref.read(primaryCurrencyProvider);
    final subs = ref.read(subscriptionsProvider).value ?? const <Subscription>[];
    final rates = ref.read(ratesProvider).value;
    final code = await showCurrencySheet(
      context,
      title: l.subscriptionFormCurrencyTitle,
      searchHint: l.subscriptionFormCurrencySearch,
      selected: d.currency,
      primary: primary,
      used: [primary, ...subs.map((s) => s.currency), d.currency],
      known: rates?.usdRates.keys ?? const [],
      rates: rates,
      footnote: l.subscriptionFormCurrencyNote(primary),
    );
    if (code == null || !mounted) return;
    _update(() => d.currency = code);
  }

  Future<void> _pickDate({required bool trialEnd}) async {
    final l = context.l10n;
    final d = _draft!;
    final today = ref.read(todayProvider);
    final initial = trialEnd ? (d.trialEnd ?? today) : d.dueDate;
    final picked = await showAppDatePicker(
      context,
      initial: initial,
      today: today,
      doneLabel: l.commonDone,
      footer: (sel) => l.subscriptionFormThen(
        [for (var i = 1; i <= 3; i++) AppDates.short(l, d.cycle.occurrence(sel, i), today: sel)].join(' · '),
      ),
    );
    if (picked == null || !mounted) return;
    _update(() {
      if (trialEnd || d.trial) {
        d.trialEnd = picked;
      } else {
        d.dueDate = picked;
      }
    });
  }

  // ---- Saving ------------------------------------------------------------------------------

  Future<void> _save() async {
    if (_saving) return;
    _sync();
    final d = _draft!;
    final today = ref.read(todayProvider);
    final errors = d.validate(today);
    if (errors.isNotEmpty) {
      setState(() => _validated = true);
      _revealError(errors);
      return;
    }
    final repo = ref.read(subscriptionRepositoryProvider);
    final now = ref.read(clockProvider)();
    final o = _original;
    if (o != null) {
      final priceChanged = o.priceMinor != d.priceMinor || o.currency != d.currency;
      if (priceChanged && o.status != SubscriptionStatus.cancelled) {
        final apply = await _confirmPrice(o, d);
        if (apply == null || !mounted) return;
        if (!apply) {
          _price = toMajorUnits(o.priceMinor, o.currency);
          d.currency = o.currency;
          _sync();
        }
      }
    }
    final canUsePhoto = _canUsePhoto(context);
    // The spinner only runs while writing (not behind the price dialog).
    setState(() => _saving = true);
    try {
      final toSave = await _withLogo(
        o != null ? d.applyTo(o, now: now) : d.toNew(id: repo.newId(), today: today, now: now),
        canUsePhoto: canUsePhoto,
      );
      await repo.save(toSave);
      await _dropOldLogo(o?.customLogoFile, toSave.customLogoFile);
      if (!mounted) return;
      if (o != null) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _revealError(List<DraftError> errors) {
    if (errors.contains(DraftError.nameEmpty) || errors.contains(DraftError.priceNotPositive)) {
      _scroll.animateTo(0, duration: AppMotion.of(context, AppMotion.sheet), curve: AppMotion.ease);
    } else if (_trialKey.currentContext != null) {
      Scrollable.ensureVisible(_trialKey.currentContext!, duration: AppMotion.of(context, AppMotion.sheet));
    }
  }

  /// "Use ₫280,000 from the next period?" (png 27). `true` apply, `false` keep the old price,
  /// `null` dismissed (nothing saved).
  Future<bool?> _confirmPrice(Subscription o, SubscriptionDraft d) async {
    final l = context.l10n;
    final today = ref.read(todayProvider);
    final periods = await ref.read(subscriptionRepositoryProvider).allPeriods();
    final paid = periods.where((p) => p.subscriptionId == o.id && p.outcome == PeriodOutcome.payment).length;
    if (!mounted) return null;
    final next = AppDates.short(l, d.trial ? (d.trialEnd ?? d.dueDate) : d.dueDate, today: today);
    final newPrice = l.money(Money(d.priceMinor, d.currency));
    final oldPrice = l.money(Money(o.priceMinor, o.currency));
    final body = [
      l.subscriptionFormPriceDialogBody(next),
      if (paid > 0) l.subscriptionFormPriceDialogPast(paid),
    ].join(' ');
    return showAppDialog<bool>(
      context,
      title: l.subscriptionFormPriceDialogTitle(newPrice),
      body: body,
      actions: [
        AppButton.primary(
          label: l.subscriptionFormPriceApply,
          expand: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
        ),
        AppButton.text(
          label: l.subscriptionFormPriceKeep(oldPrice),
          expand: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
        ),
      ],
    );
  }

  // ---- Build -------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = _draft;
    final title = _isEdit ? l.subscriptionFormEditTitle : l.subscriptionFormAddTitle;
    if (d == null) {
      return Scaffold(
        appBar: AppTopBar(title: title, close: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    _sync();
    final today = ref.watch(todayProvider);
    final errors = _validated ? d.validate(today) : const <DraftError>[];

    return Scaffold(
      appBar: AppTopBar(title: title, close: true),
      body: ListView(
        controller: _scroll,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s6),
        children: [
          _header(context, d, errors),
          const SizedBox(height: AppSpace.s5),
          _priceCard(context, d, errors),
          const SizedBox(height: AppSpace.s3),
          _cycleCard(context, d, today),
          const SizedBox(height: AppSpace.s3),
          _trialShareCard(context, d, errors),
          const SizedBox(height: AppSpace.s3),
          _categoryCard(context, d),
          const SizedBox(height: AppSpace.s3),
          _organizeCard(context, d),
          const SizedBox(height: AppSpace.s3),
          _reminderCard(context, d, today),
          const SizedBox(height: AppSpace.s3),
          _worthCard(context, d),
          const SizedBox(height: AppSpace.s3),
          _moreCard(context, d),
          if (_isEdit) ...[
            const SizedBox(height: AppSpace.s3),
            AppButton(
              label: l.subscriptionFormDelete,
              kind: AppButtonKind.dangerText,
              icon: AppIcons.delete,
              expand: true,
              onPressed: _delete,
            ),
          ],
        ],
      ),
      bottomNavigationBar: _bottomBar(context, blocked: errors.isNotEmpty),
    );
  }

  Widget _header(BuildContext context, SubscriptionDraft d, List<DraftError> errors) {
    final l = context.l10n;
    final c = context.colors;
    final nameError = errors.contains(DraftError.nameEmpty);
    final display = _name.text.trim();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label: l.subscriptionFormEditTile,
          excludeSemantics: true,
          onTap: _pickTile,
          child: GestureDetector(
            onTap: _pickTile,
            child: SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                children: [
                  ServiceTile(
                    name: display,
                    colorValue: d.colorValue,
                    iconText: d.iconText ?? (display.isEmpty ? '?' : null),
                    size: 56,
                    serviceId: d.serviceId,
                    logo: _photoImage(context),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: c.surface,
                        shape: BoxShape.circle,
                        boxShadow: context.elevation.card,
                        border: Border.all(color: c.line),
                      ),
                      child: Icon(AppIcons.edit, size: 13, color: c.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpace.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                style: AppType.title.copyWith(color: c.ink),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.subscriptionFormNameHint,
                  filled: false,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: c.line)),
                  enabledBorder: nameError
                      ? UnderlineInputBorder(borderSide: BorderSide(color: c.danger, width: 2))
                      : InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: nameError ? c.danger : c.brand, width: 2),
                  ),
                ),
              ),
              if (nameError) FieldError(l.subscriptionFormNameRequired),
              if (_plan != null) ...[
                const SizedBox(height: AppSpace.s1),
                _PlanChip(name: _plan!.name, onTap: _pickPlan),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceCard(BuildContext context, SubscriptionDraft d, List<DraftError> errors) {
    final l = context.l10n;
    final c = context.colors;
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final converted = (_price == null || d.currency == primary)
        ? null
        : calc.rates.convert(_price!, d.currency, primary);
    final o = _original;
    final changed = o != null && (o.priceMinor != d.priceMinor || o.currency != d.currency) && (_price ?? 0) > 0;
    final error = errors.contains(DraftError.priceNotPositive);
    return FormCard(
      error: error,
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AmountField(
                value: _price,
                currency: d.currency,
                label: d.trial ? l.subscriptionFormPriceAfterTrial : l.subscriptionFormPrice,
                onChanged: (v) => setState(() => _price = v),
                onCurrencyTap: _pickCurrency,
                conversion: converted == null ? null : l.amount(converted, primary, approx: true),
                errorText: error ? l.subscriptionFormPriceRequired : null,
              ),
              if (_refPrice != null && _price == _refPrice!.amount && d.currency == _refPrice!.currency) ...[
                const SizedBox(height: AppSpace.s2),
                Semantics(
                  label: l.subscriptionFormReferenceNote,
                  excludeSemantics: true,
                  child: Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: AppSpace.s1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const ReferencePriceChip(),
                      Text(l.subscriptionFormReferenceHint, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
              ],
              if (changed && o.status != SubscriptionStatus.cancelled) ...[
                const SizedBox(height: AppSpace.s3),
                Container(
                  padding: const EdgeInsets.all(AppSpace.s3),
                  decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(AppIcons.info, size: 16, color: c.onBrandSoft),
                      ),
                      const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: Text(
                          l.subscriptionFormPriceWas(
                            l.money(Money(o.priceMinor, o.currency)),
                            AppDates.short(l, d.dueDate, today: ref.watch(todayProvider)),
                          ),
                          style: AppType.meta.copyWith(color: c.onBrandSoft),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _cycleCard(BuildContext context, SubscriptionDraft d, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    const quick = [BillingCycle.weekly(), BillingCycle.monthly(), BillingCycle.quarterly(), BillingCycle.yearly()];
    final quickLabels = [
      l.subscriptionFormChipWeekly,
      l.subscriptionFormChipMonthly,
      l.subscriptionFormChipQuarterly,
      l.subscriptionFormChipYearly,
    ];
    final first = d.trial ? (d.trialEnd ?? d.dueDate) : d.dueDate;
    final then = d.nextDueDates(4).skip(1).map((x) => AppDates.short(l, x, today: today)).join(' · ');
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabelledRow(
                label: Text(l.subscriptionFormCycle, style: AppType.label.copyWith(color: c.ink)),
                // Wrap: at 320dp × 200% the unit button moves to the next line (a Row overflowed by 6px).
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpace.s2,
                  runSpacing: AppSpace.s2,
                  children: [
                    Text(l.subscriptionFormEvery, style: AppType.meta.copyWith(color: c.inkMuted)),
                    EveryCountField(
                      controller: _every,
                      onChanged: (n) => _update(() => d.cycle = BillingCycle(n, d.cycle.unit)),
                    ),
                    CycleUnitButton(
                      unit: d.cycle.unit,
                      every: d.cycle.every,
                      onChanged: (u) => _setCycle(BillingCycle(d.cycle.every, u)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.s3),
              // ≥ 150% text: a 2 × 2 grid (real phone, 320dp at 200%: one row cut the labels to "T…").
              for (final row
                  in MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5
                      ? const [
                          [0, 1],
                          [2, 3],
                        ]
                      : const [
                          [0, 1, 2, 3],
                        ]) ...[
                if (row.first > 0) const SizedBox(height: AppSpace.s2),
                Row(
                  children: [
                    for (final i in row) ...[
                      if (i != row.first) const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: AppChip(
                          label: quickLabels[i],
                          selected: d.cycle == quick[i],
                          showCheck: false,
                          fit: true,
                          onTap: () => _setCycle(quick[i]),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabelledRow(
                label: Text(
                  d.trial ? l.subscriptionFormFirstCharge : l.subscriptionFormNextDue,
                  style: AppType.label.copyWith(color: c.ink),
                ),
                trailing: MiniFieldButton(
                  label: FormFormat.dateLong(l, first),
                  icon: AppIcons.tabCalendar,
                  onTap: () => _pickDate(trialEnd: d.trial),
                ),
              ),
              const SizedBox(height: AppSpace.s2),
              Text(l.subscriptionFormThen(then), style: AppType.meta.copyWith(color: c.inkMuted).tabular),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trialShareCard(BuildContext context, SubscriptionDraft d, List<DraftError> errors) {
    final l = context.l10n;
    final c = context.colors;
    final today = ref.watch(todayProvider);
    final trialError = errors.contains(DraftError.trialEndInPast);
    return FormCard(
      children: [
        FormFieldPad(
          key: _trialKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ToggleField(
                title: l.subscriptionFormTrial,
                subtitle: l.subscriptionFormTrialSub,
                value: d.trial,
                onChanged: (v) => _update(() {
                  d.trial = v;
                  if (v) d.trialEnd ??= today.addDays(7);
                }),
              ),
              if (d.trial) ...[
                const SizedBox(height: AppSpace.s3),
                LabelledRow(
                  label: Text(l.subscriptionFormTrialEnds, style: AppType.body.copyWith(color: c.ink)),
                  trailing: MiniFieldButton(
                    label: d.trialEnd == null ? '—' : FormFormat.dateLong(l, d.trialEnd!),
                    icon: AppIcons.tabCalendar,
                    error: trialError,
                    onTap: () => _pickDate(trialEnd: true),
                  ),
                ),
                if (trialError) FieldError(l.subscriptionFormTrialEndInvalid, alignEnd: true),
              ],
            ],
          ),
        ),
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ToggleField(
                title: l.subscriptionFormShared,
                subtitle: l.subscriptionFormSharedSub,
                value: d.sharedWith > 1,
                onChanged: (v) => _update(() => d.sharedWith = v ? (_plan?.members ?? 2) : 1),
              ),
              if (d.sharedWith > 1) ...[
                const SizedBox(height: AppSpace.s3),
                LabelledRow(
                  label: Text(l.subscriptionFormPeople, style: AppType.body.copyWith(color: c.ink)),
                  trailing: AppStepper(
                    value: d.sharedWith,
                    min: 2,
                    max: 99,
                    decreaseLabel: l.coreFewer,
                    increaseLabel: l.coreMore,
                    onChanged: (n) => _update(() => d.sharedWith = n),
                  ),
                ),
                const SizedBox(height: AppSpace.s3),
                _SharePanel(
                  share: l.money(Money(d.myShareMinor, d.currency)),
                  per: perCycle(l, d.cycle),
                  of: l.subscriptionFormShareOf(l.money(Money(d.priceMinor, d.currency)), d.sharedWith),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(BuildContext context, SubscriptionDraft d) {
    final l = context.l10n;
    final c = context.colors;
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.subscriptionFormCategory, style: AppType.label.copyWith(color: c.ink)),
              const SizedBox(height: AppSpace.s3),
              Wrap(
                spacing: AppSpace.s2,
                children: [
                  for (final cat in categories)
                    AppChip(
                      label: l.categoryName(cat),
                      selected: d.categoryId == cat.id,
                      onTap: () => _update(() => d.categoryId = cat.id),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Labels (multi, "+ New label") and the Payment method row (png 26 / 36).
  Widget _organizeCard(BuildContext context, SubscriptionDraft d) {
    final l = context.l10n;
    final c = context.colors;
    final labels = ref.watch(labelsProvider).value ?? const <Label>[];
    // Keep the lists the payment-method sheet reads loaded (a stream read only on tap is still empty).
    ref
      ..watch(paymentMethodsProvider)
      ..watch(subscriptionsProvider);
    final method = d.paymentMethod?.trim() ?? '';
    final methodLabel = method.isEmpty ? l.subscriptionFormMethodNone : method;
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.subscriptionFormLabels, style: AppType.label.copyWith(color: c.ink)),
              const SizedBox(height: AppSpace.s2),
              Wrap(
                spacing: AppSpace.s2,
                children: [
                  for (final label in labels)
                    DotChip(
                      label: label.name,
                      selected: d.labelIds.contains(label.id),
                      dotColor: label.colorValue == null ? null : Color(label.colorValue!),
                      onTap: () => _update(() {
                        final ids = {...d.labelIds};
                        if (!ids.remove(label.id)) ids.add(label.id);
                        d.labelIds = ids;
                      }),
                    ),
                  DotChip(label: l.subscriptionFormNewLabel, dashed: true, onTap: _addLabel),
                ],
              ),
            ],
          ),
        ),
        FormFieldPad(
          child: LabelledRow(
            label: Text(l.subscriptionFormPaymentMethod, style: AppType.label.copyWith(color: c.ink)),
            trailing: MiniFieldButton(
              label: methodLabel,
              icon: AppIcons.expand,
              semanticLabel: '${l.subscriptionFormPaymentMethod}: $methodLabel',
              onTap: _pickMethod,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _addLabel() async {
    final name = await showNewLabelSheet(context);
    if (name == null || !mounted) return;
    final existing = (ref.read(labelsProvider).value ?? const <Label>[])
        .where((x) => x.name.trim().toLowerCase() == name.toLowerCase())
        .firstOrNull;
    final label = existing ?? await ref.read(organizeRepositoryProvider).addLabel(name);
    if (!mounted) return;
    _update(() => _draft!.labelIds = {..._draft!.labelIds, label.id});
  }

  Future<void> _pickMethod() async {
    final d = _draft!;
    final methods = ref.read(paymentMethodsProvider).value ?? const <PaymentMethod>[];
    final usage = <String, int>{};
    for (final s in ref.read(subscriptionsProvider).value ?? const <Subscription>[]) {
      final id = s.paymentMethodId;
      if (id != null) usage[id] = (usage[id] ?? 0) + 1;
    }
    final typed = PaymentMethod.normalizeName(d.paymentMethod ?? '');
    final selectedId =
        d.paymentMethodId ?? methods.where((m) => PaymentMethod.normalizeName(m.name) == typed).firstOrNull?.id;
    final choice = await showPaymentMethodSheet(
      context,
      methods: methods,
      usage: usage,
      selectedId: selectedId,
      onAdd: (name) => ref.read(organizeRepositoryProvider).addPaymentMethod(name),
    );
    if (choice == null || !mounted) return;
    // Picked from the list → set both id and name (M1 API); None → clear both.
    _update(() {
      d.paymentMethodId = choice.method?.id;
      d.paymentMethod = choice.method?.name;
    });
  }

  /// Remind me: each offset toggles on its own (on the day / 1 / 3 / 7 days); none = off.
  Widget _reminderCard(BuildContext context, SubscriptionDraft d, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final selected = d.reminderOffsets ?? settings?.defaultReminderOffsets ?? ReminderOffsets.defaults;
    final at = FormFormat.time(settings?.reminderHour ?? 9, settings?.reminderMinute ?? 0);
    final note = selected.isEmpty ? l.subscriptionFormRemindNone : l.subscriptionFormRemindMany(at);
    const choices = ReminderOffsets.choices;
    final large = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    final rows = large
        ? const [
            [0, 1],
            [2, 3],
          ]
        : const [
            [0, 1, 2, 3],
          ];
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.subscriptionFormReminder, style: AppType.label.copyWith(color: c.ink)),
              const SizedBox(height: AppSpace.s2),
              for (final row in rows) ...[
                if (row.first > 0) const SizedBox(height: AppSpace.s2),
                Row(
                  children: [
                    for (final i in row) ...[
                      if (i != row.first) const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: AppChip(
                          label: choices[i] == 0
                              ? l.subscriptionFormRemindOnDay
                              : l.subscriptionFormRemindDays(choices[i]),
                          selected: selected.contains(choices[i]),
                          showCheck: false,
                          fit: true,
                          onTap: () => _update(() {
                            final next = {...selected};
                            if (!next.remove(choices[i])) next.add(choices[i]);
                            d.reminderOffsets = next;
                          }),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: AppSpace.s2),
              Text(note, style: AppType.meta.copyWith(color: c.inkMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _worthCard(BuildContext context, SubscriptionDraft d) {
    final l = context.l10n;
    final c = context.colors;
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.subscriptionFormWorthIt, style: AppType.label.copyWith(color: c.ink)),
              const SizedBox(height: AppSpace.s3),
              WorthItPicker(value: d.worthIt, onChanged: (w) => _update(() => d.worthIt = w)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final o = _original;
    if (o == null) return;
    final ok = await showAppDialog<bool>(
      context,
      title: l.subscriptionFormDeleteTitle(o.name),
      body: l.subscriptionFormDeleteBody,
      actions: [
        AppButton.danger(
          label: l.subscriptionFormDeleteAction,
          expand: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
        ),
        AppButton.text(
          label: l.commonCancel,
          expand: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
        ),
      ],
    );
    if (ok != true || !mounted) return;
    await ref.read(subscriptionRepositoryProvider).delete(o.id);
    try {
      await ref.read(customLogoStoreProvider).delete(o.customLogoFile);
    } catch (_) {
      // Left over → removed by the start-up clean-up (app.dart).
    }
    if (mounted) context.go(AppRoutes.home);
  }

  Widget _moreCard(BuildContext context, SubscriptionDraft d) {
    final l = context.l10n;
    final c = context.colors;
    final header = Semantics(
      button: true,
      expanded: _more,
      child: InkWell(
        onTap: () => setState(() => _more = !_more),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: FormFieldPad(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.subscriptionFormMore, style: AppType.label.copyWith(color: c.ink)),
                    if (!_more) ...[
                      const SizedBox(height: 2),
                      Text(l.subscriptionFormMoreSub, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ],
                ),
              ),
              AnimatedRotation(
                turns: _more ? .5 : 0,
                duration: AppMotion.of(context, AppMotion.fast),
                child: Icon(AppIcons.expand, size: 20, color: c.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
    if (!_more) return FormCard(children: [header]);
    return FormCard(
      children: [
        header,
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldLabel(context, l.subscriptionFormManageUrl),
              TextField(
                controller: _url,
                keyboardType: TextInputType.url,
                onChanged: (_) => setState(() => _urlFromLibrary = false),
                decoration: InputDecoration(
                  hintText: 'https://',
                  prefixIcon: Icon(AppIcons.link, size: 18, color: c.inkMuted),
                ),
              ),
              if (_urlFromLibrary) ...[
                const SizedBox(height: AppSpace.s2),
                Text(l.subscriptionFormManageUrlFromLibrary, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ],
          ),
        ),
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldLabel(context, l.subscriptionFormNotes),
              TextField(controller: _notes, minLines: 3, maxLines: 6, maxLength: FormFormat.notesMax),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.s2),
    child: Text(text, style: AppType.meta.copyWith(color: context.colors.inkMuted)),
  );

  Widget _bottomBar(BuildContext context, {required bool blocked}) {
    final l = context.l10n;
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s3),
          child: AppButton.primary(
            label: _isEdit ? l.subscriptionFormSaveChanges : l.subscriptionFormAddButton,
            expand: true,
            loading: _saving,
            onPressed: blocked ? null : _save,
          ),
        ),
      ),
    );
  }
}

/// "Premium ⌄" plan pill under the name (opens the plan sheet).
class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: context.l10n.subscriptionFormPlan(name),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s3, vertical: 6),
              decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.full)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(name, style: AppType.label.copyWith(color: c.ink)),
                  ),
                  const SizedBox(width: AppSpace.s1),
                  Icon(AppIcons.expand, size: 16, color: c.ink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Your share ₫65,000/month · ₫260,000 ÷ 4" panel (`brand-soft`).
class _SharePanel extends StatelessWidget {
  const _SharePanel({required this.share, required this.per, required this.of});

  final String share;
  final String per;
  final String of;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpace.s4),
      decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: AppSpace.s3,
        runSpacing: AppSpace.s1,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.subscriptionFormYourShare, style: AppType.meta.copyWith(color: c.onBrandSoft)),
              Text.rich(
                TextSpan(
                  text: share,
                  style: AppType.title.copyWith(color: c.onBrandSoft).tabular,
                  children: [
                    TextSpan(
                      text: ' $per',
                      style: AppType.meta.copyWith(color: c.onBrandSoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(of, style: AppType.meta.copyWith(color: c.onBrandSoft).tabular),
        ],
      ),
    );
  }
}
