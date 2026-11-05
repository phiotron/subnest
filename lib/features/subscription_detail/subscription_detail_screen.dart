import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';
import 'cancel_flow.dart';
import 'payment_sheet.dart';

/// S5 Subscription details (png 28–33, 40): hero tinted with the service colour + status chip,
/// the amount (+ "Your share · plan … ÷ 4" / "≈ …"), the awaiting / trial / cancelled banner,
/// the info card, payment history (tap a Payment to edit it), "How to cancel this service",
/// Mark as cancelled (→ celebration) / Restore, and Delete (dialog).
class SubscriptionDetailScreen extends ConsumerStatefulWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  ConsumerState<SubscriptionDetailScreen> createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends ConsumerState<SubscriptionDetailScreen> {
  final _scroll = ScrollController();
  bool _solidBar = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final solid = _scroll.offset > 24;
      if (solid != _solidBar) setState(() => _solidBar = solid);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _open(Uri link) async {
    var ok = false;
    try {
      ok = await launchUrl(link, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && mounted) showAppToast(context, context.l10n.subscriptionDetailLinkFailed(linkHost(link)), icon: AppIcons.alert);
  }

  Future<void> _delete(Subscription s, int records) async {
    final l = context.l10n;
    final ok = await showAppDialog<bool>(
      context,
      title: l.subscriptionDetailDeleteTitle(s.name),
      body: l.subscriptionDetailDeleteBody(records),
      actions: [
        Builder(
          builder: (ctx) => AppButton.danger(
            label: l.subscriptionDetailDeleteAction,
            expand: true,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ),
        Builder(
          builder: (ctx) => AppButton.text(
            label: l.subscriptionDetailKeepIt,
            expand: true,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ),
      ],
    );
    if (ok != true || !mounted) return;
    final repo = ref.read(subscriptionRepositoryProvider);
    showAppToast(context, l.subscriptionDetailDeleted(s.name), icon: AppIcons.delete);
    context.go(AppRoutes.home);
    await repo.delete(s.id);
  }

  Future<void> _restore(Subscription s) async {
    final l = context.l10n;
    final repo = ref.read(subscriptionRepositoryProvider);
    await repo.restore(s.id);
    final updated = await repo.get(s.id);
    if (!mounted || updated == null) return;
    showAppToast(
      context,
      l.subscriptionDetailRestored(AppDates.weekdayShort(l, updated.dueDate, today: ref.read(todayProvider))),
      icon: AppIcons.restore,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final async = ref.watch(subscriptionProvider(widget.subscriptionId));
    final s = async.value;
    final mq = MediaQuery.of(context);
    final barHeight = mq.padding.top + 52;

    Widget content;
    if (s == null) {
      content = Padding(
        padding: EdgeInsets.only(top: barHeight),
        child: Center(
          child: async.isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(AppSpace.s6),
                  child: Text(l.commonNotFound, textAlign: TextAlign.center, style: AppType.body.copyWith(color: c.inkMuted)),
                ),
        ),
      );
    } else {
      content = _body(context, s, barHeight);
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: Stack(
        children: [
          Positioned.fill(child: content),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              height: barHeight,
              padding: EdgeInsets.only(top: mq.padding.top, left: AppSpace.s1, right: AppSpace.s2),
              decoration: BoxDecoration(
                color: _solidBar ? c.bg : c.bg.withValues(alpha: 0),
                border: Border(bottom: BorderSide(color: _solidBar ? c.line : c.line.withValues(alpha: 0))),
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: AppIcons.back,
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  if (s != null)
                    AppButton.text(
                      label: l.subscriptionDetailEdit,
                      small: true,
                      onPressed: () => context.push(AppRoutes.subscriptionEdit(s.id)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, Subscription s, double barHeight) {
    final l = context.l10n;
    final c = context.colors;
    final today = ref.watch(todayProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final settings = ref.watch(settingsProvider).value;
    final catalog = ref.watch(catalogByIdProvider);
    final kept = ref.watch(keptTrialsProvider);
    final periods = ref.watch(subscriptionPeriodsProvider(s.id)).value ?? const <ConfirmedPeriod>[];

    final status = BillingRules.effectiveStatus(s, today);
    final pending = BillingRules.pendingDueDates(s, today);
    final cancelled = status == SubscriptionStatus.cancelled;
    final trial = status == SubscriptionStatus.trial;
    final link = cancelLink(s, catalog);

    // ---- Hero ----
    final badge = cancelled
        ? StatusBadge(label: l.subscriptionDetailStatusCancelled, icon: AppIcons.cancelled)
        : trial
        ? StatusBadge(
            label: l.subscriptionDetailStatusTrial(BillingRules.daysUntilDue(s, today).clamp(0, 9999)),
            kind: BadgeKind.warning,
            icon: AppIcons.trial,
          )
        : pending.isNotEmpty
        ? StatusBadge.awaiting(label: l.commonStatusAwaiting)
        : StatusBadge(label: l.subscriptionDetailStatusActive, kind: BadgeKind.success, icon: AppIcons.paid);

    String? sub;
    IconData? subIcon;
    if (s.isShared) {
      sub = l.subscriptionDetailYourShare(l.money(s.price), s.sharedWith);
      subIcon = AppIcons.shared;
    } else if (s.currency != primary) {
      final v = calc.periodCost(s);
      if (v != null) sub = l.amount(v, primary, approx: true);
    }
    final tint = Color.lerp(c.bg, Color(s.colorValue), .16)!;
    final hero = Container(
      padding: EdgeInsets.fromLTRB(AppSpace.s4, barHeight + AppSpace.s3, AppSpace.s4, AppSpace.s5),
      decoration: BoxDecoration(
        gradient: cancelled ? null : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [tint, c.bg]),
      ),
      child: Column(
        children: [
          ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 80, off: cancelled),
          const SizedBox(height: AppSpace.s4),
          Semantics(
            header: true,
            child: Text(
              s.name,
              textAlign: TextAlign.center,
              style: AppType.headline.copyWith(color: c.ink),
              textScaler: AppTextScale.capped(context, AppTextScale.headline),
            ),
          ),
          const SizedBox(height: 6),
          badge,
          const SizedBox(height: AppSpace.s3),
          TextScaleCap(
            max: AppTextScale.display,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: l.money(s.myShare),
                      style: AppType.display.copyWith(fontSize: 30, height: 36 / 30, color: c.ink).tabular,
                    ),
                    TextSpan(text: ' ${perCycle(l, s.cycle)}', style: AppType.meta.copyWith(color: c.inkMuted)),
                  ],
                ),
                maxLines: 1,
              ),
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                if (subIcon != null) Icon(subIcon, size: 14, color: c.inkMuted),
                Text(sub, textAlign: TextAlign.center, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
              ],
            ),
          ],
        ],
      ),
    );

    // ---- Banner block ----
    final banners = <Widget>[];
    if (pending.isNotEmpty) {
      banners.add(
        AppBanner(
          kind: BannerKind.warning,
          icon: AppIcons.awaiting,
          title: l.subscriptionDetailAwaitingTitle(pending.length, AppDates.short(l, pending.first, today: today)),
          body: l.subscriptionDetailAwaitingBody(l.money(s.myShare)),
          actionLabel: l.subscriptionDetailConfirm,
          onAction: () => context.push(AppRoutes.confirm(s.id)),
        ),
      );
    } else if (trial) {
      banners
        ..add(
          AppBanner(
            kind: BannerKind.warning,
            icon: AppIcons.trial,
            title: l.subscriptionDetailTrialEnds(AppDates.weekdayShort(l, s.dueDate, today: today)),
            body: l.subscriptionDetailTrialBody(pricePerCycle(l, s)),
          ),
        )
        ..add(
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s3),
            child: _ButtonPair(
              first: link == null
                  ? null
                  : AppButton.primary(
                      label: l.subscriptionDetailHowToCancel,
                      icon: AppIcons.external,
                      expand: true,
                      onPressed: () => _open(link),
                    ),
              firstLabel: l.subscriptionDetailHowToCancel,
              second: AppButton.outline(
                label: l.subscriptionDetailKeepIt,
                expand: true,
                onPressed: kept.contains(s.id)
                    ? null
                    : () {
                        ref.read(keptTrialsProvider.notifier).keep(s.id);
                        showAppToast(
                          context,
                          l.subscriptionDetailKept(shortName(s, catalog), AppDates.weekdayShort(l, s.dueDate, today: today)),
                        );
                      },
              ),
              secondLabel: l.subscriptionDetailKeepIt,
            ),
          ),
        );
    } else if (cancelled) {
      final yearly = calc.yearlyCost(s);
      banners
        ..add(
          AppBanner(
            kind: BannerKind.success,
            icon: AppIcons.savings,
            title: l.subscriptionDetailSaving(
              yearly == null ? l.money(s.myShare) : l.amount(yearly, primary, approx: s.currency != primary),
            ),
            body: s.cancelledOn == null ? null : l.subscriptionDetailCancelledBody(AppDates.full(l, s.cancelledOn!)),
          ),
        )
        ..add(
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s3),
            child: AppButton.tonal(
              label: l.subscriptionDetailRestore,
              icon: AppIcons.restore,
              expand: true,
              onPressed: () => _restore(s),
            ),
          ),
        );
    }

