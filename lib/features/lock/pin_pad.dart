import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';

/// 4-digit PIN entry with the app's own keypad (mockup v14 002–005, `.pinw`): title, 4 dots, a
/// message line, a 3 × 4 grid of round 76 px keys. Calls [onCompleted] once 4 digits are in, then
/// clears the dots.
///
/// An [error] from the parent turns the dots and the message line `danger` until the next key
/// press (`.pin-dots.err`), so the same error after a second wrong try shows again.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.title,
    required this.onCompleted,
    this.error,
    this.message,
    this.leading,
    this.expand = false,
  });

  final String title;

  /// Muted line under the dots when there is no error, e.g. "You'll enter it when Subnest opens…".
  final String? message;

  /// Red line under the dots (wrong PIN, PINs do not match). Fixed height: the keypad never jumps.
  final String? error;

  /// Above the title, e.g. the app mark.
  final Widget? leading;

  /// Pushes the keypad to the bottom of the space it gets; the parent must give a bounded
  /// height (e.g. `SliverFillRemaining`).
  final bool expand;

  final Future<void> Function(String pin) onCompleted;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> {
  static const _backspace = '⌫';

  /// `.pinpad` grid: 76 px keys, 28 px between columns, 14 px between rows.
  static const _key = 76.0;
  static const _colGap = 28.0;
  static const _rowGap = 14.0;

  String _pin = '';
  bool _busy = false;

  /// A key was pressed since the last 4-digit entry: hide the parent's error.
  bool _typed = false;

  bool get _showError => widget.error != null && !_typed;

  Future<void> _press(String key) async {
    if (_busy) return;
    if (key == _backspace) {
      setState(() {
        _typed = true;
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      });
      return;
    }
    if (_pin.length >= 4) return;
    setState(() {
      _typed = true;
      _pin += key;
    });
    if (_pin.length == 4) {
      _busy = true;
      try {
        await widget.onCompleted(_pin);
      } finally {
        _busy = false;
        if (mounted) {
          setState(() {
            _pin = '';
            _typed = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final error = _showError;
    // Digits stay inside their 76 px circle at 200 % text.
    final keyScaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.6);

    Widget key(String k) {
      if (k.isEmpty) return const SizedBox(width: _key, height: _key);
      final del = k == _backspace;
      return SizedBox(
        width: _key,
        height: _key,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: del ? null : c.surface,
            boxShadow: del ? null : context.elevation.card,
          ),
          child: Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('pin-key-$k'),
              onTap: () => _press(k),
              child: Center(
                child: del
                    ? Icon(LucideIcons.delete, size: 26, color: c.ink, semanticLabel: l.securityKeypadBackspace)
                    : Text(
                        k,
                        semanticsLabel: l.securityKeypadDigit(k),
                        textScaler: keyScaler,
                        style: TextStyle(
                          fontFamily: AppType.fontFamily,
                          fontSize: 28,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          color: c.ink,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
    }

    Widget row(List<String> keys) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < keys.length; i++) ...[if (i > 0) const SizedBox(width: _colGap), key(keys[i])],
      ],
    );

    final line = error ? widget.error : widget.message;

    return Column(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.leading != null) widget.leading!,
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.s6, 18, AppSpace.s6, 18),
          child: Semantics(
            header: true,
            child: Text(
              widget.title,
              style: AppType.title.copyWith(color: c.ink),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Semantics(
          liveRegion: true,
          label: l.securityPinProgress(_pin.length),
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 18),
                _Dot(on: error || i < _pin.length, error: error),
              ],
            ],
          ),
        ),
        // `.pin-msg`: at least 36 px, 14 px above, 6 px below, at most 280 px wide.
        Container(
          constraints: const BoxConstraints(minHeight: 36, maxWidth: 280),
          margin: const EdgeInsets.only(top: 14, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s2),
          alignment: Alignment.topCenter,
          child: line == null
              ? null
              : Semantics(
                  liveRegion: error,
                  child: Text(
                    line,
                    textAlign: TextAlign.center,
                    style: AppType.meta.copyWith(color: error ? c.danger : c.inkMuted),
                  ),
                ),
        ),
        if (widget.expand) const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: AppSpace.s2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              row(const ['1', '2', '3']),
              const SizedBox(height: _rowGap),
              row(const ['4', '5', '6']),
              const SizedBox(height: _rowGap),
              row(const ['7', '8', '9']),
              const SizedBox(height: _rowGap),
              row(const ['', '0', _backspace]),
            ],
          ),
        ),
      ],
    );
  }
}

/// One `.pin-dots i`: 16 px ring in `line-strong`; filled `brand` when typed; `danger` on error.
class _Dot extends StatelessWidget {
  const _Dot({required this.on, required this.error});

  final bool on;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = error ? c.danger : c.brand;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? color : null,
        border: on ? null : Border.all(color: error ? c.danger : c.lineStrong, width: 2),
      ),
    );
  }
}
