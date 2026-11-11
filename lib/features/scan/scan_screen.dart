import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/widgets/overview_v13.dart' show AutoBadge;
import 'scan_controller.dart';

/// S13 Scan screenshots / receipts (Pro, product.md §4.11, mockups v14 114–121): how it works →
/// before the photo picker → reading on the device → results (added / confirmed / needs your check /
/// different amount / not added, Undo per row) or nothing found. Text is read on the phone only.
/// Keep the class name + constructor (router).
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  static const googlePlaySubscriptions = 'https://play.google.com/store/account/subscriptions';
  static const appStoreSubscriptions = 'https://apps.apple.com/account/subscriptions';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(scanControllerProvider);
    final ctrl = ref.read(scanControllerProvider.notifier);
    final title = switch (s.stage) {
      ScanStage.reading => l.scanReadingTitle(s.toRead),
      ScanStage.results || ScanStage.nothing => l.scanResultsTitle,
      _ => l.scanTitle,
    };
    void close() {
      if (s.stage == ScanStage.results) ctrl.finish();
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }

    final (Widget body, Widget? bottom) = switch (s.stage) {
      ScanStage.intro => (const _Intro(), _IntroActions(ctrl)),
      ScanStage.picker => (const _PickerExplainer(), _PickerActions(ctrl)),
      ScanStage.reading => (_Reading(state: s), null),
      ScanStage.results => (_Results(state: s), _ResultActions(state: s, onDone: close)),
      ScanStage.nothing => (_Nothing(state: s), _NothingActions(ctrl)),
    };
    return PopScope(
      canPop: s.stage != ScanStage.results,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) close();
      },
      child: Scaffold(
        appBar: AppTopBar(title: title, close: true, onBack: close),
        body: body,
        bottomNavigationBar: bottom == null ? null : _BottomBar(child: bottom),
      ),
    );
  }
}

// ---- 114 How it works -----------------------------------------------------------------------

class _Intro extends ConsumerWidget {
  const _Intro();

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((Object _) => false);
    if (!ok && context.mounted) showAppToast(context, context.l10n.scanOpenStoreFailed, icon: AppIcons.alert);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
      children: [
        const _ScanArt(),
        _Steps([
          (null, l.scanStep1Title, l.scanStep1Body),
          (null, l.scanStep2Title, l.scanStep2Body),
          (null, l.scanStep3Title, l.scanStep3Body),
        ]),
        const SizedBox(height: AppSpace.s3),
        Row(
          children: [
            Expanded(
              child: AppButton.outline(
                label: l.scanOpenGooglePlay,
                icon: LucideIcons.store,
                small: true,
                expand: true,
                onPressed: () => _open(context, ScanScreen.googlePlaySubscriptions),
              ),
            ),
            const SizedBox(width: AppSpace.s2),
            Expanded(
              child: AppButton.outline(
                label: l.scanOpenAppStore,
                icon: LucideIcons.smartphone,
                small: true,
                expand: true,
                onPressed: () => _open(context, ScanScreen.appStoreSubscriptions),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s6),
        _Note(icon: LucideIcons.lock, text: l.scanPrivacy),
      ],
    );
  }
}

class _IntroActions extends StatelessWidget {
  const _IntroActions(this.ctrl);
  final ScanController ctrl;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(label: l.scanChooseScreenshots, icon: LucideIcons.images, onPressed: ctrl.chooseScreenshots),
        AppButton.text(label: l.scanPhotographReceipt, icon: LucideIcons.camera, onPressed: ctrl.photographReceipt),
      ],
    );
  }
}

// ---- 115 Before the photo picker ------------------------------------------------------------

class _PickerExplainer extends StatelessWidget {
  const _PickerExplainer();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            margin: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s4),
            decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(28)),
            child: Icon(LucideIcons.images, size: 40, color: c.onBrandSoft),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
          child: Text(
            l.scanPickerTitle,
            textAlign: TextAlign.center,
            style: AppType.title.copyWith(color: c.ink),
          ),
        ),
        const SizedBox(height: AppSpace.s2),
        _Steps([
          (LucideIcons.images, l.scanPicker1Title, l.scanPicker1Body),
          (LucideIcons.cpu, l.scanPicker2Title, l.scanPicker2Body),
          (LucideIcons.shield, l.scanPicker3Title, l.scanPicker3Body),
        ]),
        Text(
          l.scanPickerNote,
          textAlign: TextAlign.center,
          style: AppType.meta.copyWith(color: c.inkMuted),
        ),
      ],
    );
  }
}

