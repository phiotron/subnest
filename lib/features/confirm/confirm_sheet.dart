import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';

/// S6 Confirm a Billing period (png 34–36) — bottom sheet route `/confirm/:id`, also the deep
/// link of the "due today" notification, the S2 swipe, the S5 banner and S7 rows.
///
/// Asks "Did you pay Netflix?" for the oldest pending period: amount (My share, editable),
/// where the next renewal moves, then Paid · Didn't pay this period · Later. Catching up: after
/// Paid / Didn't pay the sheet moves straight to the next pending period ("1 more after this")
/// with a short "1 Oct saved" line; after the last one it shows "Payment saved" + the next period.
class ConfirmSheet extends ConsumerStatefulWidget {
  const ConfirmSheet({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  ConsumerState<ConfirmSheet> createState() => _ConfirmSheetState();
}

/// The result shown after the last pending period was confirmed.
class _Done {
  const _Done({required this.paid, required this.period, required this.amount, required this.next});

  final bool paid;
  final LocalDate period;
  final String amount;
  final LocalDate next;
}

class _ConfirmSheetState extends ConsumerState<ConfirmSheet> {
  LocalDate? _amountFor;
  double? _amount;
  bool _amountError = false;
  bool _busy = false;

  /// "1 Oct saved · ₫150,000" after a catch-up step.
  String? _step;
  _Done? _done;

  Future<void> _confirm(Subscription s, LocalDate period, PeriodOutcome outcome) async {
    final l = context.l10n;
    final paid = outcome == PeriodOutcome.payment;
    if (paid && _amount == null) {
      setState(() => _amountError = true);
      return;
    }
    setState(() => _busy = true);
    final repo = ref.read(subscriptionRepositoryProvider);
    final amountMinor = paid ? toMinorUnits(_amount!, s.currency) : null;
    try {
      await repo.confirm(s.id, outcome, amountMinor: amountMinor);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (paid) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    final updated = await repo.get(s.id);
    if (!mounted || updated == null) return;
    final amountText = l.money(Money(amountMinor ?? 0, s.currency));
    final remaining = BillingRules.pendingDueDates(updated, ref.read(todayProvider));
    final day = AppDates.short(l, period, today: ref.read(todayProvider));
    setState(() {
      if (remaining.isNotEmpty) {
        _step = paid ? l.confirmSavedStep(day, amountText) : l.confirmSkippedStep(day);
      } else {
        _done = _Done(paid: paid, period: period, amount: amountText, next: updated.dueDate);
      }
    });
    SemanticsService.sendAnnouncement(
      View.of(context),
      remaining.isNotEmpty ? _step! : (paid ? l.confirmSaved : l.confirmSkippedTitle),
      Directionality.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final async = ref.watch(subscriptionProvider(widget.subscriptionId));
    final today = ref.watch(todayProvider);
    final catalog = ref.watch(catalogByIdProvider);
    final s = async.value;

    Widget content;
    if (_done != null && s != null) {
      content = _doneView(context, s, catalog, _done!);
    } else if (s == null) {
      content = async.isLoading
          ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
          : _message(context, l.confirmNothingTitle, l.commonNotFound);
    } else {
      final pending = BillingRules.pendingDueDates(s, today);
      if (pending.isEmpty) {
        final cancelled = BillingRules.effectiveStatus(s, today) == SubscriptionStatus.cancelled;
        content = _message(
          context,
          l.confirmNothingTitle,
          cancelled
              ? l.confirmNothingCancelled(s.name)
              : l.confirmNothingBody(s.name, AppDates.weekdayShort(l, s.dueDate, today: today)),
        );
      } else {
        content = _askView(context, s, pending, today, catalog);
      }
    }

    final mq = MediaQuery.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpace.s5,
        0,
        AppSpace.s5,
        AppSpace.s4 + mq.viewPadding.bottom + mq.viewInsets.bottom,
      ),
      child: AnimatedSize(
        duration: AppMotion.of(context, AppMotion.sheet),
        curve: AppMotion.sheetCurve,
        alignment: Alignment.topCenter,
        child: content,
      ),
    );
  }

  Widget _askView(
    BuildContext context,
    Subscription s,
    List<LocalDate> pending,
    LocalDate today,
    Map<String, CatalogService> catalog,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final period = pending.first;
    if (_amountFor != period) {
      _amountFor = period;
      _amount = toMajorUnits(s.myShareMinor, s.currency);
      _amountError = false;
    }
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final more = pending.length - 1;
    final chip = more > 0
        ? l.confirmMoreAfter(more)
        : (period == today ? l.confirmDueToday : l.confirmOverdue);
    // Where the Due date goes once this period is confirmed (BillingRules, not UI maths).
    final next = BillingRules.confirm(
      s,
      outcome: PeriodOutcome.payment,
      today: today,
      now: DateTime(today.year, today.month, today.day),
      newId: () => '',
    ).subscription.dueDate;
    final note = more > 0
        ? l.confirmNextUp(AppDates.short(l, pending[1], today: today))
        : l.confirmMovesNext(AppDates.weekdayShort(l, next, today: today));
    String? conversion;
    if (s.currency != primary && _amount != null) {
      final v = calc.rates.convert(_amount!, s.currency, primary);
      if (v != null) conversion = l.amount(v, primary, approx: true);
    }

    return Column(
      key: ValueKey('ask-$period'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_step != null) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: StatusBadge(label: _step!, kind: BadgeKind.success, icon: AppIcons.paid, large: true),
          ),
          const SizedBox(height: AppSpace.s3),
        ],
        Row(
          children: [
            ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 56),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    header: true,
                    child: Text(l.confirmQuestion(shortName(s, catalog)), style: AppType.title.copyWith(color: c.ink)),
                  ),
                  const SizedBox(height: AppSpace.s1),
                  Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: AppSpace.s1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusBadge(label: chip, kind: BadgeKind.warning, icon: AppIcons.awaiting, large: true),
                      Text(
                        l.confirmPeriodOf(AppDates.full(l, period)),
                        style: AppType.meta.copyWith(color: c.inkMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s5),
        AmountField(
          key: ValueKey('amount-$period'),
          value: _amount,
          currency: s.currency,
          label: l.confirmAmount,
          boxed: true,
          showEditButton: true,
          conversion: conversion,
          helper: s.isShared ? l.confirmYourShare(l.money(s.price), s.sharedWith) : l.confirmCurrentPrice,
          helperIcon: s.isShared ? AppIcons.shared : null,
          errorText: _amountError ? l.confirmAmountRequired : null,
          onChanged: (v) => setState(() {
            _amount = v;
            if (v != null) _amountError = false;
          }),
        ),
        const SizedBox(height: AppSpace.s3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(AppIcons.calendarClock, size: 16, color: c.inkMuted),
            ),
            const SizedBox(width: AppSpace.s2),
            Expanded(child: Text(note, style: AppType.meta.copyWith(color: c.inkMuted))),
          ],
        ),
        const SizedBox(height: AppSpace.s5),
        AppButton.primary(
          label: l.confirmPaid,
          icon: AppIcons.check,
          expand: true,
          loading: _busy,
          onPressed: () => _confirm(s, period, PeriodOutcome.payment),
        ),
        const SizedBox(height: AppSpace.s2),
        AppButton.outline(
          label: l.confirmSkip,
          expand: true,
          onPressed: _busy ? null : () => _confirm(s, period, PeriodOutcome.skipped),
        ),
        const SizedBox(height: AppSpace.s2),
        AppButton.text(label: l.confirmLater, expand: true, onPressed: () => context.pop()),
      ],
    );
  }

  Widget _doneView(BuildContext context, Subscription s, Map<String, CatalogService> catalog, _Done d) {
    final l = context.l10n;
    final c = context.colors;
    final (bg, fg, icon) = d.paid
        ? (c.successSoft, c.success, AppIcons.check)
        : (c.surface2, c.inkMuted, AppIcons.cancelled);
    return Column(
      key: const ValueKey('done'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpace.s4),
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: AppMotion.reduced(context) ? 1 : .6, end: 1),
            duration: AppMotion.of(context, AppMotion.paidPop),
            curve: Curves.easeOutBack,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 36, color: fg),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        Semantics(
          header: true,
          liveRegion: true,
          child: Text(
            d.paid ? l.confirmSaved : l.confirmSkippedTitle,
            textAlign: TextAlign.center,
            style: AppType.title.copyWith(color: c.ink),
          ),
        ),
        const SizedBox(height: AppSpace.s1),
        Text(
          [shortName(s, catalog), if (d.paid) d.amount, AppDates.full(l, d.period)].join(' · '),
          textAlign: TextAlign.center,
          style: AppType.body.copyWith(color: c.inkMuted).tabular,
        ),
        const SizedBox(height: AppSpace.s3),
        Center(
          child: StatusBadge(
            label: l.confirmNextPeriod(weekdayFull(l, d.next)),
            kind: BadgeKind.success,
            icon: AppIcons.tabCalendar,
            large: true,
          ),
        ),
        const SizedBox(height: AppSpace.s6),
        AppButton.tonal(label: l.confirmDone, expand: true, onPressed: () => context.pop()),
      ],
    );
  }

  Widget _message(BuildContext context, String title, String body) {
    final c = context.colors;
    return Column(
      key: const ValueKey('message'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppType.title.copyWith(color: c.ink)),
        const SizedBox(height: AppSpace.s2),
        Text(body, style: AppType.body.copyWith(color: c.inkMuted)),
        const SizedBox(height: AppSpace.s5),
        AppButton.tonal(label: context.l10n.confirmDone, expand: true, onPressed: () => context.pop()),
      ],
    );
  }
}
