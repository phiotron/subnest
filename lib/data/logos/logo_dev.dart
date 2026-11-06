/// Logo.dev image CDN (ADR 0002 §5, CONTEXT "Service logo", privacy policy "Service logos").
///
/// The only request the app makes is `https://img.logo.dev/<logoDomain>` where `logoDomain` comes
/// from the Catalog (never guessed from a name the user typed), plus the publishable key and fixed
/// size/format parameters — nothing about the user (S-42).
library;

abstract final class LogoDev {
  /// Publishable key (`pk_…`), passed at build time:
  /// `--dart-define=LOGO_DEV_KEY=…` (docs/dev.md §7, docs/ci.md §2). Empty → no logos, no network.
  static const String keyFromEnvironment = String.fromEnvironment('LOGO_DEV_KEY');

  /// Attribution link required on the free plan ("Logos provided by Logo.dev").
  static const String attributionUrl = 'https://logo.dev';

  static const String host = 'img.logo.dev';

  /// Requested side in logical px; `retina=true` doubles it (256 px) — sharp up to the 80 px
  /// detail tile at 3× while keeping one cached file per domain.
  static const int size = 128;

  /// Only publishable keys may ship in the app; a secret key (`sk_…`) or garbage disables logos.
  static bool isPublishableKey(String key) => RegExp(r'^pk_[A-Za-z0-9_-]{8,}$').hasMatch(key.trim());

  static final RegExp _domain = RegExp(
    r'^(?=.{4,253}$)([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+([a-z]{2,63}|xn--[a-z0-9-]{1,59})$',
  );

  /// Lower-cased bare host name (`netflix.com`), or `null` when [raw] is not one (paths, ports,
  /// schemes, spaces, IPs and user text are all rejected → monogram tile).
  static String? normalizeDomain(String? raw) {
    if (raw == null) return null;
    final d = raw.trim().toLowerCase();
    return _domain.hasMatch(d) ? d : null;
  }

  /// `https://img.logo.dev/<domain>?token=<key>&size=128&format=png&retina=true&fallback=404`.
  ///
  /// `fallback=404` makes a missing logo a 404 instead of a generated letter image (we draw our
  /// own monogram tile). PNG keeps transparency; the tile puts it on a light plate.
  static Uri imageUri(String domain, String key) => Uri(
    scheme: 'https',
    host: host,
    path: '/$domain',
    queryParameters: {'token': key.trim(), 'size': '$size', 'format': 'png', 'retina': 'true', 'fallback': '404'},
  );
}
