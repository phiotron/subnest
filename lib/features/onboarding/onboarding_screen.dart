import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/utils/currencies.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S1 Onboarding (welcome → primary currency → quick add → reminders) — PLACEHOLDER UI.
/// Owned by the Add & onboarding session (H).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String? _currency;
  final _picked = <String>{}; // catalog service ids

  Future<void> _finish({required bool askPermission}) async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final subsRepo = ref.read(subscriptionRepositoryProvider);
    await settingsRepo.setPrimaryCurrency(_currency ?? ref.read(primaryCurrencyProvider));
    final catalog = await ref.read(catalogRepositoryProvider).load();
    final region = ref.read(catalogRegionProvider);
    final today = ref.read(todayProvider);
    for (final service in catalog.where((s) => _picked.contains(s.id))) {
      final sub = subscriptionFromCatalog(
        service,
        service.plans.first,
        region: region,
        id: subsRepo.newId(),
        today: today,
        now: DateTime.now(),
      );
      if (sub != null) await subsRepo.save(sub);
    }
    if (askPermission) {
      await ref.read(notificationServiceProvider).requestPermission();
      ref.invalidate(notificationsEnabledProvider);
    }
    await settingsRepo.setOnboardingDone(true);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final body = switch (_step) {
      0 => _welcome(context),
      1 => _currencyStep(context),
      2 => _quickAdd(context),
      _ => _reminders(context),
    };
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 4),
            if (_step < 2)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: () => setState(() => _step = 3), child: Text(l.onboardingSkip)),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _welcome(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(l.onboardingWelcomeTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          ListTile(leading: const Icon(Icons.notifications_active_outlined), title: Text(l.onboardingBenefitRemind)),
          ListTile(leading: const Icon(Icons.pie_chart_outline), title: Text(l.onboardingBenefitTotal)),
          ListTile(leading: const Icon(Icons.lock_outline), title: Text(l.onboardingBenefitPrivate)),
          const Spacer(),
          FilledButton(onPressed: () => setState(() => _step = 1), child: Text(l.onboardingStart)),
        ],
      ),
    );
  }

  static String _currencyLabel(String code) {
    final name = currencyNames[code];
    return name == null ? code : '$code — $name';
  }

  Widget _currencyStep(BuildContext context) {
    final l = context.l10n;
    final String current = _currency ?? ref.watch(primaryCurrencyProvider);
    final options = <String>{current, ...commonCurrencies}.toList();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.onboardingCurrencyTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(l.onboardingCurrencyHint),
          const SizedBox(height: 16),
          DropdownButton<String>(
            isExpanded: true,
            value: current,
            items: [
              for (final String c in options)
                DropdownMenuItem<String>(value: c, child: Text(_currencyLabel(c))),
            ],
            onChanged: (c) => setState(() => _currency = c),
          ),
          const Spacer(),
          FilledButton(onPressed: () => setState(() => _step = 2), child: Text(l.commonContinue)),
        ],
      ),
    );
  }

  Widget _quickAdd(BuildContext context) {
    final l = context.l10n;
    final region = ref.watch(catalogRegionProvider);
    final catalog = ref.watch(catalogProvider).value ?? const <CatalogService>[];
    final popular = [...catalog]
      ..sort((a, b) => (region == 'VN' && a.isVietnamese != b.isVietnamese) ? (a.isVietnamese ? -1 : 1) : 0);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l.onboardingQuickAddTitle, style: Theme.of(context).textTheme.headlineSmall),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final s in popular.take(30))
                CheckboxListTile(
                  secondary: ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram),
                  title: Text(s.name),
                  value: _picked.contains(s.id),
                  onChanged: (v) => setState(() => v! ? _picked.add(s.id) : _picked.remove(s.id)),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _picked.clear();
                  _step = 3;
                }),
                child: Text(l.onboardingLater),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => setState(() => _step = 3),
                child: Text(l.onboardingSelected(_picked.length)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reminders(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Icon(Icons.notifications_outlined, size: 64),
          const SizedBox(height: 16),
          Text(l.onboardingRemindersTitle, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(l.onboardingRemindersExample, textAlign: TextAlign.center),
          const Spacer(),
          FilledButton(onPressed: () => _finish(askPermission: true), child: Text(l.onboardingEnableReminders)),
          TextButton(onPressed: () => _finish(askPermission: false), child: Text(l.onboardingNoThanks)),
        ],
      ),
    );
  }
}
