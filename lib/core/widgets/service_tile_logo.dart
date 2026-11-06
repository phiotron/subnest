import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';
import 'service_logo_source.dart';

export 'service_logo_source.dart';

/// Tells the [ServiceTile]s below where to get logos. The app puts one with
/// `LogoRepository.instance` (data/logos) at the root (`app.dart`) — off in builds without a key;
/// tests and the gallery inject their own. Without one: [ServiceLogoSource.none] (monogram only).
class ServiceLogoScope extends InheritedWidget {
  const ServiceLogoScope({super.key, required this.source, required super.child});

  final ServiceLogoSource source;

  static ServiceLogoSource of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ServiceLogoScope>()?.source ?? ServiceLogoSource.none;

  @override
  bool updateShouldNotify(ServiceLogoScope oldWidget) => source != oldWidget.source;
}

/// Logo layer drawn over the monogram inside a [ServiceTile].
///
/// Draws nothing until the image has a decoded frame, so the monogram underneath stays visible
/// while loading, offline or when there is no logo — then fades the logo in on a light plate
/// (`on-tile-light`; Logo.dev logos are made for light backgrounds, also in dark mode). Bytes
/// already in memory are drawn in the first frame without a fade (no flicker when scrolling).
class ServiceTileLogo extends StatefulWidget {
  const ServiceTileLogo({super.key, required this.logoDomain});

  final String logoDomain;

  @override
  State<ServiceTileLogo> createState() => _ServiceTileLogoState();
}

class _ServiceTileLogoState extends State<ServiceTileLogo> {
  ServiceLogoSource? _source;
  Uint8List? _bytes;
  int _request = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final source = ServiceLogoScope.of(context);
    if (!identical(source, _source)) {
      _source = source;
      _start();
    }
  }

  @override
  void didUpdateWidget(ServiceTileLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logoDomain != widget.logoDomain) _start();
  }

  void _start() {
    final source = _source!;
    final request = ++_request;
    _bytes = source.enabled ? source.peek(widget.logoDomain) : null;
    if (!source.enabled) return;
    source.load(widget.logoDomain).then((bytes) {
      if (!mounted || request != _request || identical(bytes, _bytes)) return;
      setState(() => _bytes = bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) return const SizedBox.shrink();
    final plate = context.colors.onTileLight;
    final fade = AppMotion.of(context, AppMotion.fast);
    return Image.memory(
      bytes,
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