class _PickerActions extends StatelessWidget {
  const _PickerActions(this.ctrl);
  final ScanController ctrl;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(label: l.scanContinue, onPressed: ctrl.pickScreenshots),
        AppButton.text(label: l.scanNotNow, onPressed: ctrl.backToIntro),
      ],
    );
  }
}

// ---- 116 Reading on the device --------------------------------------------------------------

class _Reading extends ConsumerWidget {
  const _Reading({required this.state});
  final ScanState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final match = ref.watch(scanCatalogMatchProvider);
    final left = math.max(1, (state.toRead - state.read) * 2 + 1);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
      children: [
        const _ScanArt(reading: true),
        const SizedBox(height: AppSpace.s4),
        Text(l.scanFoundSoFar(state.preview.length), style: AppType.label.copyWith(color: c.ink)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: math.max(.08, state.progress),
            minHeight: 6,
            color: c.brand,
            backgroundColor: c.surface2,
          ),
        ),
        const SizedBox(height: 6),
        Text(l.scanOnThisPhone(left), style: AppType.meta.copyWith(color: c.inkMuted)),
        const SizedBox(height: AppSpace.s4),
        if (state.preview.isNotEmpty)
          AppGroup(
            dividerIndent: 60,
            children: [
              for (final ch in state.preview)
                _ScanRow(
                  leading: _tileFor(ch.name, match(ch.name), size: 32),
                  title: Text(match(ch.name)?.name ?? ch.name),
                  lines: [_PriceLine(amount: Fmt.moneyOf(ch.amount, l.localeName), cycle: ch.cycle)],
                  trailing: SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: c.inkMuted),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

Widget _tileFor(String name, CatalogService? service, {double size = 40}) => ServiceTile(
  name: service?.name ?? name,
  colorValue: service?.colorValue ?? 0xFF607D8B,
  iconText: service?.monogram,
  serviceId: service?.id,
  size: size,
);

// ---- 118 / 119 / 120 Results ----------------------------------------------------------------

class _Results extends ConsumerWidget {
  const _Results({required this.state});
  final ScanState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final ctrl = ref.read(scanControllerProvider.notifier);
    final today = ref.watch(todayProvider);
    final match = ref.watch(scanCatalogMatchProvider);
    String money(int minor, String currency) => Fmt.moneyOf(Money(minor, currency), l.localeName);
    String date(LocalDate d) => AppDates.short(l, d, today: today);

    final added = state.keptAdded.length;
    final confirmed = state.keptConfirmed.length;
    final title = added > 0 && confirmed > 0
        ? l.scanAddedConfirmed(added, confirmed)
        : added > 0
        ? l.scanAddedOnly(added)
        : confirmed > 0
        ? l.scanConfirmedOnly(confirmed)
        : l.scanFoundOnly(state.review.length + state.notAdded.length);
    final from = state.screens > 0 && state.receipts > 0
        ? l.scanFromScreenshotsAndReceipts(state.screens, state.receipts)
        : state.receipts > 0
        ? l.scanFromReceipts(state.receipts)
        : l.scanFromScreenshots(state.screens);

    Widget undo(String id, VoidCallback onUndo) => state.undone.contains(id)
        ? Text(l.scanRemoved, style: AppType.meta.copyWith(color: c.inkMuted))
        : _LinkButton(label: l.scanUndo, onPressed: state.busy ? null : onUndo);

    final same = [
      for (final r in state.confirmed)
        if (!r.differentAmount) r,
    ];
    final different = [
      for (final r in state.confirmed)
        if (r.differentAmount) r,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
      children: [
        _ResultHead(icon: LucideIcons.check, title: title, meta: from),
        if (state.added.isNotEmpty) ...[
          _Eyebrow(l.scanGroupAdded),
          AppGroup(
            children: [
              for (final s in state.added)
                Opacity(
                  opacity: state.undone.contains(s.id) ? .55 : 1,
                  child: _ScanRow(
                    leading: ServiceTile(
                      name: s.name,
                      colorValue: s.colorValue,
                      iconText: s.iconText,
                      serviceId: s.serviceId,
                      customLogoFile: s.customLogoFile,
                    ),
                    title: Text(s.name),
                    badge: const AutoBadge(),
                    lines: [
                      _PriceLine(
                        amount: Fmt.moneyOf(s.myShare, l.localeName),
                        cycle: s.cycle,
                        after: l.scanNext(date(s.dueDate)),
                      ),
                    ],
                    trailing: undo(s.id, () async {
                      await ctrl.undoAdded(s);
                      if (context.mounted) {
                        showAppToast(context, l.scanRemovedToast(s.name), icon: LucideIcons.rotateCcw);
                      }
                    }),
                  ),
                ),
            ],
          ),
        ],
        if (same.isNotEmpty) ...[
          _Eyebrow(l.scanGroupConfirmed),
          AppGroup(
            children: [
              for (final r in same)
                _ScanRow(
                  leading: _subTile(r.subscription, r.period),
                  title: Text(r.subscription?.name ?? ''),
                  lines: [
                    Text(
                      l.scanPeriodPaid(date(r.period.dueDate), money(r.period.amountMinor, r.period.currency)),
                      style: AppType.meta.copyWith(color: c.inkMuted),
                    ),
                  ],
                  trailing: undo(r.period.id, () => ctrl.undoConfirmed(r)),
                ),
            ],
          ),
        ],
        if (state.review.isNotEmpty) ...[
          _Eyebrow(l.scanGroupReview, color: c.warningInk),
          _ReviewGroup(
            children: [
              for (final r in state.review)
                _ScanRow(
                  leading: ServiceTile(
                    name: r.subscription.name,
                    colorValue: r.subscription.colorValue,
                    iconText: r.subscription.iconText,
                    serviceId: r.subscription.serviceId,
                    customLogoFile: r.subscription.customLogoFile,
                  ),
                  title: Text(r.subscription.name),
                  lines: [
                    Text(_reviewText(l, r, money, date), style: AppType.meta.copyWith(color: c.inkMuted)),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpace.s2),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          AppButton.tonal(
                            label: l.scanItsThisPeriod,
                            small: true,
                            onPressed: state.busy ? null : () => ctrl.confirmReview(r),
                          ),
                          AppButton.text(label: l.scanNotThis, small: true, onPressed: () => ctrl.dismissReview(r)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
        if (different.isNotEmpty) ...[
          _Eyebrow(l.scanGroupDifferent),
          AppGroup(
            children: [
              for (final r in different)
                _ScanRow(
                  leading: _subTile(r.subscription, r.period),
                  title: Text(r.subscription?.name ?? ''),
                  lines: [
                    Text(
                      l.scanChargedOn(date(r.period.dueDate), money(r.period.amountMinor, r.period.currency)),
                      style: AppType.meta.copyWith(color: c.inkMuted),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(AppIcons.info, size: 13, color: c.warningInk),
                            ),
                            TextSpan(text: ' ${l.scanUsualPrice(Fmt.moneyOf(r.subscription!.myShare, l.localeName))}'),
                          ],
                        ),
                        style: AppType.meta.copyWith(color: c.warningInk),
                      ),
                    ),
                  ],
                  trailing: undo(r.period.id, () => ctrl.undoConfirmed(r)),
                ),
            ],
          ),
        ],
        if (state.notAdded.isNotEmpty) ...[
          _Eyebrow(l.scanGroupNotAdded),
          AppGroup(
            dividerIndent: 52,
            children: [
              for (final n in state.notAdded)
                _ScanRow(
                  leading: SizedBox(width: 24, child: Icon(LucideIcons.receipt, size: 20, color: c.inkMuted)),
                  title: Text('“${n.charge.name}” · ${money(n.charge.amountMinor, n.charge.currency)}'),
                  lines: [
                    Text(switch (n.reason) {
                      NotAddedReason.seenOnce => l.scanSeenOnce,
                      NotAddedReason.dismissed => l.scanDismissedBefore,
                      NotAddedReason.notBilling => l.scanNotBilling(n.subscription?.name ?? n.charge.name),
                      NotAddedReason.alreadyTracked => l.scanAlreadyTracked(n.subscription?.name ?? n.charge.name),
                    }, style: AppType.meta.copyWith(color: c.inkMuted)),
                  ],
                  trailing: n.reason == NotAddedReason.seenOnce
                      ? _LinkButton(
                          label: l.scanAdd,
                          onPressed: () => context.push(
                            AppRoutes.subscriptionNew(
                              serviceId: match(n.charge.name)?.id,
                              name: match(n.charge.name) == null ? n.charge.name : null,
                            ),
                          ),
                        )
                      : null,
                ),
            ],
          ),
        ],
      ],
    );
  }

  static Widget _subTile(Subscription? s, ConfirmedPeriod p) => ServiceTile(
    name: s?.name ?? '?',
    colorValue: s?.colorValue ?? 0xFF607D8B,
    iconText: s?.iconText,
    serviceId: s?.serviceId,
    customLogoFile: s?.customLogoFile,
  );

  static String _reviewText(
    AppLocalizations l,
    ReviewRow r,
    String Function(int, String) money,
    String Function(LocalDate) date,
  ) {
    final amount = money(r.charge.amountMinor, r.charge.currency);
    final due = r.subscription.dueDate;
    final gap = r.charge.date.daysUntil(due);
    if (gap > MatchThresholds.daysBeforeDue) return l.scanReviewBefore(amount, date(r.charge.date), gap, date(due));
    if (-gap > MatchThresholds.daysAfterDue) return l.scanReviewAfter(amount, date(r.charge.date), -gap, date(due));
    return l.scanReviewAmount(amount, date(r.charge.date), Fmt.moneyOf(r.subscription.myShare, l.localeName));
  }
}

class _ResultActions extends ConsumerWidget {
  const _ResultActions({required this.state, required this.onDone});
  final ScanState state;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctrl = ref.read(scanControllerProvider.notifier);
    final anyKept = state.keptAdded.isNotEmpty || state.keptConfirmed.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(label: l.scanDone, onPressed: onDone),
        if (anyKept)
          AppButton.text(
            label: l.scanUndoAll,
            onPressed: state.busy
                ? null
                : () async {
                    await ctrl.undoAll();
                    if (context.mounted) showAppToast(context, l.scanUndone, icon: LucideIcons.rotateCcw);
                  },
          ),
      ],
    );
  }
}