    // ---- Info card ----
    final paidPeriods = periods.where((p) => p.isPayment).toList();
    final samePrimary = paidPeriods.every((p) => p.currency == primary);
    final totalPaid = samePrimary
        ? l.money(Money(paidPeriods.fold(0, (a, p) => a + p.amountMinor), primary))
        : l.amount(calc.totalPaid(periods), primary, approx: true);
    final reminderDays = s.reminderDays ?? settings?.defaultReminderDays ?? 3;
    final time = '${settings?.reminderHour ?? 9}:${(settings?.reminderMinute ?? 0).toString().padLeft(2, '0')}';
    final info = <Widget>[
      if (!cancelled)
        _InfoRow(
          icon: AppIcons.tabCalendar,
          label: trial ? l.subscriptionDetailFirstCharge : l.subscriptionDetailNextRenewal,
          subtitle: pending.isNotEmpty ? l.subscriptionDetailWaits : AppDates.relative(l, s.dueDate, today: today),
          value: AppDates.weekdayShort(l, s.dueDate, today: today),
        ),
      _InfoRow(icon: AppIcons.refresh, label: l.subscriptionDetailCycle, value: _every(l, s.cycle)),
      if (!cancelled)
        _InfoRow(
          icon: AppIcons.reminder,
          label: l.subscriptionDetailRemindMe,
          value: reminderDays == ReminderDays.off
              ? l.subscriptionDetailRemindOff
              : l.subscriptionDetailRemindValue(reminderDays, time),
        ),
      _InfoRow(icon: AppIcons.category, label: l.subscriptionDetailCategory, value: l.category(s.category)),
      if (s.paymentMethod != null && s.paymentMethod!.trim().isNotEmpty)
        _InfoRow(icon: AppIcons.payment, label: l.subscriptionDetailPaymentMethod, value: s.paymentMethod!),
      _InfoRow(icon: AppIcons.calendarCheck, label: l.subscriptionDetailSince, value: AppDates.full(l, s.startDate)),
      _InfoRow(icon: AppIcons.currency, label: l.subscriptionDetailTotalPaid, value: totalPaid, strong: true),
      if (s.notes != null && s.notes!.trim().isNotEmpty)
        _InfoRow(icon: AppIcons.note, label: l.subscriptionDetailNotes, subtitle: s.notes),
    ];

