import 'package:flutter/widgets.dart';

/// Where [ServiceTile] gets logo images from. The app provides `AppLogoSource.instance`
/// (data/logos) through `ServiceLogoScope` in `app.dart`; tests and the gallery inject their own.
/// Without a scope tiles use [ServiceLogoSource.none] (monogram only).
///
/// Never touches the network: Catalog logos are bundled assets, custom logos are files the user
/// picked. A later remote-Catalog logo plugs in behind [serviceLogo] (data/logos `AppLogoSource.remote`).
/// Notifies its listeners when a custom logo is added, replaced or removed, so tiles redraw.
abstract interface class ServiceLogoSource implements Listenable {
  /// Never has a logo — the default when no `ServiceLogoScope` is above a tile.
  static const ServiceLogoSource none = _NoLogos();

  /// Logo of a Catalog service (`Service.id`): the bundled image, `null` = none (monogram).
  ImageProvider? serviceLogo(String serviceId);

  /// Image the user picked for one subscription (Custom logo), `null` = none.
  ImageProvider? customLogo(String subscriptionId);
}

class _NoLogos implements ServiceLogoSource {
  const _NoLogos();

  @override
  ImageProvider? serviceLogo(String serviceId) => null;

  @override
  ImageProvider? customLogo(String subscriptionId) => null;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
