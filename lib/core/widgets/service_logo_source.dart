import 'dart:typed_data';

/// Where [ServiceTile] gets logo bytes from. The app provides `LogoRepository.instance`
/// (data/logos) through `ServiceLogoScope` in `app.dart`; tests and the gallery inject their own.
/// Without a scope tiles use [ServiceLogoSource.none] (monogram only, no network).
abstract interface class ServiceLogoSource {
  /// Never has a logo — the default when no `ServiceLogoScope` is above a tile.
  static const ServiceLogoSource none = _NoLogos();

  /// `false` → tiles never ask (no key in this build): monogram only, no network.
  bool get enabled;

  /// Bytes already in memory — lets a tile that scrolls back into view draw its logo in the
  /// first frame (no monogram → logo flash).
  Uint8List? peek(String logoDomain);

  /// Memory → disk → Logo.dev. `null` = no logo (missing, offline, error, invalid domain). Never throws.
  Future<Uint8List?> load(String logoDomain);
}

class _NoLogos implements ServiceLogoSource {
  const _NoLogos();

  @override
  bool get enabled => false;

  @override
  Uint8List? peek(String logoDomain) => null;

  @override
  Future<Uint8List?> load(String logoDomain) => Future.value();
}
