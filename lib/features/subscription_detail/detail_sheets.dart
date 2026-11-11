import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/catalog/price_notices.dart';
import '../../domain/domain.dart';

/// Sheets and dialogs of S5 Detail (mockup v14): Pause (059), Resume (060), Update the price? (055),
/// Remove auto-detected (058), Delete (062). Each returns the user's choice; the screen writes.

/// `info-note`: `brand-soft` panel, 16px icon, 13/18 `on-brand-soft` text.
class InfoNote extends StatelessWidget {
  const InfoNote({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 16, color: c.onBrandSoft),
          ),
          const SizedBox(width: AppSpace.s2),
          Expanded(
            child: Text(text, style: AppType.meta.copyWith(color: c.onBrandSoft)),
          ),
        ],
      ),
    );
  }
}

/// `sh-head`: 56px logo, title (+ meta) beside it.
class SheetHead extends StatelessWidget {
  const SheetHead({super.key, required this.subscription, required this.title, this.meta, this.awaiting = false});

  final Subscription subscription;
  final String title;
  final Widget? meta;
  final bool awaiting;

  @override
  Widget build(BuildContext context) {
    final s = subscription;
    return Row(
      children: [
        ServiceTile(
          name: s.name,
          colorValue: s.colorValue,
          iconText: s.iconText,
          size: 56,
          awaiting: awaiting,
          serviceId: s.serviceId,
          customLogoFile: s.customLogoFile,
        ),
        const SizedBox(width: AppSpace.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                header: true,
                child: Text(title, style: AppType.title.copyWith(color: context.colors.ink)),
              ),
              if (meta != null) ...[const SizedBox(height: 2), meta!],
            ],
          ),
        ),
      ],
    );
  }
}

/// 059 Pause sheet: what still counts (now → Due date) and what stops (from the Due date), then
/// "Pause from 15 Nov". Returns `true` when the user pauses.
Future<bool> showPauseSheet(
  BuildContext context, {
  required Subscription subscription,
  required LocalDate today,
}) async {
  final l = context.l10n;
  final s = subscription;
  final from = s.dueDate;
  final ok = await showAppSheet<bool>(
    context,
    builder: (ctx) {
      final c = ctx.colors;
      Widget point(String title, String body, {required bool on}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: on ? c.brand : c.surface,
                shape: BoxShape.circle,
                border: Border.all(color: on ? c.brand : c.lineStrong, width: 2),
              ),
            ),
          ),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppType.label.copyWith(color: c.ink)),
                Text(body, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
        ],
      );
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHead(
              subscription: s,
              title: l.subscriptionDetailPauseTitle(s.name),
              meta: Text(l.subscriptionDetailPauseBody, style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
            const SizedBox(height: AppSpace.s5),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (from.isAfter(today)) ...[
                    point(
                      l.subscriptionDetailPauseNow(AppDates.short(l, from, today: today)),
                      l.subscriptionDetailPauseNowBody,
                      on: true,
                    ),
                    const SizedBox(height: 14),
                  ],
                  point(
                    l.subscriptionDetailPriceFrom(AppDates.weekdayShort(l, from, today: today)),
                    l.subscriptionDetailPauseFromBody,
                    on: !from.isAfter(today),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.s6),
            AppButton.primary(
              label: l.subscriptionDetailPauseAction(AppDates.short(l, from, today: today)),
              icon: LucideIcons.pause,
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
            const SizedBox(height: AppSpace.s2),
            AppButton.text(
              label: l.subscriptionDetailCancel,
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ],
        ),
      );
    },
  );
  return ok == true;
}

