/// Minimum touch target of every interactive core component — factory standard **S-50**
/// (WCAG 2.2 AA + Android guideline: 48 × 48dp). The design token `AppSize.tapMin` (44, iOS HIG)
/// is the *visual* minimum; components keep their mockup size and pad the hit area up to this.
abstract final class AppTouch {
  static const double min = 48;
}
