/// Where the app read a subscription / charge by itself — always processed on the device
/// (glossary: Detection source; ADR 0003). Stored by [name].
enum DetectionSource {
  /// Screenshot of a store subscription page or a receipt (1.0).
  scan,

  /// Bank / wallet notification chosen by the user (1.1, Android).
  notification,

  /// Gmail receipt (1.2).
  gmail;

  static DetectionSource? tryName(String? name) => values.where((e) => e.name == name).firstOrNull;
}
