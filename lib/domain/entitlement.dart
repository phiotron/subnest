/// What the user has unlocked (glossary: Pro = the automatic part, every Detection source).
/// Manual entry is always free. Version 1.0 unlocks everything; IAP plugs in behind `entitlementProvider`.
class Entitlement {
  const Entitlement({required this.isPro});

  /// 1.0: Pro is open to everyone until pricing is decided.
  static const Entitlement launch = Entitlement(isPro: true);
  static const Entitlement free = Entitlement(isPro: false);

  final bool isPro;

  /// Whether automatic detection features may run.
  bool get canAutoDetect => isPro;
}
