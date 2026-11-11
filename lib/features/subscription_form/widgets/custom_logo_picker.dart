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

/// "Take photo" in the icon sheet (png 038): camera, then the same square crop.
final customLogoCameraProvider = Provider<Future<Uint8List?> Function(BuildContext context)>(
  (ref) =>
      (context) => pickCustomLogo(context, pickBytes: _takePhoto),
);

/// Picks a photo from the gallery and lets the user crop it square; returns PNG bytes
/// ([customLogoSide] px) or `null` when cancelled. Android uses the system Photo Picker
/// (no storage permission); iOS uses PHPicker (no library access prompt).
///
/// [pickBytes] replaces the gallery (camera, tests).
Future<Uint8List?> pickCustomLogo(BuildContext context, {Future<Uint8List?> Function()? pickBytes}) async {
  final Uint8List? source;
  try {
    source = await (pickBytes ?? _pickFromGallery)();
  } catch (_) {
    if (context.mounted) showAppToast(context, context.l10n.subscriptionFormTilePhotoFailed, icon: AppIcons.alert);
    return null;
  }
  if (source == null || !context.mounted) return null;
  return Navigator.of(
    context,
    rootNavigator: true,
  ).push<Uint8List>(MaterialPageRoute(fullscreenDialog: true, builder: (_) => CustomLogoCropScreen(image: source!)));
}

Future<Uint8List?> _pickFromGallery() async {
  final platform = ImagePickerPlatform.instance;
  if (platform is ImagePickerAndroid) platform.useAndroidPhotoPicker = true;
  // Downscaled by the picker: a 12 MP photo is never decoded at full size here.
  final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
  return file?.readAsBytes();
}

/// System camera (Android intent: no CAMERA permission needed; iOS: NSCameraUsageDescription).
Future<Uint8List?> _takePhoto() async {
  final file = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024);
  return file?.readAsBytes();
}

/// Square crop (png 039, dark like a camera): ✕ · "Move and scale" · rotate; the photo covers the
/// square (cannot zoom out past it), pinch to zoom, drag to move; "Cancel" / "Use photo". "Use
/// photo" renders exactly what the square shows to a [customLogoSide] px PNG.
class CustomLogoCropScreen extends StatefulWidget {
  const CustomLogoCropScreen({super.key, required this.image});

  final Uint8List image;

  @override
  State<CustomLogoCropScreen> createState() => _CustomLogoCropScreenState();
}

class _CustomLogoCropScreenState extends State<CustomLogoCropScreen> {
  /// Fixed camera-like colours (design `.crop`), the same in light and dark.
  static const _bg = Color(0xFF0B0D0E);
  static const _fg = Colors.white;

  final _boundary = GlobalKey();
  bool _busy = false;
  bool _broken = false;
  int _turns = 0;

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

  Widget _roundButton({required IconData icon, required String tooltip, required VoidCallback onTap}) => Tooltip(
    message: tooltip,
    child: Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: _fg.withValues(alpha: .12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(dimension: 48, child: Icon(icon, size: 22, color: _fg)),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s2),
              child: Row(
                children: [
                  _roundButton(icon: AppIcons.close, tooltip: l.commonCancel, onTap: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l.subscriptionFormCropTitle,
                        textAlign: TextAlign.center,
                        style: AppType.label.copyWith(color: _fg, fontSize: 16),
                      ),
                    ),
                  ),
                  _roundButton(
                    icon: LucideIcons.rotateCw,
                    tooltip: l.subscriptionFormCropRotate,
                    onTap: () => setState(() => _turns = (_turns + 1) % 4),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) {
                  final side = (box.maxWidth < box.maxHeight ? box.maxWidth : box.maxHeight) - AppSpace.s10 * 2;
                  final radius = BorderRadius.circular(side * .28);
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
                                child: RotatedBox(
                                  quarterTurns: _turns,
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
                          ),
                          // Outside the boundary: the guide is not part of the saved image.
                          IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: _fg, width: 2),
                                borderRadius: radius,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s1, AppSpace.s5, AppSpace.s3),
              child: Text(
                _broken ? l.subscriptionFormTilePhotoFailed : l.subscriptionFormCropHint,
                textAlign: TextAlign.center,
                style: AppType.body.copyWith(color: _fg.withValues(alpha: .85), fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s2, AppSpace.s5, AppSpace.s4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: _fg, minimumSize: const Size(64, 48)),
                    child: Text(l.commonCancel, style: AppType.label.copyWith(color: _fg)),
                  ),
                  AppButton.primary(label: l.subscriptionFormCropUse, loading: _busy, onPressed: _broken ? null : _use),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