    // ---- History ----
    final history = <Widget>[
      for (final d in pending.reversed)
        _HistoryRow(
          date: AppDates.full(l, d),
          status: StatusBadge.awaiting(label: l.commonStatusAwaiting),
          amount: l.money(s.myShare),
          semanticHint: l.subscriptionDetailConfirmPeriod(AppDates.full(l, d)),
          onTap: () => context.push(AppRoutes.confirm(s.id)),
        ),
      for (final p in periods)
        _HistoryRow(
          date: AppDates.full(l, p.dueDate),
          status: _HistoryStatus(paid: p.isPayment, label: p.isPayment ? l.subscriptionDetailPaid : l.subscriptionDetailDidntPay),
          amount: p.isPayment ? l.money(p.amount) : '—',
          editable: p.isPayment,
          semanticHint: p.isPayment ? l.subscriptionDetailEditPayment(AppDates.full(l, p.dueDate)) : null,
          onTap: p.isPayment
              ? () => showPaymentSheet(
                  context,
                  subscription: s,
                  period: p,
                  totalPaidMinor: paidPeriods.where((x) => x.currency == p.currency).fold(0, (a, x) => a + x.amountMinor),
                )
              : null,
        ),
    ];

    Widget pad(Widget w, {double top = AppSpace.s4}) =>
        Padding(padding: EdgeInsets.fromLTRB(AppSpace.s4, top, AppSpace.s4, 0), child: w);

