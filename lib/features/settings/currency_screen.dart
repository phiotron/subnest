import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/currencies.dart';
import '../../data/providers.dart';

/// Pick the Primary currency (S10 / S1.2) — PLACEHOLDER UI. Owned by the Settings session (J).
/// Pass [onPicked] to use it as a picker (onboarding); default saves the Primary currency and pops.
class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key, this.onPicked});

  final ValueChanged<String>? onPicked;

  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rates = ref.watch(ratesProvider).value;
    final primary = ref.watch(primaryCurrencyProvider);
    final all = {...commonCurrencies, ...?rates?.usdRates.keys}.toList();
    final q = _query.trim().toUpperCase();
    final list = all.where((c) => q.isEmpty || c.contains(q) || (currencyNames[c] ?? '').toUpperCase().contains(q));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: l.settingsSearchCurrency, border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: ListView(
        children: [
          for (final c in list)
            ListTile(
              title: Text(c),
              subtitle: currencyNames[c] == null ? null : Text(currencyNames[c]!),
              trailing: c == primary ? const Icon(Icons.check) : null,
              onTap: () async {
                if (widget.onPicked != null) {
                  widget.onPicked!(c);
                  return;
                }
                await ref.read(settingsRepositoryProvider).setPrimaryCurrency(c);
                if (context.mounted) context.pop();
              },
            ),
        ],
      ),
    );
  }
}
