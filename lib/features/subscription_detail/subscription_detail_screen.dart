import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/catalog/catalog_providers.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';
import 'cancel_flow.dart';
import 'detail_parts.dart';
import 'detail_sheets.dart';
import 'payment_sheet.dart';

/// S5 Subscription details (mockup v14, png 044–062): hero tinted with the service colour (80px
/// logo, name, status chip + Auto-detected tag, amount + cycle chip, "Your share" / "≈"), banners
/// (to confirm · trial · paused / pausing · cancelled · library price notice · plan no longer sold ·
/// added automatically), the info card, Price history, Payment history, How to cancel, Pause /
/// Resume, Mark as cancelled (→ celebration) / Restore, and Delete.
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

  LocalDate get _today => ref.read(todayProvider);

  Future<void> _open(Uri link) async {
    var ok = false;
    try {
      ok = await launchUrl(link, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && mounted) {
      showAppToast(context, context.l10n.subscriptionDetailLinkFailed(linkHost(link)), icon: AppIcons.alert);
    }
  }

  Future<void> _delete(Subscription s) async {
    final l = context.l10n;
    final ok = await askTwoWay(
      context,
      title: l.subscriptionDetailDeleteTitle(s.name),
      body: l.subscriptionDetailDeleteBody,
      action: l.subscriptionDetailDeleteAction,
      keep: l.subscriptionDetailKeepIt,
      danger: true,
    );
    if (!ok || !mounted) return;
    final repo = ref.read(subscriptionRepositoryProvider);
    showAppToast(context, l.subscriptionDetailDeleted(s.name), icon: AppIcons.delete);
    context.go(AppRoutes.home);
    await repo.delete(s.id);
  }

  Future<void> _removeAuto(Subscription s) async {
    final l = context.l10n;
    final ok = await askTwoWay(
      context,
      title: l.subscriptionDetailAutoRemoveTitle(s.name),
      body: l.subscriptionDetailAutoRemoveBody((s.detectionSource ?? DetectionSource.scan).name),
      action: l.subscriptionDetailAutoRemove,
      keep: l.subscriptionDetailKeepIt,
      danger: true,
    );
    if (!ok || !mounted) return;
    final repo = ref.read(subscriptionRepositoryProvider);
    showAppToast(context, l.subscriptionDetailAutoRemoved(s.name), icon: AppIcons.delete);
    context.go(AppRoutes.home);
    // delete() remembers an Auto-detected subscription so it is never added again (ADR 0003).
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
      l.subscriptionDetailRestored(AppDates.weekdayShort(l, updated.dueDate, today: _today)),
      icon: AppIcons.restore,
    );
  }

  Future<void> _pause(Subscription s) async {
    final l = context.l10n;
    final today = _today;
    if (!await showPauseSheet(context, subscription: s, today: today) || !mounted) return;
    final repo = ref.read(subscriptionRepositoryProvider);
    await repo.pause(s.id);
    final updated = await repo.get(s.id);
    if (!mounted || updated?.pausedFrom == null) return;
    showAppToast(
      context,
      l.subscriptionDetailPaused(s.name, AppDates.short(l, updated!.pausedFrom!, today: today)),
      icon: LucideIcons.pause,
    );
  }

  Future<void> _resume(Subscription s) async {
    final l = context.l10n;
    final today = _today;
    final date = await showResumeSheet(context, subscription: s, today: today);
    if (date == null || !mounted) return;
    await ref.read(subscriptionRepositoryProvider).resume(s.id, date);
    if (!mounted) return;
    showAppToast(
      context,
      l.subscriptionDetailResumed(AppDates.weekdayShort(l, date, today: today)),
      icon: LucideIcons.play,
    );
  }

  /// "Undo" on the "Pauses from …" banner: back to Active with the same Due date (the pause only
  /// starts on that date, so nothing was skipped yet).
  Future<void> _undoPause(Subscription s) async {
    final l = context.l10n;
    final from = s.pausedFrom;
    if (from == null) return;
    await ref.read(subscriptionRepositoryProvider).resume(s.id, from);
    if (!mounted) return;
    showAppToast(
      context,
      l.subscriptionDetailPauseUndone(AppDates.weekdayShort(l, from, today: _today)),
      icon: AppIcons.restore,
    );
  }

  Future<void> _reviewNotice(Subscription s, PriceChangeNotice notice) async {
    final l = context.l10n;
    final today = _today;
    final from = BillingRules.hasSchedule(s.status) && s.dueDate.isAfter(today) ? s.dueDate : today;
    final choice = await showPriceNoticeSheet(context, notice: notice, from: from, today: today);
    if (choice == null || !mounted) return;
    final actions = ref.read(priceNoticeActionsProvider);
    if (choice == PriceNoticeChoice.update) {
      final ok = await actions.update(notice);
      if (!mounted) return;
      showAppToast(
        context,
        ok ? l.subscriptionDetailPriceUpdated(AppDates.short(l, from, today: today)) : l.subscriptionDetailPriceStale,
        icon: ok ? AppIcons.paid : AppIcons.alert,
      );
    } else {
      await actions.keepOldPrice(notice);
      if (!mounted) return;
      showAppToast(context, l.subscriptionDetailPriceKept(l.money(Money(notice.oldPriceMinor, notice.currency))));
    }
  }

  Future<void> _undoAutoConfirm(ConfirmedPeriod p) async {
    final l = context.l10n;
    await ref.read(subscriptionRepositoryProvider).undoAutoConfirm(p.id);
    if (mounted) showAppToast(context, l.subscriptionDetailAutoUndone, icon: AppIcons.restore);
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
                  child: Text(
                    l.commonNotFound,
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: c.inkMuted),
                  ),
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
    final categories = ref.watch(categoryByIdProvider);
    final allLabels = ref.watch(labelsProvider).value ?? const <Label>[];
    final periods = ref.watch(subscriptionPeriodsProvider(s.id)).value ?? const <ConfirmedPeriod>[];
    final priceChanges = ref.watch(subscriptionPriceHistoryProvider(s.id)).value;
    final notice = ref.watch(subscriptionPriceNoticeProvider(s.id));
    final planNote = ref.watch(subscriptionPlanNoteProvider(s.id));

    final status = BillingRules.effectiveStatus(s, today);
    final pending = BillingRules.pendingDueDates(s, today);
    final cancelled = status == SubscriptionStatus.cancelled;
    final trial = status == SubscriptionStatus.trial;
    final pausing = pausesOn(s, today);
    final paused = status == SubscriptionStatus.paused && pausing == null;
    final link = cancelLink(s, catalog);
    final off = cancelled || paused;

    // ---- Hero ----
    final badge = paused
        ? StatusBadge(label: l.subscriptionDetailStatusPaused, icon: LucideIcons.pause)
        : cancelled
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
        gradient: off
            ? null
            : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [tint, c.bg]),
      ),
      child: Column(
        children: [
          ServiceTile(
            name: s.name,
            colorValue: s.colorValue,
            iconText: s.iconText,
            size: 80,
            off: off,
            serviceId: s.serviceId,
            customLogoFile: s.customLogoFile,
          ),
          const SizedBox(height: 10),
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
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              badge,
              if (s.isAutoDetected)
                StatusBadge(label: l.commonAutoDetected, kind: BadgeKind.brand, icon: LucideIcons.sparkles),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpace.s2,
            runSpacing: 4,
            children: [
              TextScaleCap(
                max: AppTextScale.display,
                child: Text(
                  l.money(s.myShare),
                  maxLines: 1,
                  style: AppType.display.copyWith(fontSize: 30, height: 36 / 30, color: c.ink).tabular,
                ),
              ),
              CycleChip(cycle: s.cycle),
            ],
          ),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                if (subIcon != null) Icon(subIcon, size: 14, color: c.inkMuted),
                Text(
                  sub,
                  semanticsLabel: l.spokenLabel(sub),
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted).tabular,
                ),
              ],
            ),
          ],
        ],
      ),
    );

    // ---- Banners ----
    final yearly = calc.yearlyCost(s);
    final yearlyText = yearly == null ? l.money(s.myShare) : l.amount(yearly, primary, approx: s.currency != primary);
    final banners = <Widget>[
      if (pending.isNotEmpty)
        AppBanner(
          kind: BannerKind.warning,
          icon: AppIcons.awaiting,
          title: l.subscriptionDetailAwaitingTitle(pending.length, AppDates.short(l, pending.first, today: today)),
          body: l.subscriptionDetailAwaitingBody,
          actionLabel: l.subscriptionDetailConfirm,
          onAction: () => context.push(AppRoutes.confirm(s.id)),
        ),
      if (trial)
        AppBanner(
          kind: BannerKind.warning,
          icon: AppIcons.trial,
          title: l.subscriptionDetailTrialEnds(AppDates.weekdayShort(l, s.dueDate, today: today)),
          body: l.subscriptionDetailTrialSave(pricePerCycle(l, s), yearlyText),
        ),
      if (paused)
        AppBanner(
          kind: BannerKind.neutral,
          icon: LucideIcons.pause,
          title: l.subscriptionDetailPausedTitle(AppDates.full(l, s.pausedFrom ?? today)),
          body: l.subscriptionDetailPausedBody,
          actionLabel: l.subscriptionDetailResume,
          onAction: () => _resume(s),
        ),
      if (pausing != null)
        AppBanner(
          kind: BannerKind.info,
          icon: LucideIcons.pause,
          title: l.subscriptionDetailPausesTitle(AppDates.weekdayShort(l, pausing, today: today)),
          body: l.subscriptionDetailPausesBody,
          actionLabel: l.subscriptionDetailUndo,
          onAction: () => _undoPause(s),
        ),
      if (cancelled)
        AppBanner(
          kind: BannerKind.success,
          icon: AppIcons.savings,
          title: l.subscriptionDetailSaving(yearlyText),
          body: s.cancelledOn == null ? null : l.subscriptionDetailCancelledBody(AppDates.full(l, s.cancelledOn!)),
          actionLabel: l.subscriptionDetailRestoreShort,
          onAction: () => _restore(s),
        ),
      if (notice != null && !cancelled)
        AppBanner(
          kind: BannerKind.info,
          icon: AppIcons.category,
          title: l.subscriptionDetailNoticeTitle(l.money(Money(notice.newPriceMinor, notice.currency))),
          body: l.subscriptionDetailNoticeBody(l.money(Money(notice.oldPriceMinor, notice.currency))),
          actionLabel: l.subscriptionDetailNoticeReview,
          onAction: () => _reviewNotice(s, notice),
        ),
      if (planNote != null)
        AppBanner(
          kind: BannerKind.neutral,
          icon: LucideIcons.archive,
          title: switch (planNote.kind) {
            CatalogPlanNoteKind.discontinued => l.subscriptionDetailPlanGoneTitle,
            CatalogPlanNoteKind.closedToNew => l.subscriptionDetailPlanClosedTitle,
            CatalogPlanNoteKind.renamed => l.subscriptionDetailPlanRenamedTitle(planNote.plan.name),
          },
          body: switch (planNote.kind) {
            CatalogPlanNoteKind.discontinued => l.subscriptionDetailPlanGoneBody,
            CatalogPlanNoteKind.closedToNew => l.subscriptionDetailPlanClosedBody,
            CatalogPlanNoteKind.renamed => l.subscriptionDetailPlanRenamedBody(planNote.previousName ?? s.name),
          },
        ),
      if (s.isAutoDetected)
        AppBanner(
          kind: BannerKind.info,
          icon: LucideIcons.sparkles,
          title: l.subscriptionDetailAutoTitle,
          body: l.subscriptionDetailAutoBody(
            (s.detectionSource ?? DetectionSource.scan).name,
            AppDates.short(l, s.detectedAt == null ? s.startDate : LocalDate.fromDateTime(s.detectedAt!), today: today),
          ),
          actionLabel: l.subscriptionDetailAutoRemove,
          onAction: () => _removeAuto(s),
        ),
    ];

    // ---- Info card ----
    final paidPeriods = periods.where((p) => p.isPayment).toList();
    final samePrimary = paidPeriods.every((p) => p.currency == primary);
    final totalPaid = samePrimary
        ? l.money(Money(paidPeriods.fold(0, (a, p) => a + p.amountMinor), primary))
        : l.amount(calc.totalPaid(periods), primary, approx: true);
    final offsets = (s.reminderOffsets ?? settings?.defaultReminderOffsets ?? ReminderOffsets.defaults).toList()
      ..sort();
    final labels = [
      for (final x in allLabels)
        if (s.labelIds.contains(x.id)) x,
    ];
    final worthColor = switch (s.worthIt) {
      WorthIt.worth => c.success,
      WorthIt.notWorth => c.danger,
      WorthIt.unsure => c.warningInk,
      null => null,
    };
    final info = <Widget>[
      if (!off)
        DetailInfoRow(
          icon: AppIcons.tabCalendar,
          label: trial ? l.subscriptionDetailFirstPayment : l.subscriptionDetailNextPayment,
          subtitle: pending.isNotEmpty ? l.subscriptionDetailWaits : AppDates.relative(l, s.dueDate, today: today),
          value: AppDates.weekdayShort(l, s.dueDate, today: today),
        ),
      DetailInfoRow(
        icon: AppIcons.refresh,
        label: l.subscriptionDetailCycle,
        trailing: Align(
          alignment: AlignmentDirectional.centerEnd,
          widthFactor: 1,
          child: SelectedCycleChip(cycle: s.cycle),
        ),
      ),
      if (!cancelled)
        DetailInfoRow(
          icon: AppIcons.reminder,
          label: l.subscriptionDetailReminders,
          value: offsets.isEmpty ? l.subscriptionDetailRemindOff : offsets.map(l.reminderOffset).join(', '),
        ),
      DetailInfoRow(
        icon: _categoryIcon(s.categoryId),
        label: l.subscriptionDetailCategory,
        value: categoryLabel(l, s, categories),
      ),
      if (labels.isNotEmpty)
        DetailInfoRow(
          icon: AppIcons.category,
          label: l.subscriptionDetailLabels,
          trailing: Wrap(
            alignment: WrapAlignment.end,
            spacing: 4,
            runSpacing: 4,
            children: [for (final x in labels) DetailLabelChip(label: x)],
          ),
        ),
      if (s.paymentMethod != null && s.paymentMethod!.trim().isNotEmpty)
        DetailInfoRow(icon: AppIcons.payment, label: l.subscriptionDetailPaymentMethod, value: s.paymentMethod!),
      DetailInfoRow(
        icon: AppIcons.calendarCheck,
        label: l.subscriptionDetailSince,
        value: AppDates.full(l, s.startDate),
      ),
      DetailInfoRow(icon: LucideIcons.coins, label: l.subscriptionDetailTotalPaid, value: totalPaid, strong: true),
      DetailInfoRow(
        icon: switch (s.worthIt) {
          WorthIt.notWorth => LucideIcons.thumbsDown,
          WorthIt.unsure => LucideIcons.circleHelp,
          _ => LucideIcons.thumbsUp,
        },
        label: l.subscriptionDetailWorthIt,
        value: l.worthIt(s.worthIt),
        valueColor: worthColor,
        strong: worthColor != null,
      ),
      if (planNote != null)
        DetailInfoRow(
          icon: AppIcons.link,
          label: l.subscriptionDetailLibrary,
          value: switch (planNote.kind) {
            CatalogPlanNoteKind.discontinued => l.subscriptionDetailLibraryGone,
            CatalogPlanNoteKind.closedToNew => l.subscriptionDetailLibraryClosed,
            CatalogPlanNoteKind.renamed => l.subscriptionDetailLibraryRenamed,
          },
        ),
      if (s.notes != null && s.notes!.trim().isNotEmpty)
        DetailInfoRow(icon: AppIcons.note, label: l.subscriptionDetailNotes, subtitle: s.notes),
    ];

    // ---- Payment history: waiting periods (newest first), then confirmed ones ----
    final history = <Widget>[
      for (final d in pending.reversed)
        PaymentHistoryRow(
          date: AppDates.full(l, d),
          status: StatusBadge.awaiting(label: l.commonStatusAwaiting),
          amount: l.money(s.myShare),
          semanticHint: l.subscriptionDetailConfirmPeriod(AppDates.full(l, d)),
          onTap: () => context.push(AppRoutes.confirm(s.id)),
          action: AppButton.tonal(
            label: l.subscriptionDetailConfirm,
            small: true,
            onPressed: () => context.push(AppRoutes.confirm(s.id)),
          ),
        ),
      for (final p in periods)
        PaymentHistoryRow(
          date: AppDates.full(l, p.dueDate),
          status: PaymentStatusLine(
            paid: p.isPayment,
            label: p.isPayment ? l.subscriptionDetailPaid : l.subscriptionDetailDidntPay,
          ),
          amount: p.isPayment ? l.money(p.amount) : '—',
          editable: p.isPayment,
          sourceLabel: p.source == null ? null : l.subscriptionDetailPaidFrom(p.source!.name),
          undoLabel: p.source == null ? null : l.subscriptionDetailUndo,
          onUndo: p.source == null ? null : () => _undoAutoConfirm(p),
          semanticHint: p.isPayment ? l.subscriptionDetailEditPayment(AppDates.full(l, p.dueDate)) : null,
          onTap: p.isPayment
              ? () => showPaymentSheet(
                  context,
                  subscription: s,
                  period: p,
                  totalPaidMinor: paidPeriods
                      .where((x) => x.currency == p.currency)
                      .fold(0, (a, x) => a + x.amountMinor),
                )
              : null,
        ),
    ];

    Widget pad(Widget w, {double top = AppSpace.s4}) =>
        Padding(padding: EdgeInsets.fromLTRB(AppSpace.s4, top, AppSpace.s4, 0), child: w);

    final actions = <Widget>[
      if (!cancelled && link != null)
        AppGroup(
          dividerIndent: 52,
          children: [
            SettingRow(
              icon: AppIcons.external,
              label: l.subscriptionDetailHowToCancel,
              subtitle: l.subscriptionDetailOpens(linkHost(link)),
              external: true,
              onTap: () => _open(link),
            ),
          ],
        ),
      if (paused)
        AppButton.tonal(
          label: l.subscriptionDetailResume,
          icon: LucideIcons.play,
          expand: true,
          onPressed: () => _resume(s),
        )
      else if (!cancelled && pausing == null && BillingRules.hasSchedule(s.status))
        AppButton.outline(
          label: l.subscriptionDetailPause,
          icon: LucideIcons.pause,
          expand: true,
          onPressed: () => _pause(s),
        ),
      if (!cancelled)
        AppButton.outline(
          label: l.subscriptionDetailMarkCancelled,
          icon: AppIcons.cancelled,
          expand: true,
          onPressed: () => markCancelledFlow(context, ref, s),
        )
      else
        AppButton.tonal(
          label: l.subscriptionDetailRestore,
          icon: AppIcons.restore,
          expand: true,
          onPressed: () => _restore(s),
        ),
      AppButton(
        kind: AppButtonKind.dangerText,
        label: l.subscriptionDetailDelete,
        icon: AppIcons.delete,
        expand: true,
        onPressed: () => _delete(s),
      ),
    ];

    return ListView(
      controller: _scroll,
      padding: EdgeInsets.only(bottom: AppSpace.s6 + MediaQuery.paddingOf(context).bottom),
      children: [
        hero,
        if (banners.isNotEmpty)
          pad(
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < banners.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpace.s2),
                  banners[i],
                ],
              ],
            ),
            top: 0,
          ),
        pad(AppGroup(dividerIndent: 52, children: info)),
        pad(
          DetailSection(
            key: const ValueKey('price-history'),
            title: l.subscriptionDetailPriceHistory,
            dividerIndent: 9999,
            children: [
              if (priceChanges == null)
                const SizedBox(height: 64)
              else
                PriceHistoryList(subscription: s, changes: priceChanges, today: today),
            ],
          ),
          top: AppSpace.s6,
        ),
        pad(
          DetailSection(
            title: l.subscriptionDetailHistory,
            children: history.isEmpty
                ? [
                    DetailEmptyLine(
                      text: off
                          ? l.subscriptionDetailNoHistoryCancelled
                          : l.subscriptionDetailNoHistory(AppDates.weekdayShort(l, s.dueDate, today: today)),
                    ),
                  ]
                : history,
          ),
          top: AppSpace.s6,
        ),
        pad(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < actions.length; i++) ...[if (i > 0) const SizedBox(height: AppSpace.s2), actions[i]],
            ],
          ),
          top: AppSpace.s6,
        ),
      ],
    );
  }
}

/// Category icon (mockup `CAT_IC`); custom categories → circle-ellipsis.
IconData _categoryIcon(String categoryId) => switch (categoryId) {
  'video' => LucideIcons.film,
  'music' => LucideIcons.music,
  'ai' => LucideIcons.bot,
  'storage' => LucideIcons.cloud,
  'software' => LucideIcons.cpu,
  'gaming' => LucideIcons.gamepad2,
  'reading' => LucideIcons.bookOpen,
  'health' => LucideIcons.heartPulse,
  'education' => LucideIcons.graduationCap,
  'telecom' => LucideIcons.signal,
  _ => LucideIcons.circleEllipsis,
};
