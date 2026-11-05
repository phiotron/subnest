import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/rates/exchange_rate_repository.dart';
import '../../domain/domain.dart';
import 'rate_override_sheet.dart';
import 'rates_status.dart';
import 'settings_format.dart';
import 'settings_platform.dart';
import 'settings_screen.dart' show usedForeignCurrencies;
import 'widgets/settings_bits.dart';

/// S10 › Exchange rates (png 51, 52): pairs in use, auto/manual, "Update now", offline state.
class RatesScreen extends ConsumerStatefulWidget {
  const RatesScreen({super.key});

  @override
  ConsumerState<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends ConsumerState<RatesScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch only if the cache is older than a day; a failure shows the offline state.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(ratesStatusProvider.notifier).refresh();
    });
  }

  Future<void> _updateNow() async {
    final l = context.l10n;
    final r = await ref.read(ratesStatusProvider.notifier).refresh(force: true);
    if (!mounted) return;
    if (r == RatesRefreshResult.updated) showAppToast(context, l.settingsRatesUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final rates = ref.watch(ratesProvider).value ?? ExchangeRates.empty;
    final primary = ref.watch(primaryCurrencyProvider);
    final used = usedForeignCurrencies(ref.watch(subscriptionsProvider).value, primary);
    final status = ref.watch(ratesStatusProvider);
    final now = ref.watch(clockProvider)();

    String sub(String from) {
      if (rates.isOverridden(from, primary)) return l.settingsRateManual;
      final at = rates.fetchedAt;
      if (at == null) return l.settingsRateBuiltIn;
      final ago = SettingsFormat.ago(l, at, now);
      return status.offline ? l.settingsRateAutoOffline(ago) : l.settingsRateAuto(ago);
    }

    return Scaffold(
      appBar: AppTopBar(title: l.settingsRates),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s2, AppSpace.s1, AppSpace.s4),
              child: Text(l.settingsRatesIntro(primary), style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
            if (used.isEmpty)
              AppCard(
                child: Text(l.settingsRatesNoneUsed(primary), style: AppType.body.copyWith(color: c.inkMuted)),
              )
            else
              AppGroup(
                dividerIndent: AppSpace.s4,
                children: [
                  for (final from in used)
                    _PairRow(
                      from: from,
                      to: primary,
                      rate: rates.rate(from, primary),
                      subtitle: sub(from),
                      onTap: () => showRateOverrideSheet(context, from: from, to: primary),
                    ),
                ],
              ),
            if (status.offline) ...[
              const SizedBox(height: AppSpace.s4),
              AppBanner(
                kind: BannerKind.neutral,
                icon: AppIcons.offline,
                title: l.settingsRatesOfflineTitle,
                body: l.settingsRatesOfflineBody,
              ),
            ],
            const SizedBox(height: AppSpace.s4),
            AppButton.tonal(
              label: l.settingsRatesUpdateNow,
              icon: AppIcons.refresh,
              expand: true,
              loading: status.updating,
              onPressed: status.updating ? null : _updateNow,
            ),
            if (used.isNotEmpty) ListNote(l.settingsRatesListedNote),
            const SizedBox(height: AppSpace.s2),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () =>
                    ref.read(settingsPlatformProvider).openExternal(Uri.parse(ExchangeRateRepository.attributionUrl)),
                icon: Icon(AppIcons.external, size: 16, color: c.inkMuted),
                label: Text(l.settingsRatesAttribution, style: AppType.meta.copyWith(color: c.inkMuted)),
                style: TextButton.styleFrom(minimumSize: const Size(AppSize.tapMin, 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "1 USD → **25,400 VND**" (the arrow is an icon: Be Vietnam Pro has no U+2192) + "Auto · updated 2 hours ago".
class _PairRow extends StatelessWidget {
  const _PairRow({
    required this.from,
    required this.to,
    required this.rate,
    required this.subtitle,
    required this.onTap,
  });

  final String from;
  final String to;
  final double? rate;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final value = rate == null ? '–' : SettingsFormat.rate(rate!, l.localeName);
    final style = AppType.body.copyWith(fontWeight: FontWeight.w500, color: c.ink);
    return Semantics(
      label: '${l.settingsRatePairLabel(from, value, to)}. $subtitle',
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s3),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: style,
                          children: [
                            TextSpan(text: '1 $from '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(LucideIcons.arrowRight, size: 16, color: c.ink),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(text: '$value $to', style: AppType.titleSm.tabular),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s2),
                Icon(AppIcons.next, size: 18, color: c.inkMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
