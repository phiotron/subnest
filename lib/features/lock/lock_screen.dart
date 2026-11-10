import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../settings/backup_actions.dart';
import 'app_lock.dart';
import 'pin_pad.dart';

/// Puts the lock screen in front of the whole app while App lock is locked (AC-32). Used as
/// `MaterialApp.router(builder: …)`, so it sits OUTSIDE the router: the routes stay mounted
/// underneath, hidden (Offstage: not painted, not hit-tested, out of the semantics tree).
///
/// Deep links (notification taps, home-screen widget taps) go into the router as usual while the
/// lock screen is up; the user sees that screen only after the right PIN.
///
/// Also watches the app going to the background and coming back ([LockNotifier.onHidden] /
/// [LockNotifier.onResumed]) and keeps the system Back button from reaching the hidden routes.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.router, required this.child});

  /// Where "Forgot PIN" goes after deleting everything (onboarding); the lock screen has no
  /// `GoRouter` above it.
  final GoRouter router;
  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> with WidgetsBindingObserver {
  late final AppLifecycleListener _lifecycle;
  final _lockNavigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Registered before the router's back-button dispatcher (this widget is its ancestor), so a
    // Back press while locked reaches [didPopRoute] here first.
    WidgetsBinding.instance.addObserver(this);
    _lifecycle = AppLifecycleListener(
      onHide: () => ref.read(lockProvider.notifier).onHidden(),
      onResume: () => unawaited(ref.read(lockProvider.notifier).onResumed()),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lifecycle.dispose();
    super.dispose();
  }

  /// Back while locked: close a dialog of the lock screen, otherwise leave the app — never pop a
  /// hidden route.
  @override
  Future<bool> didPopRoute() async {
    if (ref.read(lockProvider) == AppLockState.unlocked) return false;
    final nav = _lockNavigator.currentState;
    if (nav != null && await nav.maybePop()) return true;
    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(lockProvider, (_, next) {
      // A text field of a hidden screen must not keep the keyboard up over the lock screen.
      if (next != AppLockState.unlocked) FocusManager.instance.primaryFocus?.unfocus();
    });
    final lock = ref.watch(lockProvider);
    final locked = lock != AppLockState.unlocked;
    return Stack(
      children: [
        Offstage(offstage: locked, child: TickerMode(enabled: !locked, child: widget.child)),
        if (locked)
          LockScreen(
            checking: lock == AppLockState.checking,
            navigatorKey: _lockNavigator,
            router: widget.router,
          ),
      ],
    );
  }
}

/// The lock screen (A002 1.1–1.5 layout): lock icon, "Enter PIN", dots, keypad, "Forgot PIN".
/// Has its own Navigator (it lives outside the router's) for the "Forgot PIN" dialogs.
class LockScreen extends StatelessWidget {
  const LockScreen({super.key, required this.checking, required this.router, this.navigatorKey});

  /// Cold start, still reading secure storage: a blank screen in the app background colour.
  final bool checking;
  final GoRouter router;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (checking) return ColoredBox(color: context.colors.bg, child: const SizedBox.expand());
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => _LockBody(router: router)),
    );
  }
}

class _LockBody extends ConsumerStatefulWidget {
  const _LockBody({required this.router});

  final GoRouter router;

  @override
  ConsumerState<_LockBody> createState() => _LockBodyState();
}

class _LockBodyState extends ConsumerState<_LockBody> {
  String? _error;

  /// "Forgot PIN": a PIN cannot be recovered → offer "Delete all data", which asks twice more
  /// ([BackupActions.deleteAll]) and leaves the app like a new install. Cancel at any step comes
  /// back here.
  Future<void> _forgot() async {
    final l = context.l10n;
    final ok = await showAppDialog<bool>(
      context,
      title: l.securityForgotPinTitle,
      body: l.securityForgotPinBody,
      actions: [
        Builder(
          builder: (ctx) =>
              AppButton.danger(label: l.settingsDeleteAll, expand: true, onPressed: () => Navigator.pop(ctx, true)),
        ),
        Builder(
          builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
      ],
    );
    if (ok != true || !mounted) return;
    final router = widget.router;
    if (!await BackupActions.deleteAll(context, ref)) return;
    // The PIN is gone with everything else (eraseEverything); the routes come back as onboarding.
    router.go(AppRoutes.onboarding);
    ref.read(lockProvider.notifier).unlockAfterReset();
  }

  Future<void> _check(String pin) async {
    final ok = await ref.read(lockProvider.notifier).unlock(pin);
    if (ok || !mounted) return;
    unawaited(HapticFeedback.lightImpact());
    setState(() => _error = context.l10n.securityWrongPin);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    // Keypad at the bottom, "Forgot PIN" under it; scrolls when there is not enough room
    // (200 % text).
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpace.s10),
                child: Column(
                  children: [
                    Expanded(
                      child: PinPad(
                        expand: true,
                        leading: Icon(AppIcons.privacy, size: 40, color: c.brand),
                        title: l.securityEnterPin,
                        error: _error,
                        onCompleted: _check,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s2),
                      child: AppButton.text(label: l.securityForgotPin, onPressed: _forgot),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