// ---- 121 Nothing found ----------------------------------------------------------------------

class _Nothing extends StatelessWidget {
  const _Nothing({required this.state});
  final ScanState state;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
      children: [
        _ResultHead(
          icon: LucideIcons.searchX,
          none: true,
          title: l.scanNothingTitle,
          meta: l.scanNothingMeta(math.max(1, state.toRead)),
        ),
        _Eyebrow(l.scanTryThis),
        Container(
          padding: const EdgeInsets.all(AppSpace.s4),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: context.elevation.card,
            border: context.isDark ? Border.all(color: c.line) : null,
          ),
          child: _Steps(gapTop: 0, [
            (null, l.scanTip1Title, l.scanTip1Body),
            (null, l.scanTip2Title, l.scanTip2Body),
            (null, l.scanTip3Title, l.scanTip3Body),
          ]),
        ),
      ],
    );
  }
}

class _NothingActions extends StatelessWidget {
  const _NothingActions(this.ctrl);
  final ScanController ctrl;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(label: l.scanChooseOther, icon: LucideIcons.images, onPressed: ctrl.pickScreenshots),
        AppButton.text(
          label: l.scanAddByHand,
          icon: LucideIcons.plus,
          onPressed: () => context.push(AppRoutes.catalog),
        ),
      ],
    );
  }
}

