import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';

/// S7 To confirm (png 37–39): every pending Billing period, oldest first. The oldest period of a
/// subscription has a quick ✓ (paid at My share); later ones are queued ("After 1 Oct", dimmed).
/// Tap a row → S6 sheet (change the amount / didn't pay). "Confirm all · ₫365,000" asks first
/// (each period paid at its current price). Empty: "You're all caught up 🎉".
class AwaitingScreen extends ConsumerWidget {
  const AwaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final items = ref.watch(awaitingPeriodsProvider);
    final today = ref.watch(todayProvider);
    final summary = ref.watch(spendingSummaryProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final loading = ref.watch(subscriptionsProvider).isLoading;

    Widget body;
    if (loading && items.isEmpty) {
      body = const Center(child: CircularProgressIndicator());
    } else if (items.isEmpty) {
      body = ListView(
        children: [
          EmptyState(
            art: const NestArt(kind: NestArtKind.party, width: 200),
            title: l.confirmCaughtUp,
            body: l.confirmCaughtUpBody,
            actionLabel: l.confirmBackHome,
            actionIcon: AppIcons.tabHome,
            onAction: () => context.go(AppRoutes.home),
          ),
        ],
      );
    } else {
      final rows = <Widget>[];
      final previous = <String, LocalDate>{};
      for (final (s, due) in items) {
        final before = previous[s.id];
        previous[s.id] = due;
        rows.add(
          _PendingRow(
            key: ValueKey('pending-${s.id}-$due'),
            subscription: s,
            due: due,
            queuedAfter: before,
            today: today,
            onQuickPay: () => _quickPay(context, ref, s, due, today),
          ),
        );
      }
      body = ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s6),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s1, 0, AppSpace.s1, AppSpace.s4),
            child: Text(l.confirmAwaitingIntro, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
          AppGroup(children: rows),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s4, AppSpace.s1, 0),
            child: Text(l.confirmAwaitingFooter, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        ],
      );
    }

    final subs = {for (final (s, _) in items) s};
    final total = l.amount(summary?.awaitingTotal ?? 0, primary, approx: anyConverted(subs, primary));
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppTopBar(title: l.confirmAwaitingTitle),
      body: body,
      bottomNavigationBar: items.isEmpty
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s3),
                  child: Builder(
                    builder: (context) {
                      // Large text: the total goes above the button so it never gets cut.
                      final big = MediaQuery.textScalerOf(context).scale(10) >= 13;
                      final button = AppButton.primary(
                        label: big ? l.confirmAllAction : l.confirmAllButton(total),
                        icon: AppIcons.check,
                        expand: true,
                        onPressed: () => _confirmAll(context, ref, items),
                      );
                      if (!big) return button;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(total, textAlign: TextAlign.center, style: AppType.titleSm.copyWith(color: c.ink).tabular),
                          const SizedBox(height: AppSpace.s2),
                          button,
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  /// Quick ✓: the oldest pending period paid at My share. The toast uses this screen's context
  /// because the row itself disappears once the period is confirmed.
  Future<void> _quickPay(BuildContext context, WidgetRef ref, Subscription s, LocalDate due, LocalDate today) async {
    final l = context.l10n;
    await ref.read(subscriptionRepositoryProvider).confirm(s.id, PeriodOutcome.payment);
    HapticFeedback.lightImpact();
    if (context.mounted) showAppToast(context, l.confirmQuickSaved(s.name, AppDates.short(l, due, today: today)));
  }

  Future<void> _confirmAll(BuildContext context, WidgetRef ref, List<(Subscription, LocalDate)> items) async {
    final l = context.l10n;
    final c = context.colors;
    // "Viettel 5G × 2  ₫300,000" — one line per subscription, in list order.
    final groups = <String, (Subscription, int)>{};
    for (final (s, _) in items) {
      final g = groups[s.id];
      groups[s.id] = (s, (g?.$2 ?? 0) + 1);
    }
    final ok = await showAppDialog<bool>(
      context,
      title: l.confirmAllTitle(items.length),
      body: l.confirmAllBody,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: AppSpace.s3),
            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(
              children: [
                for (final (s, n) in groups.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            n > 1 ? '${s.name} × $n' : s.name,
                            style: AppType.body.copyWith(color: c.ink),
                          ),
                        ),
                        const SizedBox(width: AppSpace.s3),
                        Text(
                          l.money(Money(s.myShareMinor * n, s.currency)),
                          style: AppType.body.copyWith(color: c.ink, fontWeight: FontWeight.w600).tabular,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          Text(l.confirmAllFooter, style: AppType.body.copyWith(color: c.inkMuted)),
        ],
      ),
      actions: [
        Builder(
          builder: (ctx) => AppButton.primary(
            label: l.confirmAllAction,
            expand: true,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ),
        Builder(
          builder: (ctx) => AppButton.text(
            label: l.confirmAllCancel,
            expand: true,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
        ),
      ],
    );
    if (ok != true) return;
    final ids = groups.keys.toList();
    final count = await ref.read(subscriptionRepositoryProvider).confirmAll(ids: ids);
    HapticFeedback.lightImpact();
    if (context.mounted) showAppToast(context, l.confirmAllSaved(count));
  }
}

/// One pending period: tile (warning dot, or dimmed when queued), name, "1 Oct · 34d ago"
/// (+ "🔒 After 1 Oct" when queued), amount, quick ✓ (44px circle in a 48dp target).
class _PendingRow extends StatelessWidget {
  const _PendingRow({
    super.key,
    required this.subscription,
    required this.due,
    required this.queuedAfter,
    required this.today,
    required this.onQuickPay,
  });

  final Subscription subscription;
  final LocalDate due;

  /// The earlier pending period of the same subscription; `null` = this one can be confirmed.
  final LocalDate? queuedAfter;
  final LocalDate today;
  final VoidCallback onQuickPay;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = subscription;
    final queued = queuedAfter != null;
    final ago = l.confirmAgo(-today.daysUntil(due));
    final dateText = AppDates.short(l, due, today: today);
    final quick = Semantics(
      button: true,
      enabled: !queued,
      label: queued ? l.confirmQueued(AppDates.short(l, queuedAfter!, today: today)) : l.confirmMarkPaid(s.name, dateText),
      excludeSemantics: true,
      child: Tooltip(
        message: queued ? l.confirmQueued(AppDates.short(l, queuedAfter!, today: today)) : l.confirmMarkPaid(s.name, dateText),
        excludeFromSemantics: true,
        child: InkResponse(
          // A queued period can't be confirmed yet: explain instead of falling through to the row.
          onTap: queued
              ? () => showAppToast(
                  context,
                  l.confirmQueued(AppDates.short(l, queuedAfter!, today: today)),
                  icon: AppIcons.privacyKey,
                )
              : onQuickPay,
          radius: 24,
          child: SizedBox.square(
            dimension: AppTouch.min,
            child: Center(
              child: Opacity(
                opacity: queued ? .6 : 1,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: queued ? c.surface2 : c.brandSoft, shape: BoxShape.circle),
                  child: Icon(AppIcons.check, size: 20, color: queued ? c.inkMuted : c.onBrandSoft),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final amount = Text(
      l.money(s.myShare),
      maxLines: 1,
      softWrap: false,
      style: AppType.titleSm.copyWith(color: c.ink).tabular,
    );
    // Large text (≥ 130%): the amount moves under the date so the name keeps its width.
    final stacked = MediaQuery.textScalerOf(context).scale(10) >= 13;

    return InkWell(
      onTap: () => context.push(AppRoutes.confirm(s.id)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSize.rowH),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(AppSpace.s4, 10, AppSpace.s3, 10),
          child: Row(
            children: [
              ServiceTile(
                name: s.name,
                colorValue: s.colorValue,
                iconText: s.iconText,
                awaiting: !queued,
                faded: queued,
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppType.titleSm.copyWith(color: c.ink)),
                    const SizedBox(height: 2),
                    Text('$dateText · $ago', style: AppType.meta.copyWith(color: c.inkMuted)),
                    if (stacked) ...[const SizedBox(height: 2), amount],
                    if (queued)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Icon(AppIcons.privacyKey, size: 13, color: c.inkMuted),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l.confirmAfter(AppDates.short(l, queuedAfter!, today: today)),
                                style: AppType.meta.copyWith(color: c.inkMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!stacked) ...[const SizedBox(width: AppSpace.s2), amount],
              const SizedBox(width: AppSpace.s1),
              quick,
            ],
          ),
        ),
      ),
    );
  }
}
