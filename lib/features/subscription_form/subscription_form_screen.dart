import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../catalog/catalog_helpers.dart';
import '../catalog/widgets/plan_sheet.dart';
import 'form_format.dart';
import 'widgets/currency_sheet.dart';
import 'widgets/form_parts.dart';
import 'widgets/tile_sheet.dart';

/// S4 Add / edit subscription (png 20–27). One screen for both: pre-filled from the Catalog
/// (`serviceId`/`planId`), a custom name, or an existing subscription (`subscriptionId`).
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

  /// Price in major units; `null` = empty.
  double? _price;
  bool _urlFromLibrary = false;
  bool _validated = false;
  bool _more = false;
  bool _saving = false;

  final _name = TextEditingController();
  final _every = TextEditingController();
  final _payment = TextEditingController();
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
    for (final c in [_name, _every, _payment, _url, _notes]) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  // ---- Loading -----------------------------------------------------------------------------

  Future<void> _load() async {
    final today = ref.read(todayProvider);
    final primary = ref.read(primaryCurrencyProvider);
    final region = ref.read(catalogRegionProvider);
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
    _payment.text = draft.paymentMethod ?? '';
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
    d.paymentMethod = _payment.text;
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
    final region = ref.read(catalogRegionProvider);
    final plan = await showPlanSheet(context, service: service, region: region, initial: _plan);
    if (plan == null || !mounted) return;
    final price = plan.priceFor(region);
    _update(() {
      _plan = plan;
      if (price != null) {
        _draft!.currency = price.currency;
        _price = price.amount;
      }
      _draft!.cycle = plan.cycle;
      _every.text = '${plan.cycle.every}';
    });
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
    );
    if (choice == null || !mounted) return;
    _update(() {
      d.colorValue = choice.colorValue;
      d.iconText = choice.iconText;
    });
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
    final toSave = o != null ? d.applyTo(o, now: now) : d.toNew(id: repo.newId(), today: today, now: now);
    // The spinner only runs while writing (not behind the price dialog).
    setState(() => _saving = true);
    try {
      await repo.save(toSave);
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
          _reminderCard(context, d, today),
          const SizedBox(height: AppSpace.s3),
          _moreCard(context, d),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l.subscriptionFormEvery, style: AppType.meta.copyWith(color: c.inkMuted)),
                    const SizedBox(width: AppSpace.s2),
                    EveryCountField(
                      controller: _every,
                      onChanged: (n) => _update(() => d.cycle = BillingCycle(n, d.cycle.unit)),
                    ),
                    const SizedBox(width: AppSpace.s2),
                    CycleUnitButton(
                      unit: d.cycle.unit,
                      every: d.cycle.every,
                      onChanged: (u) => _setCycle(BillingCycle(d.cycle.every, u)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.s3),
              Row(
                children: [
                  for (var i = 0; i < quick.length; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpace.s2),
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
                runSpacing: AppSpace.s2,
                children: [
                  for (final cat in SubscriptionCategory.values)
                    AppChip(
                      label: l.category(cat),
                      selected: d.category == cat,
                      onTap: () => _update(() => d.category = cat),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reminderCard(BuildContext context, SubscriptionDraft d, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final selected = d.reminderDays ?? settings?.defaultReminderDays ?? 3;
    final due = d.trial ? (d.trialEnd ?? d.dueDate) : d.dueDate;
    final String note;
    if (selected == ReminderDays.off) {
      note = l.subscriptionFormRemindNone;
    } else {
      final at = FormFormat.time(settings?.reminderHour ?? 9, settings?.reminderMinute ?? 0);
      note = l.subscriptionFormRemindAt(at, AppDates.weekdayShort(l, due.addDays(-selected), today: today));
    }
    return FormCard(
      children: [
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.subscriptionFormReminder, style: AppType.label.copyWith(color: c.ink)),
              const SizedBox(height: AppSpace.s2),
              AppSegmentedControl<int>(
                segments: [
                  for (final r in ReminderDays.choices)
                    AppSegment(
                      value: r,
                      label: switch (r) {
                        ReminderDays.off => l.subscriptionFormRemindOff,
                        ReminderDays.onTheDay => l.subscriptionFormRemindOnDay,
                        _ => l.subscriptionFormRemindDays(r),
                      },
                    ),
                ],
                selected: selected,
                onChanged: (r) => _update(() => d.reminderDays = r),
              ),
              const SizedBox(height: AppSpace.s2),
              Text(note, style: AppType.meta.copyWith(color: c.inkMuted)),
            ],
          ),
        ),
      ],
    );
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
    final current = _payment.text.trim();
    final suggestions = <String>{if (current.isNotEmpty) current, ...FormFormat.paymentSuggestions};
    return FormCard(
      children: [
        header,
        FormFieldPad(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fieldLabel(context, l.subscriptionFormPaymentMethod),
              TextField(
                controller: _payment,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.subscriptionFormPaymentHint,
                  prefixIcon: Icon(AppIcons.payment, size: 18, color: c.inkMuted),
                ),
              ),
              const SizedBox(height: AppSpace.s2),
              Wrap(
                spacing: AppSpace.s2,
                runSpacing: AppSpace.s2,
                children: [
                  for (final s in suggestions)
                    AppChip(
                      label: s,
                      selected: s == current,
                      showCheck: false,
                      onTap: () => setState(() => _payment.text = s),
                    ),
                ],
              ),
            ],
          ),
        ),
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
