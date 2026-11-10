import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';
import 'payment_edits.dart';

/// S5 "edit a Payment" sheet (png 40): tile + "Payment · 4 Oct 2026" + Paid badge, the amount
/// (editable; "Was ₫65,000 — saving updates Total paid to ₫265,000."), paid on / paid with (read
/// only — the data model keeps the period date and the subscription's method), Save · Mark as
/// not paid · Cancel.
Future<void> showPaymentSheet(
  BuildContext context, {
  required Subscription subscription,
  required ConfirmedPeriod period,
  required int totalPaidMinor,
}) {
  return showAppSheet<void>(
    context,
    bare: true,
    builder: (_) => _PaymentSheet(subscription: subscription, period: period, totalPaidMinor: totalPaidMinor),
  );
}

class _PaymentSheet extends ConsumerStatefulWidget {
  const _PaymentSheet({required this.subscription, required this.period, required this.totalPaidMinor});

  final Subscription subscription;
  final ConfirmedPeriod period;

  /// Sum of this subscription's Payments in [ConfirmedPeriod.currency] minor units.
  final int totalPaidMinor;

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  late double? _amount = toMajorUnits(widget.period.amountMinor, widget.period.currency);
  bool _error = false;
  bool _busy = false;

  ConfirmedPeriod get p => widget.period;

  Future<void> _save() async {
    final l = context.l10n;
    if (_amount == null) {
      setState(() => _error = true);
      return;
    }
    setState(() => _busy = true);
    await ref.read(subscriptionRepositoryProvider).updatePeriodAmount(p.id, toMinorUnits(_amount!, p.currency));
    if (!mounted) return;
    Navigator.of(context).pop();
    showAppToast(context, l.subscriptionDetailPaymentUpdated);
  }

  Future<void> _markNotPaid() async {
    final l = context.l10n;
    setState(() => _busy = true);
    await ref.read(paymentEditsProvider).markNotPaid(p.id);
    if (!mounted) return;
    Navigator.of(context).pop();
    showAppToast(context, l.subscriptionDetailMarkedNotPaid, icon: AppIcons.cancelled);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = widget.subscription;
    final mq = MediaQuery.of(context);
    final newMinor = _amount == null ? null : toMinorUnits(_amount!, p.currency);
    String? helper;
    if (newMinor != null && newMinor != p.amountMinor) {
      final total = widget.totalPaidMinor - p.amountMinor + newMinor;
      helper = l.subscriptionDetailWas(l.money(p.amount), l.money(Money(total, p.currency)));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSpace.s5, 0, AppSpace.s5, AppSpace.s4 + mq.viewPadding.bottom + mq.viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 56, serviceId: s.serviceId, customLogoFile: s.customLogoFile),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l.subscriptionDetailPaymentTitle(AppDates.full(l, p.dueDate)),
                        style: AppType.title.copyWith(color: c.ink),
                      ),
                    ),
                    const SizedBox(height: AppSpace.s1),
                    Wrap(
                      spacing: AppSpace.s2,
                      runSpacing: AppSpace.s1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusBadge.paid(label: l.subscriptionDetailPaid),
                        Text(s.name, style: AppType.meta.copyWith(color: c.inkMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s5),
          AmountField(
            value: _amount,
            currency: p.currency,
            label: l.subscriptionDetailAmountPaid,
            boxed: true,
            showEditButton: true,
            helper: helper,
            helperIcon: helper == null ? null : AppIcons.info,
            errorText: _error ? l.subscriptionDetailAmountRequired : null,
            onChanged: (v) => setState(() {
              _amount = v;
              if (v != null) _error = false;
            }),
          ),
          const SizedBox(height: AppSpace.s3),
          AppGroup(
            dividerIndent: 52,
            children: [
              SettingRow(icon: AppIcons.tabCalendar, label: l.subscriptionDetailPaidOn, value: weekdayFull(l, p.dueDate)),
              if (s.paymentMethod != null && s.paymentMethod!.trim().isNotEmpty)
                SettingRow(icon: AppIcons.payment, label: l.subscriptionDetailPaidWith, value: s.paymentMethod),
            ],
          ),
          const SizedBox(height: AppSpace.s4),
          AppButton.primary(label: l.subscriptionDetailSave, expand: true, loading: _busy, onPressed: _save),
          const SizedBox(height: AppSpace.s2),
          AppButton.outline(label: l.subscriptionDetailMarkNotPaid, expand: true, onPressed: _busy ? null : _markNotPaid),
          const SizedBox(height: AppSpace.s2),
          AppButton.text(label: l.subscriptionDetailCancel, expand: true, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
