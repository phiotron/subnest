import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S5 Subscription details — PLACEHOLDER UI. Owned by the Home & confirm session (G).
class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final subAsync = ref.watch(subscriptionProvider(subscriptionId));
    final periods = ref.watch(subscriptionPeriodsProvider(subscriptionId)).value ?? const <ConfirmedPeriod>[];
    final today = ref.watch(todayProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);

    final s = subAsync.value;
    if (s == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: subAsync.isLoading ? const CircularProgressIndicator() : Text(l.commonNotFound)),
      );
    }
    final status = BillingRules.effectiveStatus(s, today);
    final pending = BillingRules.pendingDueDates(s, today);
    final cancelled = status == SubscriptionStatus.cancelled;
    final days = BillingRules.daysUntilDue(s, today);
    final converted = s.currency == primary ? null : calc.periodCost(s);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.name),
        actions: [
          IconButton(
            tooltip: l.commonEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.subscriptionEdit(s.id)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: Theme.of(context).textTheme.headlineSmall),
                    Wrap(
                      spacing: 6,
                      children: [
                        Chip(label: Text(l.status(status))),
                        if (pending.isNotEmpty)
                          Chip(
                            avatar: const Icon(Icons.priority_high, size: 16),
                            label: Text(l.commonStatusAwaiting),
                            backgroundColor: AppTheme.warning.withValues(alpha: 0.2),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('${l.money(s.price)} · ${l.cycle(s.cycle)}', style: Theme.of(context).textTheme.titleLarge),
          if (s.isShared)
            Text(l.subscriptionDetailMyShare(l.money(s.myShare), l.money(s.price), s.sharedWith)),
          if (converted != null) Text(l.amount(converted, primary, approx: true)),
          if (pending.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              color: AppTheme.warning.withValues(alpha: 0.15),
              child: ListTile(
                leading: const Icon(Icons.pending_actions),
                title: Text(l.subscriptionDetailAwaiting(pending.length)),
                trailing: FilledButton(
                  onPressed: () => context.push(AppRoutes.confirm(s.id)),
                  child: Text(l.subscriptionDetailConfirm),
                ),
              ),
            ),
          ],
          const Divider(height: 32),
          if (!cancelled)
            _Info(
              l.subscriptionDetailNextDue,
              '${l.date(s.dueDate)} · ${days < 0 ? l.commonDaysOverdue(-days) : l.commonDaysLeft(days)}',
            ),
          if (status == SubscriptionStatus.trial && s.trialEndDate != null)
            _Info(l.subscriptionDetailTrialEnds, l.date(s.trialEndDate!)),
          _Info(l.subscriptionDetailCycle, l.cycle(s.cycle)),
          _Info(l.subscriptionDetailReminder, l.reminder(s.reminderDays)),
          _Info(l.subscriptionDetailCategory, l.category(s.category)),
          if (s.paymentMethod != null) _Info(l.subscriptionDetailPaymentMethod, s.paymentMethod!),
          _Info(l.subscriptionDetailStarted, l.date(s.startDate)),
          if (cancelled && s.cancelledOn != null) _Info(l.subscriptionDetailCancelledOn, l.date(s.cancelledOn!)),
          _Info(l.subscriptionDetailTotalPaid, l.amount(calc.totalPaid(periods), primary, approx: true)),
          if (s.notes != null) _Info(l.subscriptionDetailNotes, s.notes!),
          const Divider(height: 32),
          Text(l.subscriptionDetailHistory, style: Theme.of(context).textTheme.titleMedium),
          for (final d in pending)
            ListTile(
              leading: const Icon(Icons.hourglass_empty),
              title: Text(l.date(d)),
              subtitle: Text(l.commonStatusAwaiting),
            ),
          for (final p in periods)
            ListTile(
              leading: Icon(p.isPayment ? Icons.check_circle_outline : Icons.remove_circle_outline),
              title: Text(l.date(p.dueDate)),
              subtitle: Text(p.isPayment ? l.subscriptionDetailPaid : l.subscriptionDetailSkipped),
              trailing: p.isPayment ? Text(l.money(p.amount)) : null,
              onTap: p.isPayment ? () => _editAmount(context, ref, p) : null,
            ),
          if (periods.isEmpty && pending.isEmpty) Text(l.subscriptionDetailNoHistory),
          const Divider(height: 32),
          if (s.manageUrl != null)
            OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: Text(l.subscriptionDetailHowToCancel),
              onPressed: () => launchUrl(Uri.parse(s.manageUrl!), mode: LaunchMode.externalApplication),
            ),
          if (!cancelled)
            OutlinedButton(
              onPressed: () async {
                final yearly = calc.yearlyCost(s);
                await ref.read(subscriptionRepositoryProvider).cancel(s.id);
                if (context.mounted && yearly != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.subscriptionDetailSaved(l.amount(yearly, primary, approx: true)))),
                  );
                }
              },
              child: Text(l.subscriptionDetailMarkCancelled),
            )
          else
            OutlinedButton(
              onPressed: () => ref.read(subscriptionRepositoryProvider).restore(s.id),
              child: Text(l.subscriptionDetailRestore),
            ),
          const SizedBox(height: 24),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => _delete(context, ref, s),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
  }

  Future<void> _editAmount(BuildContext context, WidgetRef ref, ConfirmedPeriod p) async {
    final l = context.l10n;
    final controller = TextEditingController(text: Fmt.editable(p.amountMinor, p.currency));
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.subscriptionDetailEditAmount),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(suffixText: p.currency),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, Fmt.parseAmount(controller.text, p.currency)),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) {
      await ref.read(subscriptionRepositoryProvider).updatePeriodAmount(p.id, toMinorUnits(result, p.currency));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Subscription s) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.subscriptionDetailDeleteTitle(s.name)),
        content: Text(l.subscriptionDetailDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.commonDelete)),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(subscriptionRepositoryProvider).delete(s.id);
      if (context.mounted) context.go(AppRoutes.home);
    }
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 140, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
