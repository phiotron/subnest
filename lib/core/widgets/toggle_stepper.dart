import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'touch.dart';

/// On/off switch (design Components › ToggleStepper): 52×32 pill.
/// Off: `surface-2` with a 2px `line-strong` ring and a 16px `line-strong` knob.
/// On: `brand` with a 24px `on-brand` knob. 52 × 48dp touch target.
class AppToggle extends StatelessWidget {
  const AppToggle({super.key, required this.value, required this.onChanged, this.semanticLabel});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final d = AppMotion.of(context, AppMotion.fast);
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: SizedBox(
          width: 52,
          height: AppTouch.min,
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : .45,
              child: AnimatedContainer(
                duration: d,
                curve: AppMotion.ease,
                width: 52,
                height: 32,
                decoration: BoxDecoration(
                  color: value ? c.brand : c.surface2,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: value ? null : Border.all(color: c.lineStrong, width: 2),
                ),
                child: AnimatedAlign(
                  duration: d,
                  curve: AppMotion.ease,
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: d,
                    curve: AppMotion.ease,
                    margin: EdgeInsets.symmetric(horizontal: value ? 4 : 6),
                    width: value ? 24 : 16,
                    height: value ? 24 : 16,
                    decoration: BoxDecoration(color: value ? c.onBrand : c.lineStrong, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// − value + stepper (shared-plan member count, "every N" fields): `surface-2` pill track,
/// 36px `surface` round buttons with `shadow-card`, value 17/700 tabular. 44px visible track,
/// 48dp buttons (the track is drawn 2px inside the hit area).
class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.decreaseLabel = '−',
    this.increaseLabel = '+',
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;

  /// Accessible labels ("Fewer" / "More").
  final String decreaseLabel;
  final String increaseLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget button(IconData icon, String label, int? next) {
      final enabled = onChanged != null && next != null;
      return Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled
              ? () {
                  HapticFeedback.selectionClick();
                  onChanged!(next);
                }
              : null,
          child: SizedBox.square(
            dimension: AppTouch.min,
            child: Center(
              child: Opacity(
                opacity: enabled ? 1 : .45,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.surface,
                    shape: BoxShape.circle,
                    boxShadow: context.elevation.card,
                  ),
                  child: Icon(icon, size: 18, color: c.ink),
                ),
              ),
            ),
          ),
        ),
      );
    }

    const inset = (AppTouch.min - 44) / 2;
    return SizedBox(
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(inset),
              child: DecoratedBox(
                decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.full)),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              button(AppIcons.remove, decreaseLabel, value > min ? value - 1 : null),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 28),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppType.titleSm.copyWith(fontSize: 17, fontWeight: FontWeight.w700, color: c.ink).tabular,
                ),
              ),
              button(AppIcons.add, increaseLabel, value < max ? value + 1 : null),
            ],
          ),
        ],
      ),
    );
  }
}
