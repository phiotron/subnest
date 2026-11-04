import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../data/providers.dart';
import '../../data/rates/exchange_rate_repository.dart';
import '../../domain/domain.dart';

/// Exchange rates in use (S10) — PLACEHOLDER UI. Owned by the Settings session (J).
class RatesScreen extends ConsumerWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final rates = ref.watch(ratesProvider).value ?? ExchangeRates.empty;
    final primary = ref.watch(primaryCurrencyProvider);
    final subs = ref.watch(subscriptionsProvider).value ?? const <Subscription>[];
    final used = subs.map((s) => s.currency).where((c) => c != primary).toSet().toList()..sort();
    final repo = ref.read(exchangeRateRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsRates)),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              rates.fetchedAt == null
                  ? l.settingsRatesNeverUpdated
                  : l.settingsRatesUpdatedAt(l.date(LocalDate.fromDateTime(rates.fetchedAt!))),
            ),
            trailing: FilledButton.tonal(
              onPressed: () async {
                final r = await repo.refreshIfStale(force: true);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(r == RatesRefreshResult.failed ? l.settingsRatesFailed : l.settingsRatesUpdated)),
                  );
                }
              },
              child: Text(l.settingsRatesUpdateNow),
            ),
          ),
          if (used.isEmpty) ListTile(title: Text(l.settingsRatesNoneUsed)),
          for (final c in used)
            ListTile(
              title: Text('1 $c = ${_rateText(rates.rate(c, primary), primary, l.localeName)}'),
              subtitle: Text(rates.isOverridden(c, primary) ? l.settingsRatesManual : l.settingsRatesAuto),
              onTap: () => _edit(context, ref, c, primary, rates),
            ),
          ListTile(
            title: Text(l.settingsRatesAttribution),
            onTap: () => launchUrl(Uri.parse(ExchangeRateRepository.attributionUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
    );
  }

  String _rateText(double? rate, String currency, String locale) {
    if (rate == null) return '?';
    final digits = rate >= 100 ? 0 : 4;
    return '${rate.toStringAsFixed(digits)} $currency';
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, String from, String to, ExchangeRates rates) async {
    final l = context.l10n;
    final controller = TextEditingController(text: rates.rate(from, to)?.toString() ?? '');
    final repo = ref.read(exchangeRateRepositoryProvider);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('1 $from = ? $to'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'auto'), child: Text(l.settingsRatesUseAuto)),
          FilledButton(onPressed: () => Navigator.pop(ctx, 'set'), child: Text(l.commonSave)),
        ],
      ),
    );
    final value = Fmt.parseAmount(controller.text, 'USD');
    controller.dispose();
    if (result == 'auto') await repo.clearOverride(from, to);
    if (result == 'set' && value != null && value > 0) await repo.setOverride(from, to, value);
  }
}
