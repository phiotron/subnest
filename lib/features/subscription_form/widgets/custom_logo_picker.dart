import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';

/// Side of the saved Custom logo in px (= `CustomLogoStore.side`; crisp on the 80 px tile at 3×).
const customLogoSide = 256;

/// The Custom logo picker the form uses (overridden in tests: no gallery there).
final customLogoPickerProvider = Provider<Future<Uint8List?> Function(BuildContext context)>((ref) => pickCustomLogo);

/// Picks a photo from the gallery and lets the user crop it square; returns PNG bytes
/// ([customLogoSide] px) or `null` when cancelled. Android uses the system Photo Picker
/// (no storage permission); iOS uses PHPicker (no library access prompt).
///
/// [pickBytes] replaces the gallery in tests.
Future<Uint8List?> pickCustomLogo(BuildContext context, {Future<Uint8List?> Function()? pickBytes}) async {
  final Uint8List? source;
  try {
    source = await (pickBytes ?? _pickFromGallery)();
  } catch (_) {
    if (context.mounted) showAppToast(context, context.l10n.subscriptionFormTilePhotoFailed, icon: AppIcons.alert);
    return null;
  }
  if (source == null || !context.mounted) return null;
  return Navigator.of(context, rootNavigator: true).push<Uint8List>(
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => CustomLogoCropScreen(image: source!)),
  );
}

Future<Uint8List?> _pickFromGallery() async {
  final platform = ImagePickerPlatform.instance;
  if (platform is ImagePickerAndroid) platform.useAndroidPhotoPicker = true;
  // Downscaled by the picker: a 12 MP photo is never decoded at full size here.
  final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
  return file?.readAsBytes();
}

/// Square crop: the photo covers the square (cannot zoom out past it); pinch to zoom, drag to
/// move. "Use photo" renders exactly what the square shows to a [customLogoSide] px PNG.
class CustomLogoCropScreen extends StatefulWidget {
  const CustomLogoCropScreen({super.key, required this.image});

  final Uint8List image;

  @override
  State<CustomLogoCropScreen> createState() => _CustomLogoCropScreenState();
}

class _CustomLogoCropScreenState extends State<CustomLogoCropScreen> {
  final _boundary = GlobalKey();
  bool _busy = false;
  bool _broken = false;

  Future<void> _use() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final png = await renderSquare(_boundary);
      if (mounted) Navigator.of(context).pop(png);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAppToast(context, context.l10n.subscriptionFormTilePhotoFailed, icon: AppIcons.alert);
    }
  }

  /// PNG of what [boundary] shows, scaled to [customLogoSide] px.
  @visibleForTesting
  static Future<Uint8List> renderSquare(GlobalKey boundary) async {
    final box = boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await box.toImage(pixelRatio: customLogoSide / box.size.width);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(title: Text(l.subscriptionFormCropTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s4),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    final side = box.maxWidth < box.maxHeight ? box.maxWidth : box.maxHeight;
                    return Center(
                      child: SizedBox.square(
                        dimension: side,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            RepaintBoundary(
                              key: _boundary,
                              child: ClipRect(
                                child: InteractiveViewer(
                                  minScale: 1,
                                  maxScale: 6,
                                  child: Image.memory(
                                    widget.image,
                                    fit: BoxFit.cover,
                                    width: side,
                                    height: side,
                                    filterQuality: FilterQuality.medium,
                                    errorBuilder: (context, error, stack) {
                                      if (!_broken) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) setState(() => _broken = true);
                                        });
                                      }
                                      return ColoredBox(color: c.surface2);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Outside the boundary: guides are not part of the saved image.
                            IgnorePointer(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(color: c.brand, width: 2),
                                  borderRadius: BorderRadius.circular(ServiceTile.radiusFor(side)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpace.s3),
              Text(
                _broken ? l.subscriptionFormTilePhotoFailed : l.subscriptionFormCropHint,
                textAlign: TextAlign.center,
                style: AppType.meta.copyWith(color: _broken ? c.danger : c.inkMuted),
              ),
              const SizedBox(height: AppSpace.s4),
              AppButton.primary(
                label: l.subscriptionFormCropUse,
                expand: true,
                loading: _busy,
                onPressed: _broken ? null : _use,
              ),
              const SizedBox(height: AppSpace.s2),
              AppButton.text(
                label: l.commonCancel,
                expand: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
