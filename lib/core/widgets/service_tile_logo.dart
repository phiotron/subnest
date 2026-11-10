import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'service_logo_source.dart';

export 'service_logo_source.dart';

/// Tells the [ServiceTile]s below where to get logos. The app puts one with
/// `AppLogoSource.instance` (data/logos) at the root (`app.dart`); tests and the gallery inject
/// their own. Without one: [ServiceLogoSource.none] (monogram only). Tiles rebuild when the
/// source notifies (a custom logo changed).
class ServiceLogoScope extends InheritedNotifier<ServiceLogoSource> {
  const ServiceLogoScope({super.key, required ServiceLogoSource source, required super.child})
    : super(notifier: source);

  static ServiceLogoSource of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ServiceLogoScope>()?.notifier ?? ServiceLogoSource.none;
}

/// Logo layer drawn over the monogram inside a [ServiceTile].
///
/// Draws nothing until the image has a decoded frame, so the monogram underneath stays visible
/// while decoding or when the image is broken — then fades the logo in on a light plate
/// (`on-tile-light`: logos with transparency are made for light backgrounds, also in dark mode).
/// An image already in the image cache is drawn in the first frame without a fade.
class ServiceTileLogo extends StatelessWidget {
  const ServiceTileLogo({super.key, required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    final plate = context.colors.onTileLight;
    final fade = AppMotion.of(context, AppMotion.fast);
    return Image(
      image: image,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, sync) => AnimatedOpacity(
        opacity: frame == null ? 0 : 1,
        duration: sync ? Duration.zero : fade,
        child: ColoredBox(color: plate, child: child),
      ),
      errorBuilder: (context, error, stack) => const SizedBox.shrink(),
    );
  }
}
