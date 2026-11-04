import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S6 Confirm a Billing period (bottom sheet; opened from the "due today" notification,
/// banners and rows) — PLACEHOLDER UI. Owned by the Home & confirm session (G).
///
/// Shows the oldest pending period; after "Paid"/"Not this period" it moves on to the next
/// pending one automatically (catch-up), and closes when none is left.
class ConfirmSheet extends ConsumerStatefulWidget {
  const ConfirmSheet({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  ConsumerState<ConfirmSheet> createState() => _ConfirmSheetState();
}

class _ConfirmSheetState extends ConsumerState<ConfirmSheet> {
  final _amount = TextEditingController();
  LocalDate? _amountFor;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _confirm(Subscription s, PeriodOutcome outcome) async {
    setState(() => _busy = true);
    final amount = Fmt.parseAmount(_amount.text, s.currency);
    await ref.read(subscriptionRepositoryProvider).confirm(
      s.id,
      outcome,
      amountMinor: amount == null ? null : toMinorUnits(amount, s.currency),
    );
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() => _busy = false);
    final updated = await ref.read(subscriptionRepositoryProvider).get(s.id);
    if (!mounted || updated == null) return;
    if (!BillingRules.isAwaitingConfirmation(updated, ref.read(todayProvider))) {
      final l = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.confirmNext(l.date(updated.dueDate)))));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref.watch(subscriptionProvider(widget.subscriptionId)).value;
    final today = ref.watch(todayProvider);
    if (s == null) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    final pending = BillingRules.pendingDueDates(s, today);
    if (pending.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.confirmNothing(s.name), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => context.pop(), child: Text(l.commonClose)),
          ],
        ),
      );
    }
    final due = pending.first;
    if (_amountFor != due) {
      _amountFor = due;
      _amount.text = Fmt.editable(s.myShareMinor, s.currency);
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText),
              const SizedBox(width: 12),
              Expanded(child: Text(l.confirmTitle(s.name, l.date(due)), style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          if (pending.length > 1) ...[
            const SizedBox(height: 8),
            Text(l.confirmMorePending(pending.length - 1)),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(labelText: l.confirmAmount, suffixText: s.currency),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : () => _confirm(s, PeriodOutcome.payment),
            child: Text(l.confirmPaid),
          ),
          OutlinedButton(
            onPressed: _busy ? null : () => _confirm(s, PeriodOutcome.skipped),
            child: Text(l.confirmSkip),
          ),
          TextButton(onPressed: () => context.pop(), child: Text(l.confirmLater)),
        ],
      ),
    );
  }
}