// ---- Parts ----------------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpace.s2),
        child: Padding(padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, 0), child: child),
      ),
    );
  }
}

/// Two tilted screenshot sketches and the scan badge (114), or a moving scan line (116).
class _ScanArt extends StatefulWidget {
  const _ScanArt({this.reading = false});
  final bool reading;

  @override
  State<_ScanArt> createState() => _ScanArtState();
}

class _ScanArtState extends State<_ScanArt> with SingleTickerProviderStateMixin {
  late final AnimationController _line = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.disableAnimationsOf(context);
    if (widget.reading && !still && !_line.isAnimating) {
      _line.repeat(reverse: true);
    } else if (still) {
      _line.stop();
    }
  }

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final first = widget.reading
        ? const [0xFF002BE7, 0xFF2D3438, 0xFFD83B01, 0xFFE50914]
        : const [0xFFE50914, 0xFF1DB954, 0xFF10A37F, 0xFF3693F3];
    final second = widget.reading ? const [0xFF58CC02, 0xFF10A37F] : const [0xFF002BE7, 0xFF2D3438, 0xFFD83B01];
    return ExcludeSemantics(
      child: SizedBox(
        height: 214,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: -4 * math.pi / 180,
                  child: _Shot(colors: first),
                ),
                const SizedBox(width: 14),
                Transform.translate(
                  offset: const Offset(0, 10),
                  child: Transform.rotate(
                    angle: 5 * math.pi / 180,
                    child: _Shot(colors: second),
                  ),
                ),
              ],
            ),
            if (!widget.reading)
              Positioned(
                bottom: 8,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle, boxShadow: context.elevation.float),
                  child: Icon(LucideIcons.scanLine, size: 22, color: c.onBrand),
                ),
              )
            else
              AnimatedBuilder(
                animation: _line,
                builder: (context, _) => Align(
                  alignment: Alignment(0, -.3 + .6 * Curves.easeInOut.transform(_line.value)),
                  child: FractionallySizedBox(
                    widthFactor: .56,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: c.brand,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [BoxShadow(color: c.brand.withValues(alpha: .55), blurRadius: 16, spreadRadius: 4)],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Shot extends StatelessWidget {
  const _Shot({required this.colors});
  final List<int> colors;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 104,
      height: 170,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: context.elevation.card,
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FractionallySizedBox(
            widthFactor: .6,
            child: Container(
              height: 8,
              decoration: BoxDecoration(color: c.line, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const SizedBox(height: 14),
          for (final col in colors) ...[
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(color: Color(col), borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// Numbered (or icon) steps: 28px `brand-soft` circle, title-sm + meta (design `.steps`).
class _Steps extends StatelessWidget {
  const _Steps(this.items, {this.gapTop = AppSpace.s3});
  final List<(IconData?, String, String)> items;
  final double gapTop;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: gapTop, bottom: AppSpace.s4),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: c.brandSoft, shape: BoxShape.circle),
                  child: items[i].$1 != null
                      ? Icon(items[i].$1, size: 18, color: c.onBrandSoft)
                      : Text(
                          '${i + 1}',
                          style: AppType.label.copyWith(color: c.onBrandSoft, fontWeight: FontWeight.w700),
                          textScaler: TextScaler.noScaling,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].$2, style: AppType.titleSm.copyWith(color: c.ink)),
                      const SizedBox(height: 2),
                      Text(items[i].$3, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// `surface-2` note with a brand icon (design `.privacy`).
class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.brand),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        ],
      ),
    );
  }
}

class _ResultHead extends StatelessWidget {
  const _ResultHead({required this.icon, required this.title, required this.meta, this.none = false});
  final IconData icon;
  final String title;
  final String meta;
  final bool none;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s5, AppSpace.s4, AppSpace.s2),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: none ? c.surface2 : c.successSoft, shape: BoxShape.circle),
            child: Icon(icon, size: none ? 30 : 32, color: none ? c.inkMuted : c.success),
          ),
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppType.title.copyWith(color: c.ink),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            meta,
            textAlign: TextAlign.center,
            style: AppType.meta.copyWith(color: c.inkMuted),
          ),
        ],
      ),
    );
  }
}