/// 060 Resume sheet: pick the next payment date (default today) on the month grid, then
/// "Resume from today" / "Resume from 20 Nov". Returns the date, or `null` when dismissed.
Future<LocalDate?> showResumeSheet(
  BuildContext context, {
  required Subscription subscription,
  required LocalDate today,
}) {
  final l = context.l10n;
  var picked = today;
  return showAppSheet<LocalDate>(
    context,
    bare: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final c = ctx.colors;
        final mq = MediaQuery.of(ctx);
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12, 0, 12, AppSpace.s4 + mq.viewPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        l.subscriptionDetailResumeTitle(subscription.name),
                        style: AppType.title.copyWith(color: c.ink),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(l.subscriptionDetailResumeAsk, style: AppType.meta.copyWith(color: c.inkMuted)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.s3),
              AppDatePicker(
                selected: picked,
                today: today,
                dimPast: false,
                onChanged: (d) => setState(() => picked = d),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpace.s3),
                    InfoNote(icon: AppIcons.info, text: l.subscriptionDetailResumeNote),
                    const SizedBox(height: AppSpace.s4),
                    AppButton.primary(
                      label: picked == today
                          ? l.subscriptionDetailResumeToday
                          : l.subscriptionDetailResumeFrom(AppDates.short(l, picked, today: today)),
                      icon: LucideIcons.play,
                      expand: true,
                      onPressed: () => Navigator.of(ctx).pop(picked),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

enum PriceNoticeChoice { update, keep }

/// 055 "Update the price?": You pay now → New price (+ "your share" when shared), where it applies
/// and that history keeps old payments, a Reference-price note when the new price isn't verified.
/// Returns the choice, or `null` when dismissed (asked again next time).
Future<PriceNoticeChoice?> showPriceNoticeSheet(
  BuildContext context, {
  required PriceChangeNotice notice,
  required LocalDate from,
  required LocalDate today,
}) {
  final l = context.l10n;
  final s = notice.subscription;
  final oldMoney = Money(notice.oldPriceMinor, notice.currency);
  final newMoney = Money(notice.newPriceMinor, notice.currency);
  final fromText = AppDates.short(l, from, today: today);
  return showAppSheet<PriceNoticeChoice>(
    context,
    builder: (ctx) {
      final c = ctx.colors;
      Widget col(String label, Money m, {required bool on}) {
        final fg = on ? c.onBrandSoft : c.inkMuted;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: on ? c.brandSoft : c.surface2,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppType.meta.copyWith(color: fg)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l.money(m),
                    maxLines: 1,
                    style: AppType.title.copyWith(color: on ? c.onBrandSoft : c.ink).tabular,
                  ),
                ),
                if (s.isShared)
                  Text(
                    l.subscriptionDetailShareOf(l.money(Money((m.minor / s.sharedWith).round(), m.currency))),
                    style: AppType.meta.copyWith(color: fg).tabular,
                  ),
              ],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHead(
              subscription: s,
              title: l.subscriptionDetailPriceSheetTitle,
              meta: Text(l.subscriptionDetailPriceSheetSub(s.name), style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
            const SizedBox(height: AppSpace.s4),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  col(l.subscriptionDetailYouPayNow, oldMoney, on: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
                    child: Icon(LucideIcons.arrowRight, size: 20, color: c.inkMuted),
                  ),
                  col(l.subscriptionDetailNewPrice, newMoney, on: true),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InfoNote(icon: LucideIcons.history, text: l.subscriptionDetailPriceSheetNote(fromText)),
            if (notice.isReference) ...[
              const SizedBox(height: AppSpace.s2),
              InfoNote(icon: AppIcons.info, text: l.subscriptionDetailReferencePrice),
            ],
            const SizedBox(height: AppSpace.s4),
            AppButton.primary(
              label: l.subscriptionDetailUpdateFrom(fromText),
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(PriceNoticeChoice.update),
            ),
            const SizedBox(height: AppSpace.s2),
            AppButton.text(
              label: l.subscriptionDetailKeepPrice(l.money(oldMoney)),
              expand: true,
              onPressed: () => Navigator.of(ctx).pop(PriceNoticeChoice.keep),
            ),
          ],
        ),
      );
    },
  );
}

/// Two stacked dialog actions: the main one ([danger] red or primary) + a text "keep" button.
/// Returns `true` for the main action.
Future<bool> askTwoWay(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
  required String keep,
  bool danger = false,
}) async {
  final ok = await showAppDialog<bool>(
    context,
    title: title,
    body: body,
    actions: [
      Builder(
        builder: (ctx) => danger
            ? AppButton.danger(label: action, expand: true, onPressed: () => Navigator.of(ctx).pop(true))
            : AppButton.primary(label: action, expand: true, onPressed: () => Navigator.of(ctx).pop(true)),
      ),
      Builder(
        builder: (ctx) => AppButton.text(label: keep, expand: true, onPressed: () => Navigator.of(ctx).pop(false)),
      ),
    ],
  );
  return ok == true;
}
