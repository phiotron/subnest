import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../home/home_list.dart';
import 'celebrate_screen.dart';

/// "Mark as cancelled" (S5 button, S2 swipe): asks first, cancels through the repository
/// (BillingRules.cancel — history kept, pending periods dropped), then shows the celebration.
/// "See cancelled" opens the Overview on its Cancelled tab. Returns whether it was cancelled.
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
    body: l.subscriptionDetailCancelBody(yearlyText),
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
  final allApprox = all.any((x) => x.status == SubscriptionStatus.cancelled && x.currency != primary);
  final router = GoRouter.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  await navigator.push(
    PageRouteBuilder<void>(
      transitionDuration: AppMotion.of(context, AppMotion.dialog),
      reverseTransitionDuration: AppMotion.of(context, AppMotion.fast),
      pageBuilder: (ctx, _, _) => CelebrateScreen(
        name: s.name,
        savedYearly: yearlyText.replaceFirst('≈ ', ''),
        totalYearly: l.amount(total, primary, approx: allApprox),
        onSeeCancelled: () {
          ref.read(homeTabRequestProvider.notifier).request(HomeTab.cancelled);
          Navigator.of(ctx).pop();
          router.go(AppRoutes.home);
        },
      ),
      transitionsBuilder: (ctx, anim, _, child) => FadeTransition(opacity: anim, child: child),
    ),
  );
  return true;
}
