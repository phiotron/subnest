import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/subscription_labels.dart';
import 'celebrate_screen.dart';

/// "Mark as cancelled" (S5 button, S2 swipe, png 061): asks first, cancels through the repository
/// (BillingRules.cancel — history kept, pending periods dropped), then shows the celebration (063).
/// Done returns to where the user was; Undo restores the subscription. Returns whether it was cancelled.
Future<bool> markCancelledFlow(BuildContext context, WidgetRef ref, Subscription s) async {
  final l = context.l10n;
  final primary = ref.read(primaryCurrencyProvider);
  final calc = ref.read(spendingCalculatorProvider);
  final yearly = calc.yearlyCost(s);
  final approx = s.currency != primary;
  final yearlyText = yearly == null ? l.money(s.myShare) : l.amount(yearly, primary, approx: approx);

  final ok = await showAppDialog<bool>(
    context,
    title: l.subscriptionDetailCancelTitle(s.name),
    body: l.subscriptionDetailCancelBody(yearlyText.replaceFirst('≈ ', '${l.coreApproximately} ')),
    actions: [
      Builder(
        builder: (ctx) => AppButton.primary(
          label: l.subscriptionDetailMarkCancelled,
          icon: AppIcons.cancelled,
          expand: true,
          onPressed: () => Navigator.of(ctx).pop(true),
        ),
      ),
      Builder(
        builder: (ctx) => AppButton.text(
          label: l.subscriptionDetailNotYet,
          expand: true,
          onPressed: () => Navigator.of(ctx).pop(false),
        ),
      ),
    ],
  );
  if (ok != true || !context.mounted) return false;

  final repo = ref.read(subscriptionRepositoryProvider);
  await repo.cancel(s.id);
  // Savings after this cancellation, from the stored data (the list stream may not be listened to).
  final all = await repo.all();
  if (!context.mounted) return true;
  final today = ref.read(todayProvider);
  final total = calc.summary(all, today).savingsYearly;
  final cancelled = all.where((x) => x.status == SubscriptionStatus.cancelled).toList();
  final allApprox = cancelled.any((x) => x.currency != primary);
  final link = cancelLink(s, ref.read(catalogByIdProvider));
  final navigator = Navigator.of(context, rootNavigator: true);
  await navigator.push(
    PageRouteBuilder<void>(
      transitionDuration: AppMotion.of(context, AppMotion.dialog),
      reverseTransitionDuration: AppMotion.of(context, AppMotion.fast),
      pageBuilder: (ctx, _, _) => CelebrateScreen(
        name: s.name,
        savedYearly: yearlyText.replaceFirst('≈ ', ''),
        totalYearly: l.amount(total, primary, approx: allApprox),
        cancelledCount: cancelled.length,
        host: link == null ? null : linkHost(link),
        onDone: () => Navigator.of(ctx).pop(),
        onUndo: () async {
          await repo.restore(s.id);
          if (ctx.mounted) Navigator.of(ctx).pop();
        },
      ),
      transitionsBuilder: (ctx, anim, _, child) => FadeTransition(opacity: anim, child: child),
    ),
  );
  return true;
}
