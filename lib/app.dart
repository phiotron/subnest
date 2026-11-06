import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/service_tile_logo.dart';
import 'data/logos/logo_repository.dart';
import 'data/providers.dart';
import 'data/settings_repository.dart';
import 'l10n/generated/app_localizations.dart';

/// Root widget: theme, locale, router, and app-lifecycle housekeeping
/// (Trial → Active, daily rate refresh, reminder re-sync, notification deep links).
class SubnestApp extends ConsumerStatefulWidget {
  const SubnestApp({super.key, required this.router});

  final GoRouter router;

  @override
  ConsumerState<SubnestApp> createState() => _SubnestAppState();
}

class _SubnestAppState extends ConsumerState<SubnestApp> with WidgetsBindingObserver {
  StreamSubscription<String>? _tapSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final notifications = ref.read(notificationServiceProvider);
    _tapSub = notifications.taps.listen(_openDeepLink);
    final launch = notifications.launchRoute;
    if (launch != null) {
      notifications.launchRoute = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openDeepLink(launch));
    }
    unawaited(_housekeeping());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tapSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(todayProvider.notifier).refresh();
      ref.invalidate(notificationsEnabledProvider);
      unawaited(_housekeeping());
    }
  }

  Future<void> _housekeeping() async {
    await ref.read(subscriptionRepositoryProvider).normalizeAll();
    await ref.read(exchangeRateRepositoryProvider).refreshIfStale();
  }

  void _openDeepLink(String location) => widget.router.push(location);

  @override
  Widget build(BuildContext context) {
    ref.watch(reminderSyncProvider);
    final settings = ref.watch(settingsProvider).value;
    final code = settings?.localeCode;
    // Service logos (Logo.dev) for every ServiceTile; off — monogram only — in builds without a key.
    return ServiceLogoScope(
      source: LogoRepository.instance,
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).commonAppName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: switch (settings?.themeMode ?? AppThemeMode.system) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        },
        locale: code == null ? null : Locale(code),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: widget.router,
      ),
    );
  }
}
