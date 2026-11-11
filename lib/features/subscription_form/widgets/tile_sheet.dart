import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'custom_logo_picker.dart';

/// What the icon sheet returns: colour + letters/emoji (`null` = initials of the name), and the
/// Custom logo change: [photo] = new PNG picked, [removePhoto] = the saved one is to be removed.
class TileChoice {
  const TileChoice(this.colorValue, this.iconText, {this.photo, this.removePhoto = false});
  final int colorValue;
  final String? iconText;
  final Uint8List? photo;
  final bool removePhoto;
}

/// Whether [text] is a 1–2 character monogram (letters/digits) rather than an emoji.
bool isMonogram(String? text) => text == null || RegExp(r'^[\p{L}\p{N}+]{0,2}$', unicode: true).hasMatch(text);

/// S4 "Change icon" sheet (png 038, 040): 80px preview + what it is ("Letter on colour" / "Your
/// photo, cropped square"); with [canUsePhoto] (no bundled logo for this service) Choose photo +
/// Take photo, or Choose photo + Remove photo once a photo is set (Custom logo); colour swatches
/// (library colour first, then the 12 `tile-*` tokens); one "Letter or emoji" field; Done.
Future<TileChoice?> showTileSheet(
  BuildContext context, {
  required String name,
  required int colorValue,
  required String? iconText,
  int? libraryColor,
  bool canUsePhoto = false,
  ImageProvider? photo,
  Future<Uint8List?> Function(BuildContext context)? pickPhoto,
  Future<Uint8List?> Function(BuildContext context)? takePhoto,
}) {
  return showAppSheet<TileChoice>(
    context,
    builder: (_) => TileSheet(
      name: name,
      colorValue: colorValue,
      iconText: iconText,
      libraryColor: libraryColor,
      canUsePhoto: canUsePhoto,
      photo: photo,
      pickPhoto: pickPhoto,
      takePhoto: takePhoto,
    ),
  );
}

class TileSheet extends StatefulWidget {
  const TileSheet({
    super.key,
    required this.name,
    required this.colorValue,
    required this.iconText,
    this.libraryColor,
    this.canUsePhoto = false,
    this.photo,
    this.pickPhoto,
    this.takePhoto,
  });

  final String name;
  final int colorValue;
  final String? iconText;
  final int? libraryColor;
  final bool canUsePhoto;
  final ImageProvider? photo;

  /// Gallery + crop ([pickCustomLogo]) unless replaced (tests).
  final Future<Uint8List?> Function(BuildContext context)? pickPhoto;

  /// Camera + crop; `null` hides "Take photo".
  final Future<Uint8List?> Function(BuildContext context)? takePhoto;

  @override
  State<TileSheet> createState() => _TileSheetState();
}

class _TileSheetState extends State<TileSheet> {
  late int _color = widget.colorValue;
  late final _letters = TextEditingController(text: widget.iconText ?? '');
  late ImageProvider? _photo = widget.canUsePhoto ? widget.photo : null;
  Uint8List? _newPhoto;
  bool _removed = false;

  Future<void> _getPhoto(Future<Uint8List?> Function(BuildContext context) source) async {
    final png = await source(context);
    if (png == null || !mounted) return;
    setState(() {
      _newPhoto = png;
      _photo = MemoryImage(png);
      _removed = false;
    });
  }

  void _removePhoto() => setState(() {
    _newPhoto = null;
    _photo = null;
    _removed = widget.photo != null;
  });

  @override
  void dispose() {
    _letters.dispose();
    super.dispose();
  }

  String? get _iconText {
    final t = _letters.text.trim();
    return t.isEmpty ? null : t;
  }

  List<int> get _swatches {
    final palette = [for (final c in AppColors.tilePalette) c.toARGB32()];
    final first = widget.libraryColor ?? (palette.contains(widget.colorValue) ? null : widget.colorValue);
    return [?first, ...palette.where((c) => c != first)];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final name = widget.name.trim();
    final shown = _iconText ?? (name.isEmpty ? '?' : null);
    final hasPhoto = _photo != null;
    final take = widget.takePhoto;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(l.subscriptionFormTileTitle, style: AppType.title.copyWith(color: c.ink)),
                ),
                const SizedBox(height: AppSpace.s2),
                Center(
                  child: ServiceTile(name: name, colorValue: _color, iconText: shown, size: 80, logo: _photo),
                ),
                const SizedBox(height: AppSpace.s2),
                Text(
                  hasPhoto ? l.subscriptionFormTilePhotoPreview : l.subscriptionFormTileLetterPreview,
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
                if (widget.canUsePhoto) ...[
                  const SizedBox(height: AppSpace.s3),
                  Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: AppSpace.s2,
                    alignment: WrapAlignment.center,
                    children: [
                      AppButton(
                        label: l.subscriptionFormTilePhotoPick,
                        kind: hasPhoto ? AppButtonKind.outline : AppButtonKind.tonal,
                        icon: LucideIcons.imagePlus,
                        onPressed: () => _getPhoto(widget.pickPhoto ?? pickCustomLogo),
                      ),
                      if (hasPhoto)
                        AppButton(
                          label: l.subscriptionFormTilePhotoRemove,
                          kind: AppButtonKind.dangerText,
                          icon: AppIcons.delete,
                          onPressed: _removePhoto,
                        )
                      else if (take != null)
                        AppButton.outline(
                          label: l.subscriptionFormTileTakePhoto,
                          icon: LucideIcons.camera,
                          onPressed: () => _getPhoto(take),
                        ),
                    ],
                  ),
                ],
                SectionHeader(
                  label: l.subscriptionFormTileColour,
                  padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
                ),
                Wrap(
                  spacing: AppSpace.s2,
                  runSpacing: AppSpace.s2,
                  children: [
                    for (final (i, color) in _swatches.indexed)
                      _Swatch(
                        color: Color(color),
                        selected: !hasPhoto && color == _color,
                        label: i == 0 && widget.libraryColor != null
                            ? l.subscriptionFormTileLibraryColour
                            : l.subscriptionFormTileSwatch(i + 1),
                        onTap: () => setState(() => _color = color),
                      ),
                  ],
                ),
                SectionHeader(
                  label: l.subscriptionFormTileLetterOrEmoji,
                  padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s2),
                ),
                TextField(
                  controller: _letters,
                  maxLength: 2,
                  textCapitalization: TextCapitalization.characters,
                  style: AppType.titleSm.copyWith(color: c.ink),
                  decoration: InputDecoration(
                    counterText: '',
                    semanticCounterText: '',
                    hintText: ServiceTile.initials(name.isEmpty ? '?' : name),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        AppButton.primary(
          label: l.commonDone,
          expand: true,
          onPressed: () => Navigator.pop(
            context,
            TileChoice(_color, _iconText, photo: _newPhoto, removePhoto: _removed && _newPhoto == null),
          ),
        ),
      ],
    );
  }
}

/// Colour swatch (design `.swatch`): squircle in the colour, 2px `focus` ring + ✓ when selected.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.selected, required this.label, required this.onTap});

  final Color color;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          padding: EdgeInsets.all(selected ? 4 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ServiceTile.radiusFor(48) + 2),
            border: selected ? Border.all(color: c.brand, width: 2) : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(ServiceTile.radiusFor(40)),
              border: Border.all(color: c.tileRing),
            ),
            child: selected ? Icon(AppIcons.check, size: 16, color: ServiceTile.onTileColor(color, c)) : null,
          ),
        ),
      ),
    );
  }
}
