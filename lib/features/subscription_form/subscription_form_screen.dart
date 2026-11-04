import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/utils/currencies.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S4 Add / edit subscription — PLACEHOLDER UI. Owned by the Add & onboarding session (H).
/// Business rules live in [SubscriptionDraft] (lib/domain) — keep using it.
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
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _every = TextEditingController();
  final _payment = TextEditingController();
  final _url = TextEditingController();
  final _notes = TextEditingController();
  List<DraftError> _errors = const [];

  bool get _isEdit => widget.subscriptionId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final today = ref.read(todayProvider);
    final primary = ref.read(primaryCurrencyProvider);
    SubscriptionDraft draft;
    if (_isEdit) {
      final s = await ref.read(subscriptionRepositoryProvider).get(widget.subscriptionId!);
      if (s == null) {
        if (mounted) context.pop();
        return;
      }
      _original = s;
      draft = SubscriptionDraft.fromSubscription(s, today);
    } else if (widget.serviceId != null) {
      final service = await ref.read(catalogRepositoryProvider).byId(widget.serviceId!);
      final plan = service?.plans.where((p) => p.id == widget.planId).firstOrNull ?? service?.plans.firstOrNull;
      final sub = (service == null || plan == null)
          ? null
          : subscriptionFromCatalog(
              service,
              plan,
              region: ref.read(catalogRegionProvider),
              id: 'draft',
              today: today,
              now: DateTime.now(),
            );
      draft = sub != null
          ? (SubscriptionDraft.fromSubscription(sub, today)..sharedWith = 1)
          : SubscriptionDraft.blank(currency: primary, today: today, name: service?.name ?? '')
        ..serviceId = service?.id
        ..category = service?.category ?? SubscriptionCategory.other
        ..colorValue = service?.colorValue ?? 0xFF607D8B
        ..iconText = service?.monogram;
    } else {
      draft = SubscriptionDraft.blank(currency: primary, today: today, name: widget.initialName ?? '');
    }
    _name.text = draft.name;
    _price.text = draft.priceMinor > 0 ? Fmt.editable(draft.priceMinor, draft.currency) : '';
    _every.text = '${draft.cycle.every}';
    _payment.text = draft.paymentMethod ?? '';
    _url.text = draft.manageUrl ?? '';
    _notes.text = draft.notes ?? '';
    if (mounted) setState(() => _draft = draft);
  }

  @override
  void dispose() {
    for (final c in [_name, _price, _every, _payment, _url, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncText() {
    final d = _draft!;
    d.name = _name.text;
    d.priceMinor = toMinorUnits(Fmt.parseAmount(_price.text, d.currency) ?? 0, d.currency);
    final every = int.tryParse(_every.text) ?? 1;
    d.cycle = BillingCycle(every < 1 ? 1 : every, d.cycle.unit);
    d.paymentMethod = _payment.text;
    d.manageUrl = _url.text;
    d.notes = _notes.text;
  }

  Future<void> _save() async {
    _syncText();
    final d = _draft!;
    final today = ref.read(todayProvider);
    final errors = d.validate(today);
    setState(() => _errors = errors);
    if (errors.isNotEmpty) return;
    final repo = ref.read(subscriptionRepositoryProvider);
    final now = DateTime.now();
    if (_isEdit) {
      final priceChanged = _original!.priceMinor != d.priceMinor;
      await repo.save(d.applyTo(_original!, now: now));
      if (!mounted) return;
      if (priceChanged) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.subscriptionFormPriceFromNext)));
      }
      context.pop();
    } else {
      await repo.save(d.toNew(id: repo.newId(), today: today, now: now));
      if (mounted) context.go(AppRoutes.home);
    }
  }

  Future<LocalDate?> _pickDate(LocalDate initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked == null ? null : LocalDate.fromDateTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final d = _draft;
    if (d == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final currencies = {...commonCurrencies, d.currency, primary}.toList();
    final price = Fmt.parseAmount(_price.text, d.currency) ?? 0;
    final converted = d.currency == primary ? null : calc.rates.convert(price, d.currency, primary);

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? l.subscriptionFormEditTitle : l.subscriptionFormAddTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              ServiceTile(name: _name.text, colorValue: d.colorValue, iconText: d.iconText, size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: l.subscriptionFormName,
                    errorText: _errors.contains(DraftError.nameEmpty) ? l.subscriptionFormNameRequired : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: d.trial ? l.subscriptionFormPriceAfterTrial : l.subscriptionFormPrice,
                    helperText: converted == null ? null : l.amount(converted, primary, approx: true),
                    errorText: _errors.contains(DraftError.priceNotPositive) ? l.subscriptionFormPriceRequired : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: d.currency,
                items: [for (final c in currencies) DropdownMenuItem(value: c, child: Text(c))],
                onChanged: (c) => setState(() => d.currency = c!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(l.subscriptionFormEvery),
              const SizedBox(width: 8),
              SizedBox(
                width: 56,
                child: TextField(
                  controller: _every,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(_syncText),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<CycleUnit>(
                value: d.cycle.unit,
                items: [
                  DropdownMenuItem(value: CycleUnit.day, child: Text(l.commonUnitDay)),
                  DropdownMenuItem(value: CycleUnit.week, child: Text(l.commonUnitWeek)),
                  DropdownMenuItem(value: CycleUnit.month, child: Text(l.commonUnitMonth)),
                  DropdownMenuItem(value: CycleUnit.year, child: Text(l.commonUnitYear)),
                ],
                onChanged: (u) => setState(() => d.cycle = BillingCycle(d.cycle.every, u!)),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final c in const [
                BillingCycle.weekly(),
                BillingCycle.monthly(),
                BillingCycle.quarterly(),
                BillingCycle.yearly(),
              ])
                ActionChip(
                  label: Text(l.cycle(c)),
                  onPressed: () => setState(() {
                    d.cycle = c;
                    _every.text = '${c.every}';
                  }),
                ),
            ],
          ),
          const Divider(height: 32),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.subscriptionFormTrial),
            value: d.trial,
            onChanged: (v) => setState(() {
              d.trial = v;
              d.trialEnd ??= ref.read(todayProvider).addDays(7);
            }),
          ),
          if (d.trial)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.subscriptionFormTrialEnds),
              subtitle: _errors.contains(DraftError.trialEndInPast)
                  ? Text(l.subscriptionFormTrialEndInvalid, style: TextStyle(color: Theme.of(context).colorScheme.error))
                  : null,
              trailing: Text(d.trialEnd == null ? '—' : l.date(d.trialEnd!)),
              onTap: () async {
                final picked = await _pickDate(d.trialEnd ?? ref.read(todayProvider));
                if (picked != null) setState(() => d.trialEnd = picked);
              },
            )
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.subscriptionFormNextDue),
              subtitle: Text(l.subscriptionFormThen(d.nextDueDates(3).skip(1).map(l.date).join(', '))),
              trailing: Text(l.date(d.dueDate)),
              onTap: () async {
                final picked = await _pickDate(d.dueDate);
                if (picked != null) setState(() => d.dueDate = picked);
              },
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.subscriptionFormShared),
            value: d.sharedWith > 1,
            onChanged: (v) => setState(() => d.sharedWith = v ? 2 : 1),
          ),
          if (d.sharedWith > 1)
            Row(
              children: [
                Text(l.subscriptionFormPeople(d.sharedWith)),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: d.sharedWith > 2 ? () => setState(() => d.sharedWith--) : null,
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => d.sharedWith++)),
                const Spacer(),
                Builder(
                  builder: (_) {
                    _syncText();
                    return Text(l.subscriptionFormMyShare(l.money(Money(d.myShareMinor, d.currency))));
                  },
                ),
              ],
            ),
          const Divider(height: 32),
          DropdownButtonFormField<SubscriptionCategory>(
            initialValue: d.category,
            decoration: InputDecoration(labelText: l.subscriptionFormCategory),
            items: [
              for (final c in SubscriptionCategory.values) DropdownMenuItem(value: c, child: Text(l.category(c))),
            ],
            onChanged: (c) => setState(() => d.category = c!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            initialValue: d.reminderDays,
            decoration: InputDecoration(labelText: l.subscriptionFormReminder),
            items: [
              DropdownMenuItem<int?>(value: null, child: Text(l.reminder(null))),
              for (final r in ReminderDays.choices) DropdownMenuItem<int?>(value: r, child: Text(l.reminder(r))),
            ],
            onChanged: (r) => setState(() => d.reminderDays = r),
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l.subscriptionFormAdvanced),
            children: [
              TextField(controller: _payment, decoration: InputDecoration(labelText: l.subscriptionFormPaymentMethod)),
              TextField(
                controller: _url,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(labelText: l.subscriptionFormManageUrl),
              ),
              TextField(controller: _notes, maxLines: 3, decoration: InputDecoration(labelText: l.subscriptionFormNotes)),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: Text(_isEdit ? l.subscriptionFormSaveChanges : l.subscriptionFormAddButton),
          ),
        ],
      ),
    );
  }
}
