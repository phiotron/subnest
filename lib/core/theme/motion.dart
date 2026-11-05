import 'package:flutter/widgets.dart';

/// Motion tokens (design/system/README.md § Motion): 150–250 ms, ease-out, each with a reason.
/// Nothing loops. Reduce-motion ([reduced]) cuts straight to the end state.
abstract final class AppMotion {
  /// Default UI transition (segment thumb, chip select, colour changes).
  static const fast = Duration(milliseconds: 150);

  /// The hero total counts up when switching Month ↔ Year.
  static const countUp = Duration(milliseconds: 240);

  /// Sheets slide up over a fading scrim.
  static const sheet = Duration(milliseconds: 240);

  /// Dialogs scale in (0.94 → 1) and fade.
  static const dialog = Duration(milliseconds: 200);

  /// "Paid" pops a success check.
  static const paidPop = Duration(milliseconds: 220);

  /// A newly added row flashes `brand-soft` once.
  static const newRowFlash = Duration(milliseconds: 1600);

  /// Cancelling a subscription earns a confetti fall.
  static const confetti = Duration(milliseconds: 1400);

  static const Curve ease = Curves.easeOut;

  /// Sheet curve from the mockup (`cubic-bezier(.2,.8,.2,1)`).
  static const Curve sheetCurve = Cubic(.2, .8, .2, 1);

  /// True when the OS asks for reduced motion — use [Duration.zero] then.
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// [d], or zero under reduce-motion.
  static Duration of(BuildContext context, Duration d) => reduced(context) ? Duration.zero : d;
}
