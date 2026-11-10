import 'package:flutter/widgets.dart';

import '../../core/widgets/service_logo_source.dart';
import 'bundled_logos.g.dart';
import 'custom_logo_store.dart';

export '../../core/widgets/service_logo_source.dart';
export 'custom_logo_store.dart';

/// Logo of a Catalog service that has no bundled file — the hook for logos that arrive with the
/// remote Catalog later (session P2). Return `null` when there is none (→ monogram).
typedef RemoteServiceLogos = ImageProvider? Function(String serviceId);

/// The app's [ServiceLogoSource] (put at the root in `app.dart`):
///
/// * Catalog services → bundled PNG `assets/logos/png/<serviceId>.png` (made by
///   `tool/fetch_logos.py`, list in [bundledLogoIds]); none → [remote] → monogram.
/// * Custom logos → files of [CustomLogoStore].
///
/// No network, ever: logos show offline and on first launch.
class AppLogoSource extends ChangeNotifier implements ServiceLogoSource {
  AppLogoSource({required this.custom, this.bundled = bundledLogoIds}) {
    custom.addListener(notifyListeners);
  }

  static final AppLogoSource instance = AppLogoSource(custom: CustomLogoStore.instance);

  static const assetDir = 'assets/logos/png';

  static String assetPath(String serviceId) => '$assetDir/$serviceId.png';

  final CustomLogoStore custom;

  /// Service ids with a bundled PNG.
  final Set<String> bundled;
  RemoteServiceLogos? _remote;

  /// Whether [serviceId] has a logo bundled in the app.
  bool hasBundled(String serviceId) => bundled.contains(serviceId);

  RemoteServiceLogos? get remote => _remote;

  /// Plug in (or remove) logos from the remote Catalog; tiles redraw.
  set remote(RemoteServiceLogos? value) {
    _remote = value;
    notifyListeners();
  }

  @override
  ImageProvider? serviceLogo(String serviceId) =>
      bundled.contains(serviceId) ? AssetImage(assetPath(serviceId)) : _remote?.call(serviceId);

  @override
  ImageProvider? customLogo(String subscriptionId) {
    final file = custom.fileOf(subscriptionId);
    return file == null ? null : FileImage(file);
  }

  @override
  void dispose() {
    custom.removeListener(notifyListeners);
    super.dispose();
  }
}
