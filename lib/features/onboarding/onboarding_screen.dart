import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../catalog/catalog_helpers.dart';
import '../subscription_form/form_format.dart';
import 'quick_pick.dart';
import 'widgets/pick_step.dart';
import 'widgets/quick_edit_sheet.dart';
import 'widgets/simple_steps.dart';

/// S1 Onboarding (png 02–07), shown on first launch only (`main.dart` routes here while
/// `AppSettings.onboardingDone` is false):
/// 1 Language → 2 Welcome → 3 Main currency → 4 What do you pay for? → 5 Reminders explainer →
/// OS dialog → Overview with the picked services already there. "Skip" (Welcome, currency) jumps to
/// the reminders step; system Back goes one step back.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _languageStep = 0, _welcome = 1, _currencyStep = 2, _pickStep = 3, _remindersStep = 4;

  int _step = _languageStep;
  String? _currency;
  final _picks = <String, QuickPick>{};
  String? _lastPicked;
  bool _finishing = false;

  String get _region => ref.read(catalogRegionProvider);
  String get _chosenCurrency => _currency ?? ref.read(primaryCurrencyProvider);

  void _go(int step) => setState(() => _step = step);

  Future<void> _toggle(CatalogService s) async {
    if (_picks.remove(s.id) != null) {
      setState(() => _lastPicked = _picks.keys.lastOrNull);
      return;
    }
    final pick = QuickPick.suggested(s, _region, _chosenCurrency);
    setState(() {
      _picks[s.id] = pick;
      _lastPicked = s.id;
    });
    if (!pick.hasPrice) await _edit(s.id);
  }

  Future<void> _edit(String id) async {
    final pick = _picks[id];
    if (pick == null) return;
    final result = await showQuickEditSheet(context, pick: pick, region: _region);
    if (!mounted) return;
    if (result == null) {
      // Dismissed without a price → the pick can't be added.
      if (!pick.hasPrice) setState(() => _picks.remove(id));
      return;
    }
    setState(() {
      if (result.remove) {
        _picks.remove(id);
        _lastPicked = _picks.keys.lastOrNull;
        return;
      }
      pick
        ..plan = result.plan ?? pick.plan
        ..priceMinor = result.priceMinor
        ..currency = result.currency
        ..cycle = result.cycle ?? pick.cycle;
    });
  }

  Future<void> _saveCurrency() async {
    await ref.read(settingsRepositoryProvider).setPrimaryCurrency(_chosenCurrency);
  }

  Future<void> _finish({required bool askPermission}) async {
    if (_finishing) return;
    setState(() => _finishing = true);
    try {
      final settings = ref.read(settingsRepositoryProvider);
      final repo = ref.read(subscriptionRepositoryProvider);
      final today = ref.read(todayProvider);
      final now = ref.read(clockProvider)();
      await settings.setPrimaryCurrency(_chosenCurrency);
      for (final pick in _picks.values) {
        if (pick.hasPrice) await repo.save(pick.toSubscription(id: repo.newId(), today: today, now: now));
      }
      if (askPermission) {
        await ref.read(notificationServiceProvider).requestPermission();
        ref.invalidate(notificationsEnabledProvider);
      }
      await settings.setOnboardingDone(true);
      if (mounted) context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  /// ≈ Monthly cost of the picks in the main currency (picks without a known rate are left out).
  double? _monthlyTotal(LocalDate today) {
    if (_picks.isEmpty) return null;
    final calc = SpendingCalculator(
      rates: ref.watch(ratesProvider).value ?? ExchangeRates.empty,
      primaryCurrency: _chosenCurrency,
    );
    final now = DateTime(today.year, today.month, today.day);
    var total = 0.0;
    for (final p in _picks.values) {
      total += calc.monthlyCost(p.toSubscription(id: p.service.id, today: today, now: now)) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final region = ref.watch(catalogRegionProvider);
    final String currency = _currency ?? ref.watch(primaryCurrencyProvider);
    final today = ref.watch(todayProvider);

    final Widget body = switch (_step) {
      _languageStep => LanguageStep(
        code: ref.watch(settingsProvider).value?.localeCode ?? 'en',
        onChanged: (code) => ref.read(settingsRepositoryProvider).setLocale(code),
        onNext: () => _go(_welcome),
      ),
      _welcome => WelcomeStep(onNext: () => _go(_currencyStep), onSkip: () => _go(_remindersStep)),
      _currencyStep => CurrencyStep(
        currency: currency,
        knownCodes: ref.watch(ratesProvider).value?.usdRates.keys ?? const [],
        onChanged: (code) => setState(() => _currency = code),
        onNext: () {
          _saveCurrency();
          _go(_pickStep);
        },
        onSkip: () => _go(_remindersStep),
      ),
      _pickStep => PickStep(
        services: CatalogView.ordered(ref.watch(catalogProvider).value ?? const [], region),
        picks: _picks,
        lastPicked: _lastPicked,
        monthlyTotal: _monthlyTotal(today),
        totalCurrency: currency,
        onToggle: _toggle,
        onEdit: _edit,
        onLater: () => setState(() {
          _picks.clear();
          _lastPicked = null;
          _step = _remindersStep;
        }),
        onNext: () => _go(_remindersStep),
      ),
      _ => _reminders(context, l, region, currency),
    };

    return PopScope(
      canPop: _step == _languageStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_finishing) _go(_step - 1);
      },
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: AppMotion.of(context, AppMotion.fast),
          child: KeyedSubtree(key: ValueKey(_step), child: body),
        ),
      ),
    );
  }

  Widget _reminders(BuildContext context, AppLocalizations l, String region, String currency) {
    final settings = ref.watch(settingsProvider).value;
    final time = FormFormat.time(settings?.reminderHour ?? 9, settings?.reminderMinute ?? 0);
    // The sample uses the user's first pick (else Netflix's suggested price), in its own currency.
    final first = _picks.values.where((p) => p.hasPrice).firstOrNull;
    final catalog = ref.watch(catalogProvider).value ?? const <CatalogService>[];
    var name = 'Netflix';
    // The example is always in USD: it is the default for every new install (S-90).
    var price = l.amount(15.49, 'USD');
    if (first != null) {
      name = first.service.name;
      price = l.money(Money(first.priceMinor, first.currency));
    } else {
      final netflix = catalog.where((s) => s.id == 'netflix').firstOrNull;
      final plan = netflix == null ? null : CatalogView.plans(netflix, region).lastOrNull;
      final p = plan?.priceFor(region);
      if (p != null) price = l.amount(p.amount, p.currency);
    }
    return RemindersStep(
      time: time,
      demoName: name,
      demoPrice: price,
      trialName: 'Spotify',
      busy: _finishing,
      onEnable: () => _finish(askPermission: true),
      onNotNow: () => _finish(askPermission: false),
    );
  }
}
