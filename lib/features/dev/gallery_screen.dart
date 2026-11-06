import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/domain.dart';

/// Debug-only component gallery (`/dev/gallery`, long-press the Settings tab in a debug build).
/// Every design-system component × state, with local switches for theme, language, text size
/// (100/130%) and frame width (full/360) — for the UI sessions and design review.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({
    super.key,
    this.initialPage = 0,
    this.initialDark = false,
    this.initialVi = false,
    this.initialLarge = false,
    this.initialNarrow = false,
  });

  /// `/dev/gallery?page=3&dark=1&vi=1&large=1&narrow=1` (handy for adb screenshots:
  /// `adb shell am start -n com.phiotron.subnest/.MainActivity --es route "/dev/gallery?page=3&dark=1"`).
  factory GalleryScreen.fromQuery(Map<String, String> q) => GalleryScreen(
    initialPage: (int.tryParse(q['page'] ?? '') ?? 0).clamp(0, pages.length - 1),
    initialDark: q['dark'] == '1',
    initialVi: q['vi'] == '1',
    initialLarge: q['large'] == '1',
    initialNarrow: q['narrow'] == '1',
  );

  final int initialPage;
  final bool initialDark;
  final bool initialVi;
  final bool initialLarge;
  final bool initialNarrow;

  static const pages = [
    // index 6 = 'Form inputs' (RadioRow, AmountField) — appended so older ?page= links stay valid.
    'Tokens',
    'Tiles & badges',
    'Buttons & controls',
    'Rows & hero',
    'Banners & empty',
    'Sheets & pickers',
    'Form inputs',
  ];

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late int _page = widget.initialPage;
  late bool _dark = widget.initialDark;
  late bool _vi = widget.initialVi;
  late bool _large = widget.initialLarge;
  late bool _narrow = widget.initialNarrow;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Localizations.override(
      context: context,
      locale: Locale(_vi ? 'vi' : 'en'),
      child: Theme(
        data: _dark ? AppTheme.dark() : AppTheme.light(),
        child: MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(_large ? 1.3 : 1)),
          child: Builder(
            builder: (context) {
              final c = context.colors;
              return Scaffold(
                backgroundColor: c.bg,
                appBar: AppTopBar(
                  title: 'Gallery · ${GalleryScreen.pages[_page]}',
                  trailing: AppIconButton(
                    icon: AppIcons.theme,
                    tooltip: 'Light / dark',
                    onPressed: () => setState(() => _dark = !_dark),
                  ),
                ),
                body: Column(
                  children: [
                    _controls(context),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: _narrow ? 360 : double.infinity,
                          child: ListView(
                            key: ValueKey(_page),
                            padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, 120),
                            children: switch (_page) {
                              0 => _tokens(context),
                              1 => _tiles(context),
                              2 => _controlsPage(context),
                              3 => _rows(context),
                              4 => _banners(context),
                              5 => _sheets(context),
                              _ => _forms(context),
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _controls(BuildContext context) {
    Widget toggle(String label, bool on, VoidCallback tap) => Padding(
      padding: const EdgeInsets.only(right: AppSpace.s2),
      child: AppChip(label: label, selected: on, onTap: tap, showCheck: false),
    );
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
          child: Row(
            children: [
              for (var i = 0; i < GalleryScreen.pages.length; i++)
                toggle(GalleryScreen.pages[i], i == _page, () => setState(() => _page = i)),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
          child: Row(
            children: [
              toggle(_dark ? 'Dark' : 'Light', _dark, () => setState(() => _dark = !_dark)),
              toggle(_vi ? 'VI' : 'EN', _vi, () => setState(() => _vi = !_vi)),
              toggle(_large ? 'Text 130%' : 'Text 100%', _large, () => setState(() => _large = !_large)),
              toggle(_narrow ? '360 frame' : 'Full width', _narrow, () => setState(() => _narrow = !_narrow)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------------------------

  static const _today = LocalDate(2026, 11, 4);

  String t(String en, String vi) => _vi ? vi : en;

  String _money(BuildContext context, double v, [String cur = 'VND']) => context.l10n.amount(v, cur);

  Widget _h(BuildContext context, String s) => SectionHeader(label: s);

  // ---- Tokens ---------------------------------------------------------------------------------

  List<Widget> _tokens(BuildContext context) {
    final c = context.colors;
    return [
      _h(context, 'Colour'),
      Wrap(
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s2,
        children: [
          for (final e in c.byName.entries)
            SizedBox(
              width: 104,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: e.value,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: c.line),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(e.key, style: AppType.caption.copyWith(letterSpacing: 0, color: c.inkMuted)),
                ],
              ),
            ),
        ],
      ),
      _h(context, 'Type'),
      for (final (name, style) in [
        ('display', AppType.display.tabular),
        ('amount-lg', AppType.amountLg.tabular),
        ('headline', AppType.headline),
        ('title', AppType.title),
        ('title-sm', AppType.titleSm),
        ('body', AppType.body),
        ('label', AppType.label),
        ('meta', AppType.meta),
        ('caption', AppType.caption),
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s2),
          child: Text(
            name == 'caption'
                ? 'SẮP TỚI · 7 NGÀY — $name'
                : (name.startsWith('d') || name.startsWith('a') ? '₫1,074,466' : 'Xác nhận kỳ thanh toán — $name'),
            style: style.copyWith(color: c.ink),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      Text('Tabular: 111,111 / 888,888', style: AppType.titleSm.tabular),
      Text('Proportional: 111,111 / 888,888', style: AppType.titleSm),
      _h(context, 'Radius · elevation'),
      Wrap(
        spacing: AppSpace.s3,
        runSpacing: AppSpace.s3,
        children: [
          for (final (n, r) in [('sm', AppRadius.sm), ('md', AppRadius.md), ('lg', AppRadius.lg), ('xl', AppRadius.xl)])
            Container(
              width: 72,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(r),
                boxShadow: context.elevation.card,
              ),
              child: Text(n, style: AppType.meta),
            ),
          Container(
            width: 72,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.surfaceSheet,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: context.elevation.float,
            ),
            child: Text('float', style: AppType.meta),
          ),
        ],
      ),
      _h(context, 'Chart slots'),
      Wrap(
        spacing: AppSpace.s3,
        runSpacing: AppSpace.s2,
        children: [
          for (final cat in SubscriptionCategory.values)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: c.chartFor(cat), borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 6),
                Text(context.l10n.category(cat), style: AppType.meta),
              ],
            ),
        ],
      ),
    ];
  }

  // ---- Tiles & badges -------------------------------------------------------------------------

  List<Widget> _tiles(BuildContext context) {
    const netflix = 0xFFE50914, spotify = 0xFF1DB954, chatgpt = 0xFF202123;
    return [
      _h(context, 'ServiceTile sizes'),
      const Wrap(
        spacing: AppSpace.s4,
        runSpacing: AppSpace.s4,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          ServiceTile(name: 'Netflix', colorValue: netflix, size: 24),
          ServiceTile(name: 'Netflix', colorValue: netflix, size: 32),
          ServiceTile(name: 'Netflix', colorValue: netflix),
          ServiceTile(name: 'Netflix', colorValue: netflix, size: 56),
          ServiceTile(name: 'Netflix', colorValue: netflix, size: 80),
          ServiceTile(name: 'YouTube Premium', colorValue: 0xFFE6002E, size: 80),
        ],
      ),
      _h(context, 'States'),
      const Wrap(
        spacing: AppSpace.s5,
        runSpacing: AppSpace.s4,
        children: [
          ServiceTile(name: 'Viettel', colorValue: 0xFFD21F3C, iconText: 'V', awaiting: true),
          ServiceTile(name: 'Spotify', colorValue: spotify, trial: true),
          ServiceTile(name: 'Canva', colorValue: 0xFF7D2AE8, off: true),
          ServiceTile(name: 'ChatGPT', colorValue: chatgpt, faded: true),
          ServiceTile(name: 'Gym', colorValue: 0xFF0F8B8D, iconText: '🏋️'),
          ServiceTile(name: 'Google One', colorValue: 0xFF1A73E8, iconText: 'G1'),
          GhostTile(),
        ],
      ),
      // Real logos need a build with --dart-define=LOGO_DEV_KEY (docs/dev.md §7); without it these
      // stay monograms. Same states as above, with `logoDomain` as the remote Catalog will pass it.
      _h(context, 'With logo (Logo.dev; monogram without key / offline)'),
      const Wrap(
        spacing: AppSpace.s5,
        runSpacing: AppSpace.s4,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 24),
          ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com'),
          ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 56),
          ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 80),
          ServiceTile(name: 'Spotify', colorValue: spotify, logoDomain: 'spotify.com', trial: true),
          ServiceTile(name: 'ChatGPT', colorValue: chatgpt, logoDomain: 'openai.com', awaiting: true),
          ServiceTile(name: 'Canva', colorValue: 0xFF7D2AE8, logoDomain: 'canva.com', off: true),
          ServiceTile(name: 'No logo', colorValue: 0xFF0F8B8D, logoDomain: 'example.invalid'),
        ],
      ),
      _h(context, 'Custom tile palette (letter picks the higher-contrast ink)'),
      Wrap(
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s2,
        children: [
          for (final col in AppColors.tilePalette)
            ServiceTile(name: 'A', colorValue: col.toARGB32(), iconText: 'Aa', size: 40),
        ],
      ),
      _h(context, 'Badges'),
      Wrap(
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          StatusBadge.awaiting(label: context.l10n.commonStatusAwaiting),
          StatusBadge.trial(label: t('Trial', 'Dùng thử')),
          StatusBadge.paid(label: t('Paid', 'Đã trả')),
          StatusBadge(label: t('Cancelled', 'Đã huỷ'), icon: AppIcons.cancelled),
          StatusBadge(label: 'Brand', kind: BadgeKind.brand),
          StatusBadge(label: t('Error', 'Lỗi'), kind: BadgeKind.danger, icon: AppIcons.alert),
          StatusBadge(
            label: t('Offline · rates from 3 days ago', 'Offline · tỷ giá 3 ngày trước'),
            icon: AppIcons.offline,
            large: true,
          ),
          const ShareMark(count: 4),
        ],
      ),
      _h(context, 'Chips'),
      Wrap(
        spacing: AppSpace.s2,
        children: [
          for (final (i, cat) in [
            SubscriptionCategory.video,
            SubscriptionCategory.music,
            SubscriptionCategory.ai,
            SubscriptionCategory.other,
          ].indexed)
            AppChip(label: context.l10n.category(cat), selected: i == 0, onTap: () {}),
          AppChip(label: 'Visa ••4242', selected: false, icon: AppIcons.payment, onTap: () {}),
        ],
      ),
      Row(
        children: [
          for (final (i, s) in [
            t('Weekly', 'Tuần'),
            t('Monthly', 'Tháng'),
            t('Quarterly', 'Quý'),
            t('Yearly', 'Năm'),
          ].indexed) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: AppChip(label: s, selected: i == 1, fit: true, onTap: () {}),
            ),
          ],
        ],
      ),
    ];
  }

  // ---- Buttons & controls ---------------------------------------------------------------------

  int _seg = 0;
  int _seg5 = 2;
  bool _toggle = true;
  int _stepper = 4;

  List<Widget> _controlsPage(BuildContext context) {
    void tap() => showAppToast(context, t('Tapped', 'Đã chạm'));
    return [
      _h(context, 'Button'),
      AppButton.primary(
        label: t('Add subscription', 'Thêm subscription'),
        icon: AppIcons.add,
        expand: true,
        onPressed: tap,
      ),
      const SizedBox(height: AppSpace.s2),
      AppButton.tonal(label: t('Done', 'Xong'), expand: true, onPressed: tap),
      const SizedBox(height: AppSpace.s2),
      AppButton.outline(label: t('Restore', 'Khôi phục'), icon: AppIcons.restore, expand: true, onPressed: tap),
      const SizedBox(height: AppSpace.s2),
      AppButton.danger(label: t('Delete subscription', 'Xoá subscription'), expand: true, onPressed: tap),
      const SizedBox(height: AppSpace.s2),
      AppButton.primary(label: t('Disabled', 'Không bấm được'), expand: true, onPressed: null),
      const SizedBox(height: AppSpace.s2),
      AppButton.primary(label: t('Saving…', 'Đang lưu…'), expand: true, loading: true, onPressed: tap),
      const SizedBox(height: AppSpace.s2),
      Wrap(
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s2,
        children: [
          AppButton.tonal(label: t('How to cancel', 'Cách huỷ'), icon: AppIcons.external, small: true, onPressed: tap),
          AppButton.text(label: t('Keep it', 'Giữ lại'), small: true, onPressed: tap),
          AppButton.primary(label: t('Paid', 'Đã trả'), small: true, onPressed: tap),
          const AppButton(label: 'Danger text', kind: AppButtonKind.dangerText, small: true, onPressed: null),
        ],
      ),
      const SizedBox(height: AppSpace.s3),
      Row(
        children: [
          AppFab(onPressed: tap, tooltip: context.l10n.coreAddSubscription),
          const SizedBox(width: AppSpace.s4),
          AppIconButton(icon: AppIcons.search, tooltip: 'Search', size: 22, onPressed: tap),
          AppIconButton(icon: AppIcons.back, tooltip: 'Back', onPressed: tap),
        ],
      ),
      _h(context, 'SegmentedControl'),
      AppSegmentedControl<int>(
        selected: _seg,
        onChanged: (v) => setState(() => _seg = v),
        segments: [
          AppSegment(value: 0, label: t('Active', 'Đang trả'), count: 7),
          AppSegment(value: 1, label: t('Trials', 'Dùng thử'), count: 1),
          AppSegment(value: 2, label: t('Cancelled', 'Đã huỷ'), count: 2),
        ],
      ),
      const SizedBox(height: AppSpace.s3),
      AppSegmentedControl<int>(
        selected: _seg5,
        onChanged: (v) => setState(() => _seg5 = v),
        segments: [
          AppSegment(value: 0, label: t('Off', 'Tắt')),
          AppSegment(value: 1, label: t('On day', 'Đúng ngày')),
          const AppSegment(value: 2, label: '1'),
          const AppSegment(value: 3, label: '3'),
          const AppSegment(value: 4, label: '7'),
        ],
      ),
      const SizedBox(height: AppSpace.s3),
      Align(
        alignment: Alignment.centerLeft,
        child: AppSegmentedControl<bool>(
          mini: true,
          selected: _yearly,
          onChanged: (v) => setState(() => _yearly = v),
          segments: [
            AppSegment(value: false, label: context.l10n.coreMonth),
            AppSegment(value: true, label: context.l10n.coreYear),
          ],
        ),
      ),
      _h(context, 'Toggle · Stepper'),
      Wrap(
        spacing: AppSpace.s3,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppToggle(value: _toggle, onChanged: (v) => setState(() => _toggle = v), semanticLabel: 'Toggle'),
          AppToggle(value: !_toggle, onChanged: (v) => setState(() => _toggle = !v)),
          const AppToggle(value: true, onChanged: null),
          AppStepper(
            value: _stepper,
            min: 2,
            max: 10,
            decreaseLabel: context.l10n.coreFewer,
            increaseLabel: context.l10n.coreMore,
            onChanged: (v) => setState(() => _stepper = v),
          ),
        ],
      ),
      _h(context, 'Tab bar'),
      ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: AppTabBar(
            currentIndex: _tab,
            onSelected: (i) => setState(() => _tab = i),
            items: [
              AppTabItem(icon: AppIcons.tabHome, label: context.l10n.coreTabOverview),
              AppTabItem(icon: AppIcons.tabCalendar, label: context.l10n.commonTabCalendar),
              AppTabItem(icon: AppIcons.tabInsights, label: context.l10n.commonTabInsights),
              AppTabItem(icon: AppIcons.tabSettings, label: context.l10n.commonTabSettings),
            ],
          ),
        ),
      ),
    ];
  }

  int _tab = 0;

  // ---- Rows & hero ----------------------------------------------------------------------------

  bool _yearly = false;
  bool _highlight = false;

  List<Widget> _rows(BuildContext context) {
    final l = context.l10n;
    final month = l.corePer('month');
    final year = l.corePer('year');
    void say(String s) => showAppToast(context, s);
    final monthly = 1074467.0;
    return [
      SpendHero(
        label: _yearly ? t('Yearly spend', 'Chi mỗi năm') : t('Monthly spend', 'Chi mỗi tháng'),
        amount: _yearly ? monthly * 12 : monthly,
        approx: true,
        yearly: _yearly,
        onPeriodChanged: (v) => setState(() => _yearly = v),
        format: (v) => _money(context, v),
        segments: const [
          SpendSegment(color: Color(0xFF202123), value: 508000),
          SpendSegment(color: Color(0xFFD21F3C), value: 150000),
          SpendSegment(color: Color(0xFF1A73E8), value: 140833),
          SpendSegment(color: Color(0xFF7D2AE8), value: 115833),
          SpendSegment(color: Color(0xFFE50914), value: 65000),
          SpendSegment(color: Color(0xFF2A72D4), value: 59000),
          SpendSegment(color: Color(0xFFE6002E), value: 35800),
        ],
        leadingMeta: t('7 active · 1 trial', '7 đang trả · 1 dùng thử'),
        trailingMeta: t('Biggest: ChatGPT Plus · 47%', 'Lớn nhất: ChatGPT Plus · 47%'),
        footer: StatusBadge(
          label: t('Offline · rates from 3 days ago', 'Offline · tỷ giá cập nhật 3 ngày trước'),
          icon: AppIcons.offline,
          large: true,
        ),
      ),
      SpendHero(label: t('Monthly spend', 'Chi mỗi tháng'), amount: 0, format: (v) => _money(context, v)),
      SectionHeader(
        label: t('Subscriptions (swipe left)', 'Subscription (vuốt trái)'),
        actionLabel: t('Flash new', 'Nháy dòng mới'),
        onAction: () => setState(() => _highlight = !_highlight),
      ),
      AppGroup(
        children: [
          SubscriptionRow(
            name: 'Viettel 5G',
            colorValue: 0xFFD21F3C,
            iconText: 'V',
            state: SubscriptionRowState.awaiting,
            amount: _money(context, 150000),
            amountMeta: month,
            onTap: () => say('open Viettel'),
            onConfirm: () => say('confirm Viettel'),
            onCancel: () => say('cancel Viettel'),
          ),
          SubscriptionRow(
            name: 'Netflix Premium',
            colorValue: 0xFFE50914,
            state: SubscriptionRowState.awaiting,
            awaitingCount: 2,
            sharedCount: 4,
            amount: _money(context, 65000),
            amountMeta: l.corePlanPrice(_money(context, 260000)),
            onConfirm: () => say('confirm Netflix'),
            onCancel: () => say('cancel Netflix'),
          ),
          SubscriptionRow(
            name: 'ChatGPT Plus',
            colorValue: 0xFF202123,
            meta:
                '${AppDates.relative(l, const LocalDate(2026, 11, 7), today: _today)} · ${l.category(SubscriptionCategory.ai)}',
            amount: _money(context, 20, 'USD'),
            amountMeta: '≈ ${_money(context, 508000)}',
            highlight: _highlight,
            onCancel: () => say('cancel ChatGPT'),
          ),
          SubscriptionRow(
            name: 'YouTube Premium Family',
            colorValue: 0xFFE6002E,
            iconText: 'YT',
            sharedCount: 5,
            meta:
                '${AppDates.relative(l, const LocalDate(2026, 11, 22), today: _today)} · ${l.category(SubscriptionCategory.video)}',
            amount: _money(context, 35800),
            amountMeta: l.corePlanPrice(_money(context, 179000)),
          ),
          SubscriptionRow(
            name: 'Canva Pro',
            colorValue: 0xFF7D2AE8,
            meta:
                '${AppDates.relative(l, const LocalDate(2027, 2, 2), today: _today)} · ${l.category(SubscriptionCategory.software)}',
            amount: _money(context, 1390000),
            amountMeta: year,
          ),
        ],
      ),
      const SizedBox(height: AppSpace.s3),
      AppGroup(
        children: [
          SubscriptionRow(
            name: 'Spotify',
            colorValue: 0xFF1DB954,
            state: SubscriptionRowState.trial,
            badgeLabel: t('Trial', 'Dùng thử'),
            meta: '${t('ends', 'hết')} ${AppDates.relative(l, const LocalDate(2026, 11, 6), today: _today)}',
            amount: _money(context, 59000),
            amountMeta: month,
          ),
          SubscriptionRow(
            name: 'Duolingo Super',
            colorValue: 0xFF58CC02,
            state: SubscriptionRowState.cancelled,
            meta: '${t('Cancelled', 'Đã huỷ')} ${AppDates.full(l, _today)}',
            amount: _money(context, 89000),
            amountMeta: month,
          ),
          SubscriptionRow(
            name: 'Netflix Premium',
            colorValue: 0xFFE50914,
            queued: true,
            meta: t('Queued · 4 Dec', 'Chờ lượt · 4/12'),
            amount: _money(context, 65000),
          ),
        ],
      ),
      // Billing-period bar (product.md §10.2) + real logo — opt-in: `progress:` / `logoDomain:`.
      SectionHeader(label: t('Cycle progress + logo', 'Tiến độ kỳ + logo')),
      AppGroup(
        dividerIndent: 68,
        children: [
          SubscriptionRow(
            name: 'Netflix Premium',
            colorValue: 0xFFE50914,
            logoDomain: 'netflix.com',
            meta:
                '${AppDates.relative(l, const LocalDate(2026, 11, 27), today: _today)} · '
                '${l.category(SubscriptionCategory.video)}',
            progress: CycleProgress.of(
              cycle: const BillingCycle.monthly(),
              anchorDate: const LocalDate(2026, 8, 27),
              periodIndex: 3,
              startDate: const LocalDate(2026, 8, 27),
              today: _today,
            ),
            amount: _money(context, 260000),
            amountMeta: month,
            onTap: () => say('open Netflix'),
          ),
          SubscriptionRow(
            name: 'Spotify',
            colorValue: 0xFF1DB954,
            logoDomain: 'spotify.com',
            state: SubscriptionRowState.trial,
            badgeLabel: t('Trial', 'Dùng thử'),
            meta: '${t('ends', 'hết')} ${AppDates.relative(l, const LocalDate(2026, 11, 6), today: _today)}',
            progress: const CycleProgress(from: LocalDate(2026, 10, 7), due: LocalDate(2026, 11, 6), today: _today),
            amount: _money(context, 59000),
            amountMeta: month,
          ),
          SubscriptionRow(
            name: 'ChatGPT Plus',
            colorValue: 0xFF202123,
            logoDomain: 'openai.com',
            state: SubscriptionRowState.awaiting,
            progress: const CycleProgress(from: LocalDate(2026, 10, 2), due: LocalDate(2026, 11, 2), today: _today),
            amount: _money(context, 20, 'USD'),
            amountMeta: '≈ ${_money(context, 508000)}',
            onConfirm: () => say('confirm ChatGPT'),
          ),
          SubscriptionRow(
            name: 'Canva Pro',
            colorValue: 0xFF7D2AE8,
            logoDomain: 'canva.com',
            meta: t('Paused', 'Tạm dừng'),
            progress: const CycleProgress(from: LocalDate(2026, 2, 2), due: LocalDate(2027, 2, 2), today: _today),
            progressTone: CycleProgressTone.off,
            amount: _money(context, 1390000),
            amountMeta: year,
          ),
          SubscriptionRow(
            name: 'Duolingo Super',
            colorValue: 0xFF58CC02,
            state: SubscriptionRowState.cancelled,
            meta: '${t('Cancelled', 'Đã huỷ')} ${AppDates.full(l, _today)}',
            progress: const CycleProgress(from: LocalDate(2026, 10, 20), due: LocalDate(2026, 11, 20), today: _today),
            amount: _money(context, 89000),
            amountMeta: month,
          ),
          SubscriptionRow(
            name: 'My gym',
            colorValue: 0xFF0F8B8D,
            meta:
                '${AppDates.relative(l, _today.addDays(1), today: _today)} · ${t('custom, no logo', 'tuỳ chỉnh, không logo')}',
            progress: CycleProgress(from: _today.addDays(-6), due: _today.addDays(1), today: _today),
            amount: _money(context, 500000),
            amountMeta: month,
          ),
        ],
      ),
      _h(context, 'Date labels'),
      Text(
        [
          for (final d in [
            _today,
            _today.addDays(1),
            _today.addDays(3),
            _today.addDays(30),
            _today.addDays(31),
            _today.addDays(-2),
            const LocalDate(2027, 2, 2),
          ])
            AppDates.relative(l, d, today: _today),
        ].join(' · '),
        style: AppType.meta,
      ),
      Text(
        '${AppDates.weekdayLong(l, _today)} · ${AppDates.weekdayShort(l, const LocalDate(2026, 11, 6), today: _today)} · '
        '${AppDates.full(l, _today)} · ${AppDates.monthTitle(l, 2026, 12)} · ${perCycle(l, const BillingCycle.quarterly())} · '
        '${perCycle(l, const BillingCycle(2, CycleUnit.week))}',
        style: AppType.meta,
      ),
    ];
  }

  // ---- Banners & empty ------------------------------------------------------------------------

  List<Widget> _banners(BuildContext context) {
    void tap() => showAppToast(context, t('Action', 'Hành động'));
    return [
      _h(context, 'Banner'),
      AppBanner(
        kind: BannerKind.neutral,
        icon: AppIcons.remindersOff,
        title: t('Reminders are off', 'Nhắc nhở đang tắt'),
        body: t(
          'You won’t hear about renewals or trials ending.',
          'Bạn sẽ không được báo trước khi gia hạn hay hết dùng thử.',
        ),
        actionLabel: t('Turn on', 'Bật lại'),
        onAction: tap,
      ),
      const SizedBox(height: AppSpace.s3),
      AppBanner(
        kind: BannerKind.warning,
        icon: AppIcons.awaiting,
        title: t('2 payments to confirm', '2 khoản cần xác nhận'),
        body: '${_money(context, 215000)} · Viettel, Netflix',
        actionLabel: t('Review', 'Xem'),
        onAction: tap,
      ),
      const SizedBox(height: AppSpace.s3),
      AppBanner(
        kind: BannerKind.info,
        icon: AppIcons.tip,
        title: t('Tip', 'Mẹo'),
        body: t('Swipe a row left to confirm or cancel.', 'Vuốt trái một dòng để xác nhận hoặc huỷ.'),
      ),
      const SizedBox(height: AppSpace.s3),
      AppBanner(
        kind: BannerKind.success,
        icon: AppIcons.savings,
        title: t('You’re saving', 'Bạn đang tiết kiệm'),
        body: '${_money(context, 1479000)}${context.l10n.corePer('year')}',
      ),
      const SizedBox(height: AppSpace.s3),
      AppBanner(
        kind: BannerKind.danger,
        icon: AppIcons.alert,
        title: t('Backup file can’t be read', 'Không đọc được tệp sao lưu'),
        actionLabel: t('Try another file', 'Chọn tệp khác'),
        onAction: tap,
      ),
      _h(context, 'Illustrations'),
      const Wrap(
        spacing: AppSpace.s3,
        runSpacing: AppSpace.s3,
        children: [
          NestArt(kind: NestArtKind.nest, width: 96),
          NestArt(kind: NestArtKind.empty, width: 96),
          NestArt(kind: NestArtKind.party, width: 96),
          NestArt(kind: NestArtKind.chart, width: 96),
          NestArt(kind: NestArtKind.welcome, width: 96),
        ],
      ),
      _h(context, 'EmptyState'),
      AppCard(
        padding: EdgeInsets.zero,
        child: EmptyState(
          art: const NestArt(kind: NestArtKind.empty, width: 180),
          title: t('Add your first subscription', 'Thêm subscription đầu tiên'),
          body: t(
            'Pick from 100+ popular services — most take three taps.',
            'Chọn từ 100+ dịch vụ phổ biến — thường chỉ 3 chạm.',
          ),
          actionLabel: t('Browse services', 'Xem thư viện dịch vụ'),
          actionIcon: AppIcons.library,
          onAction: tap,
        ),
      ),
      const SizedBox(height: AppSpace.s3),
      AppCard(
        padding: EdgeInsets.zero,
        child: EmptyState(
          art: const NestArt(kind: NestArtKind.party),
          title: t('You’re all caught up 🎉', 'Bạn đã xác nhận hết 🎉'),
        ),
      ),
      _h(context, 'Settings rows'),
      AppGroup(
        dividerIndent: 52,
        children: [
          SettingRow(
            icon: AppIcons.currency,
            label: t('Primary currency', 'Tiền tệ chính'),
            value: 'VND · ₫',
            onTap: tap,
          ),
          SettingRow(
            icon: AppIcons.reminder,
            label: t('Reminders', 'Nhắc nhở'),
            subtitle: t('3 days before · 9:00', '3 ngày trước · 9:00'),
            trailing: AppToggle(value: _toggle, onChanged: (v) => setState(() => _toggle = v)),
          ),
          SettingRow(
            icon: AppIcons.theme,
            label: t('Appearance', 'Giao diện'),
            value: t('System', 'Theo hệ thống'),
            onTap: tap,
          ),
          SettingRow(
            icon: AppIcons.privacy,
            label: t('Privacy policy', 'Chính sách quyền riêng tư'),
            external: true,
            onTap: tap,
          ),
          SettingRow(
            icon: AppIcons.delete,
            label: t('Delete all data', 'Xoá toàn bộ dữ liệu'),
            danger: true,
            onTap: tap,
          ),
        ],
      ),
    ];
  }

  // ---- Sheets & pickers -----------------------------------------------------------------------

  LocalDate _picked = const LocalDate(2026, 12, 4);

  List<Widget> _sheets(BuildContext context) {
    final l = context.l10n;
    return [
      _h(context, 'Open'),
      Wrap(
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s2,
        children: [
          AppButton.tonal(label: t('Sort sheet', 'Tấm sắp xếp'), small: true, onPressed: () => _sortSheet(context)),
          AppButton.tonal(
            label: t('Required sheet', 'Tấm bắt buộc'),
            small: true,
            onPressed: () => _requiredSheet(context),
          ),
          AppButton.tonal(
            label: t('Delete dialog', 'Hộp thoại xoá'),
            small: true,
            onPressed: () => _deleteDialog(context),
          ),
          AppButton.tonal(
            label: t('Date picker', 'Chọn ngày'),
            small: true,
            onPressed: () async {
              final d = await showAppDatePicker(
                context,
                initial: _picked,
                today: _today,
                doneLabel: l.commonDone,
                footer: (s) =>
                    '${t('Then', 'Sau đó')} ${[1, 2, 3].map((i) => AppDates.short(l, s.addMonths(i), today: s)).join(' · ')}',
              );
              if (d != null) setState(() => _picked = d);
            },
          ),
          AppButton.tonal(
            label: 'Toast',
            small: true,
            onPressed: () => showAppToast(context, t('Marked as paid', 'Đã ghi nhận thanh toán')),
          ),
        ],
      ),
      _h(context, 'Dialog (inline)'),
      Container(
        decoration: BoxDecoration(color: context.colors.scrim, borderRadius: BorderRadius.circular(AppRadius.lg)),
        padding: const EdgeInsets.symmetric(vertical: AppSpace.s4),
        child: AppDialog(
          title: t('Delete Netflix?', 'Xoá Netflix?'),
          body: t(
            'Its payment history goes too. To keep the history, mark it as cancelled instead.',
            'Lịch sử thanh toán cũng bị xoá. Muốn giữ lịch sử thì đánh dấu đã huỷ.',
          ),
          actions: [
            AppButton.danger(label: l.commonDelete, expand: true, onPressed: () {}),
            AppButton.text(label: t('Mark as cancelled', 'Đánh dấu đã huỷ'), expand: true, onPressed: () {}),
            AppButton.text(label: l.commonCancel, expand: true, onPressed: () {}),
          ],
        ),
      ),
      _h(context, 'DatePicker (inline, Monday first)'),
      AppCard(
        // Narrow side padding like the date sheet (12): 7 columns stay ≥ 48dp wide.
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: AppSpace.s4),
        child: AppDatePicker(selected: _picked, today: _today, onChanged: (d) => setState(() => _picked = d)),
      ),
    ];
  }

  // ---- Form inputs ---------------------------------------------------------------------------

  String _plan = 'premium';
  double? _price = 260000;
  double? _usd = 20;
  double? _empty;
  double? _paid = 65000;
  String _cur = 'VND';

  List<Widget> _forms(BuildContext context) {
    final l = context.l10n;
    final mo = t('/mo', '/th');
    final plans = [
      ('mobile', 'Mobile', t('480p · 1 phone or tablet', '480p · 1 điện thoại/máy tính bảng'), 74000.0),
      ('basic', 'Basic', t('720p · 1 screen', '720p · 1 màn hình'), 114000.0),
      ('standard', 'Standard', t('1080p · 2 screens', '1080p · 2 màn hình'), 230000.0),
      ('premium', 'Premium', t('4K + HDR · 4 screens', '4K + HDR · 4 màn hình'), 260000.0),
    ];
    return [
      _h(context, 'AmountField · form (S4)'),
      AppCard(
        child: AmountField(
          label: t('Price', 'Giá'),
          value: _price,
          currency: _cur,
          onChanged: (v) => setState(() => _price = v),
          onCurrencyTap: () => setState(() => _cur = _cur == 'VND' ? 'USD' : 'VND'),
          conversion: _cur == 'USD' && _price != null ? '≈ ${_money(context, _price! * 25400)}' : null,
        ),
      ),
      const SizedBox(height: AppSpace.s3),
      AppCard(
        child: AmountField(
          label: t('Price', 'Giá'),
          value: _usd,
          currency: 'USD',
          onChanged: (v) => setState(() => _usd = v),
          onCurrencyTap: () {},
          conversion: _usd == null ? null : '≈ ${_money(context, _usd! * 25400)}',
        ),
      ),
      const SizedBox(height: AppSpace.s3),
      AppCard(
        child: AmountField(
          label: t('Price after trial', 'Giá sau dùng thử'),
          value: _empty,
          currency: 'VND',
          onChanged: (v) => setState(() => _empty = v),
          onCurrencyTap: () {},
          errorText: (_empty ?? 0) > 0 ? null : t('Price must be more than 0', 'Giá phải lớn hơn 0'),
        ),
      ),
      _h(context, 'AmountField · boxed (S6)'),
      AmountField(
        boxed: true,
        label: t('Amount paid', 'Số tiền đã trả'),
        value: _paid,
        currency: 'VND',
        onChanged: (v) => setState(() => _paid = v),
        showEditButton: true,
        helper: '${t('Your share · plan', 'Phần của bạn · gói')} ${_money(context, 260000)} ÷ 4',
        helperIcon: AppIcons.shared,
      ),
      _h(context, 'RadioRow · card (S3 plan sheet)'),
      RadioRowGroup<String>(
        value: _plan,
        onChanged: (v) => setState(() => _plan = v),
        options: [
          for (final (id, name, sub, price) in plans)
            RadioOption(
              value: id,
              title: name,
              subtitle: sub,
              trailing: RadioRow.price(context, _money(context, price), suffix: mo),
            ),
        ],
      ),
      const SizedBox(height: AppSpace.s3),
      AppButton.primary(
        label: t(
          'Continue with ${plans.firstWhere((p) => p.$1 == _plan).$2}',
          'Tiếp tục với ${plans.firstWhere((p) => p.$1 == _plan).$2}',
        ),
        expand: true,
        onPressed: () {},
      ),
      _h(context, 'RadioRow · flat (sort / settings)'),
      RadioRowGroup<int>(
        style: RadioRowStyle.flat,
        value: _sortBy,
        onChanged: (v) => setState(() => _sortBy = v),
        options: [
          RadioOption(value: 0, title: t('Due date', 'Ngày gia hạn'), subtitle: t('Soonest first', 'Gần nhất trước')),
          RadioOption(
            value: 1,
            title: t('Price', 'Giá'),
            subtitle: t('Highest monthly cost first', 'Chi phí quy tháng cao nhất trước'),
          ),
          RadioOption(value: 2, title: t('Name', 'Tên'), subtitle: 'A → Z'),
          RadioOption(value: 3, title: l.commonReminderOff),
        ],
      ),
    ];
  }

  int _sortBy = 0;

  void _sortSheet(BuildContext context) {
    var sel = 0;
    showAppSheet<void>(
      context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AppSheet(
          title: t('Sort subscriptions', 'Sắp xếp subscription'),
          actions: [AppButton.tonal(label: ctx.l10n.commonDone, expand: true, onPressed: () => Navigator.pop(ctx))],
          child: RadioRowGroup<int>(
            style: RadioRowStyle.flat,
            value: sel,
            onChanged: (v) => set(() => sel = v),
            options: [
              RadioOption(
                value: 0,
                title: t('Due date', 'Ngày gia hạn'),
                subtitle: t(
                  'Soonest first · awaiting always on top',
                  'Gần nhất trước · khoản chờ xác nhận luôn ở trên',
                ),
              ),
              RadioOption(
                value: 1,
                title: t('Price', 'Giá'),
                subtitle: t('Highest monthly cost first', 'Chi phí quy tháng cao nhất trước'),
              ),
              RadioOption(value: 2, title: t('Name', 'Tên'), subtitle: 'A → Z'),
            ],
          ),
        ),
      ),
      bare: true,
    );
  }

  void _requiredSheet(BuildContext context) {
    showAppSheet<void>(
      context,
      required: true,
      builder: (ctx) => AppSheet(
        title: t('Confirm all 3 payments?', 'Xác nhận cả 3 khoản?'),
        actions: [
          AppButton.primary(
            label: t('Confirm all', 'Xác nhận tất cả'),
            expand: true,
            onPressed: () => Navigator.pop(ctx),
          ),
          AppButton.text(label: ctx.l10n.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ],
        child: Text(
          t('A choice is required: no drag-down, no scrim tap.', 'Bắt buộc chọn: không kéo xuống, không chạm nền.'),
          style: AppType.body.copyWith(color: ctx.colors.inkMuted),
        ),
      ),
      bare: true,
    );
  }

  void _deleteDialog(BuildContext context) {
    final l = context.l10n;
    showAppDialog<void>(
      context,
      title: t('Delete Netflix?', 'Xoá Netflix?'),
      body: t('Its payment history goes too.', 'Lịch sử thanh toán cũng bị xoá.'),
      actions: [
        Builder(
          builder: (ctx) => AppButton.danger(label: l.commonDelete, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
        Builder(
          builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
      ],
    );
  }
}