/// Group eyebrow (design `.grp-head`): caption, 24 above, 8 below.
class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.label, {this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s6, AppSpace.s1, AppSpace.s2),
    child: Semantics(
      header: true,
      child: Text(
        label.toUpperCase(),
        style: AppType.caption.copyWith(color: color ?? context.colors.inkMuted, letterSpacing: .6),
      ),
    ),
  );
}

/// "Needs your check" group: card with a 1.5px `warning` ring (design `.group.review`).
class _ReviewGroup extends StatelessWidget {
  const _ReviewGroup({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: context.elevation.card,
        border: Border.all(color: c.warning, width: 1.5),
      ),
      child: Column(children: children),
    );
  }
}

/// A result row (design `.srow`): leading tile, name (+ badge), lines, trailing action.
class _ScanRow extends StatelessWidget {
  const _ScanRow({required this.leading, required this.title, this.badge, this.lines = const [], this.trailing});
  final Widget leading;
  final Widget title;
  final Widget? badge;
  final List<Widget> lines;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wrap: at 200% text the Auto badge drops under the name instead of overflowing.
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      DefaultTextStyle(
                        style: AppType.body.copyWith(color: c.ink, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: title,
                      ),
                      if (badge != null) FittedBox(fit: BoxFit.scaleDown, child: badge),
                    ],
                  ),
                  ...lines,
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: AppSpace.s2), trailing!],
          ],
        ),
      ),
    );
  }
}

/// "$9.99 [Monthly] · next 24 Nov".
class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.amount, this.cycle, this.after});
  final String amount;
  final BillingCycle? cycle;
  final String? after;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = AppType.meta.copyWith(color: c.inkMuted).tabular;
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 2,
        children: [
          Text(amount, style: style),
          if (cycle != null) CycleChip(cycle: cycle!),
          if (after != null) Text('· $after', style: style),
        ],
      ),
    );
  }
}

/// Text-link button (design `.link.label`), 48dp touch target.
class _LinkButton extends StatelessWidget {
  const _LinkButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
      foregroundColor: context.colors.brand,
      textStyle: AppType.label,
    ),
    child: Text(label),
  );
}
