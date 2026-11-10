import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';

/// 4-digit PIN entry with the app's own keypad (layout from A002 `.vg-pin`, styled with the
/// Subnest design system). Calls [onCompleted] once 4 digits are in, then clears the dots.
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

  /// Under the title, e.g. the "if you forget the PIN…" warning when choosing one.
  final String? message;

  /// Red line under the dots (wrong PIN, PINs do not match). Fixed height: the keypad never jumps.
  final String? error;

  /// Above the title, e.g. the lock icon on the lock screen.
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

  String _pin = '';
  bool _busy = false;

  Future<void> _press(String key) async {
    if (_busy) return;
    if (key == _backspace) {
      if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
      return;
    }
    if (_pin.length >= 4) return;
    setState(() => _pin += key);
    if (_pin.length == 4) {
      _busy = true;
      try {
        await widget.onCompleted(_pin);
      } finally {
        _busy = false;
        if (mounted) setState(() => _pin = '');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;

    Widget key(String k) => SizedBox(
      width: 88,
      height: 64,
      child: k.isEmpty
          ? null
          : TextButton(
              key: ValueKey('pin-key-$k'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: k == _backspace ? null : c.surface2,
                foregroundColor: k == _backspace ? c.inkMuted : c.ink,
                textStyle: AppType.headline.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                shape: const StadiumBorder(),
              ),
              onPressed: () => _press(k),
              child: k == _backspace
                  ? Icon(LucideIcons.delete, size: 24, semanticLabel: l.securityKeypadBackspace)
                  : Text(k, semanticsLabel: l.securityKeypadDigit(k)),
            ),
    );

    Widget row(List<String> keys) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.s3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < keys.length; i++) ...[if (i > 0) const SizedBox(width: AppSpace.s6), key(keys[i])],
        ],
      ),
    );

    return Column(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (widget.leading != null) ...[widget.leading!, const SizedBox(height: AppSpace.s3)],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s6),
          child: Semantics(
            header: true,
            child: Text(
              widget.title,
              style: AppType.title.copyWith(color: c.ink),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (widget.message != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s8, AppSpace.s2, AppSpace.s8, 0),
            child: Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: AppType.meta.copyWith(color: c.inkMuted),
            ),
          ),
        const SizedBox(height: AppSpace.s6),
        Semantics(
          liveRegion: true,
          label: l.securityPinProgress(_pin.length),
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: AppSpace.s4),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length ? c.ink : null,
                    border: Border.all(color: i < _pin.length ? c.ink : c.lineStrong, width: 2),
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 24),
          margin: const EdgeInsets.only(top: AppSpace.s3),
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s6),
          alignment: Alignment.center,
          child: widget.error == null
              ? null
              : Semantics(
                  liveRegion: true,
                  child: Text(
                    widget.error!,
                    textAlign: TextAlign.center,
                    style: AppType.meta.copyWith(color: c.danger),
                  ),
                ),
        ),
        if (widget.expand) const Spacer(),
        row(const ['1', '2', '3']),
        row(const ['4', '5', '6']),
        row(const ['7', '8', '9']),
        row(const ['', '0', _backspace]),
      ],
    );
  }
}
