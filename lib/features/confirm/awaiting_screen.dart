import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S7 Awaiting confirmation list (oldest first) + "Confirm all" — PLACEHOLDER UI.
/// Owned by the Home & confirm session (G).
class AwaitingScreen extends ConsumerWidget {
  const AwaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final items = ref.watch(awaitingPeriodsProvider);
    final summary = ref.watch(spendingSummaryProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final repo = ref.read(subscriptionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.confirmAwaitingTitle)),
      body: items.isEmpty
          ? Center(child: Text(l.confirmAllDone))
          : ListView(
              children: [
                for (final (s, due) in items)
                  ListTile(
                    leading: ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText),
                    title: Text(s.name),
                    subtitle: Text('${l.date(due)} · ${l.money(s.myShare)}'),
                    // Only the oldest pending period of a subscription can be confirmed.
                    trailing: due == BillingRules.pendingDueDates(s, ref.read(todayProvider)).first
                        ? IconButton(
                            tooltip: l.confirmPaid,
                            icon: const Icon(Icons.check_circle_outline),
                            onPressed: () => repo.confirm(s.id, PeriodOutcome.payment),
                          )
                        : null,
                    onTap: () => context.push(AppRoutes.confirm(s.id)),
                  ),
              ],
            ),
      bottomNavigationBar: items.isEmpty || summary == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l.confirmAllDialogTitle(items.length)),
                        content: Text(l.confirmAllDialogBody),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.commonCancel)),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.confirmPaid)),
                        ],
                      ),
                    );
                    if (ok ?? false) await repo.confirmAll();
                  },
                  child: Text(l.confirmAll(l.amount(summary.awaitingTotal, primary, approx: true))),
                ),
              ),
            ),
    );
  }
}
