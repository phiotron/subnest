import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../settings/widgets/app_mark.dart';
import 'app_lock.dart';
import 'pin_pad.dart';

/// Turning App lock on and off from Settings (A002 8.1–8.4). The PIN screens cover the whole app
/// (root navigator: no tab bar under the keypad).
abstract final class PinActions {
  /// Choose a PIN: full-screen, entered twice; the first step warns that a forgotten PIN means
  /// deleting all data. Back / ‹ cancels and the lock stays off. True when the PIN was set.
  static Future<bool> turnOn(BuildContext context, WidgetRef ref) async {
    final pin = await Navigator.of(
      context,
      rootNavigator: true,
    ).push<String>(MaterialPageRoute(builder: (_) => const PinSetupScreen()));
    if (pin == null) return false;
    await ref.read(pinServiceProvider).setPin(pin);
    ref.invalidate(pinEnabledProvider);
    return true;
  }

  /// "Change PIN" (Settings, PIN on — mockup 090): the current PIN first, then a new one twice.
  /// Back at any step keeps the old PIN. True when the PIN was changed.
  static Future<bool> change(BuildContext context, WidgetRef ref) async {
    final nav = Navigator.of(context, rootNavigator: true);
    final ok = await nav.push<bool>(MaterialPageRoute(builder: (_) => const PinCheckScreen()));
    if (ok != true) return false;
    final pin = await nav.push<String>(MaterialPageRoute(builder: (_) => const PinSetupScreen()));
    if (pin == null) return false;
    await ref.read(pinServiceProvider).setPin(pin);
    ref.invalidate(pinEnabledProvider);
    return true;
  }

  /// Turn the lock off: only with the current PIN. True when it was turned off.
  static Future<bool> turnOff(BuildContext context, WidgetRef ref) async {
    final ok = await Navigator.of(
      context,
      rootNavigator: true,
    ).push<bool>(MaterialPageRoute(builder: (_) => const PinCheckScreen()));
    if (ok != true) return false;
    await ref.read(pinServiceProvider).disable();
    ref.invalidate(pinEnabledProvider);
    return true;
  }
}

/// Frame of the Settings PIN screens (mockup 104–105): top bar "PIN lock" with ‹ (cancels), then
/// the same block as the lock screen — app mark, title, dots, message, keypad.
class _PinScaffold extends StatelessWidget {
  const _PinScaffold({required this.pad});

  final PinPad pad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppTopBar(title: context.l10n.securityPinLock),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s6),
                child: Align(alignment: Alignment.topCenter, child: pad),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Choose a 4-digit PIN, then enter it again. Pops with the PIN when both match.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String? _first;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final firstStep = _first == null;
    return _PinScaffold(
      pad: PinPad(
        // A new pad per step: the dots start empty.
        key: ValueKey(firstStep),
        leading: const AppMark(size: 56, radius: 13),
        title: firstStep ? l.securityNewPin : l.securityConfirmPin,
        message: firstStep ? l.securityPinSetNote : null,
        error: _error,
        onCompleted: (pin) async {
          if (firstStep) {
            setState(() {
              _first = pin;
              _error = null;
            });
          } else if (pin == _first) {
            Navigator.pop(context, pin);
          } else {
            // Start over from the first step.
            unawaited(HapticFeedback.lightImpact());
            setState(() {
              _first = null;
              _error = l.securityPinMismatch;
            });
          }
        },
      ),
    );
  }
}

/// Enter the current PIN. Pops with true when it is right.
class PinCheckScreen extends ConsumerStatefulWidget {
  const PinCheckScreen({super.key});

  @override
  ConsumerState<PinCheckScreen> createState() => _PinCheckScreenState();
}

class _PinCheckScreenState extends ConsumerState<PinCheckScreen> {
  String? _error;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _PinScaffold(
      pad: PinPad(
        leading: const AppMark(size: 56, radius: 13),
        title: l.securityEnterPin,
        error: _error,
        onCompleted: (pin) async {
          var ok = false;
          try {
            ok = await ref.read(pinServiceProvider).verify(pin);
          } catch (_) {
            // Secure storage error: treat as wrong.
          }
          if (!mounted) return;
          if (ok) {
            Navigator.pop(this.context, true);
            return;
          }
          unawaited(HapticFeedback.lightImpact());
          setState(() => _error = l.securityWrongPin);
        },
      ),
    );
  }
}