    return ListView(
      controller: _scroll,
      padding: EdgeInsets.only(bottom: AppSpace.s8 + MediaQuery.paddingOf(context).bottom),
      children: [
        hero,
        if (banners.isNotEmpty)
          pad(
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: banners),
            top: 0,
          ),
        pad(AppGroup(dividerIndent: 52, children: info)),
        pad(SectionHeader(label: l.subscriptionDetailHistory, padding: const EdgeInsets.fromLTRB(AppSpace.s1, 0, AppSpace.s1, AppSpace.s2)), top: AppSpace.s6),
        pad(
          history.isEmpty
              ? AppCard(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s5),
                  child: Text(
                    cancelled
                        ? l.subscriptionDetailNoHistoryCancelled
                        : l.subscriptionDetailNoHistory(AppDates.weekdayShort(l, s.dueDate, today: today)),
                    textAlign: TextAlign.center,
                    style: AppType.meta.copyWith(color: c.inkMuted),
                  ),
                )
              : AppGroup(dividerIndent: AppSpace.s4, children: history),
          top: 0,
        ),
        if (!cancelled && link != null)
          pad(
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: AppIcons.external,
                  label: l.subscriptionDetailHowToCancelRow,
                  subtitle: l.subscriptionDetailOpens(linkHost(link)),
                  external: true,
                  onTap: () => _open(link),
                ),
              ],
            ),
            top: AppSpace.s6,
          ),
        if (!cancelled)
          pad(
            AppButton.outline(
              label: l.subscriptionDetailMarkCancelled,
              icon: AppIcons.cancelled,
              expand: true,
              onPressed: () => markCancelledFlow(context, ref, s),
            ),
            top: link != null ? AppSpace.s3 : AppSpace.s6,
          ),
        pad(
          AppButton(
            kind: AppButtonKind.dangerText,
            label: l.subscriptionDetailDelete,
            icon: AppIcons.delete,
            expand: true,
            onPressed: () => _delete(s, periods.length),
          ),
          top: AppSpace.s2,
        ),
      ],
    );
  }

  String _every(AppLocalizations l, BillingCycle c) => switch (c.unit) {
    CycleUnit.day => l.subscriptionDetailEveryDay(c.every),
    CycleUnit.week => l.subscriptionDetailEveryWeek(c.every),
    CycleUnit.month => l.subscriptionDetailEveryMonth(c.every),
    CycleUnit.year => l.subscriptionDetailEveryYear(c.every),
  };
}

/// Two buttons side by side (trial: "How to cancel" + "Keep it"): equal halves when both labels
/// fit, otherwise widths follow the labels, and stacked when even that does not fit (VI, 200%).
class _ButtonPair extends StatelessWidget {
  const _ButtonPair({required this.first, required this.firstLabel, required this.second, required this.secondLabel});

  final Widget? first;
  final String firstLabel;
  final Widget second;
  final String secondLabel;

  double _natural(BuildContext context, String label, {bool icon = false}) {
    final tp = TextPainter(
      text: TextSpan(text: label, style: AppType.label.copyWith(fontSize: 16, height: 20 / 16)),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final w = tp.width + AppSpace.s5 * 2 + (icon ? 20 + AppSpace.s2 : 0) + 2;
    tp.dispose();
    return w;
  }

  @override
  Widget build(BuildContext context) {
    if (first == null) return second;
    return LayoutBuilder(
      builder: (context, box) {
        const gap = AppSpace.s2;
        final a = _natural(context, firstLabel, icon: true);
        final b = _natural(context, secondLabel);
        final half = (box.maxWidth - gap) / 2;
        if (a <= half && b <= half) {
          return Row(children: [Expanded(child: first!), const SizedBox(width: gap), Expanded(child: second)]);
        }
        if (a + b + gap <= box.maxWidth) {
          final extra = (box.maxWidth - gap - a - b) / 2;
          return Row(
            children: [
              SizedBox(width: a + extra, child: first),
              const SizedBox(width: gap),
              SizedBox(width: b + extra, child: second),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [first!, const SizedBox(height: gap), second],
        );
      },
    );
  }
}

/// Info-card row (design `srow` with a value): 24px icon slot, label (+ meta sub-line), value on
/// the right. Unlike `SettingRow` the value keeps its natural width (up to 60% of the row) so
/// "3 days before, 9:00" stays on one line; it wraps to two lines only at large text.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, this.subtitle, this.value, this.strong = false});

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? value;

  /// Bold `ink` value (Total paid).
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // ≥ 150% text: the value goes under the label (real phone, 320dp at 200%: the label column was
    // squeezed to a few letters and words broke mid-word — "Nh/ắc/trư/ớc").
    final stacked = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    final valueStyle = strong
        ? AppType.body.copyWith(color: c.ink, fontWeight: FontWeight.w700).tabular
        : AppType.body.copyWith(color: c.inkMuted).tabular;
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: LayoutBuilder(
            builder: (context, box) => Row(
              crossAxisAlignment: stacked ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                SizedBox(width: 24, child: Icon(icon, size: 20, color: c.inkMuted)),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: AppType.body.copyWith(fontWeight: FontWeight.w500, height: 20 / 15, color: c.ink)),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle!, style: AppType.meta.copyWith(color: c.inkMuted)),
                        ),
                      if (stacked && value != null)
                        Padding(
                          key: const ValueKey('info-value-below'),
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(value!, style: valueStyle),
                        ),
                    ],
                  ),
                ),
                if (!stacked && value != null) ...[
                  const SizedBox(width: AppSpace.s3),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: box.maxWidth * .6),
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: valueStyle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "✓ Paid" (success) / "⊘ Didn't pay" (muted), 13/600 with a 16px icon.
class _HistoryStatus extends StatelessWidget {
  const _HistoryStatus({required this.paid, required this.label});

  final bool paid;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = paid ? c.success : c.inkMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(paid ? AppIcons.paid : AppIcons.cancelled, size: 16, color: fg),
        const SizedBox(width: 4),
        Flexible(child: Text(label, style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: fg))),
      ],
    );
  }
}

/// One payment-history row: date, status line, amount (+ pencil when editable).
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.date,
    required this.status,
    required this.amount,
    this.editable = false,
    this.semanticHint,
    this.onTap,
  });

  final String date;
  final Widget status;
  final String amount;
  final bool editable;
  final String? semanticHint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(date, style: AppType.body.copyWith(fontWeight: FontWeight.w500, color: c.ink)),
                  const SizedBox(height: 4),
                  Align(alignment: AlignmentDirectional.centerStart, child: status),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.s3),
            Text(
              amount,
              maxLines: 1,
              softWrap: false,
              style: AppType.body.copyWith(color: c.inkMuted).tabular,
            ),
            if (editable) ...[const SizedBox(width: AppSpace.s3), Icon(AppIcons.edit, size: 18, color: c.inkMuted)],
          ],
        ),
      ),
    );
    if (onTap == null) return MergeSemantics(child: row);
    return Semantics(
      button: true,
      hint: semanticHint,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}
