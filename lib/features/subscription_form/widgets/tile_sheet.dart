import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'custom_logo_picker.dart';

/// What the tile sheet returns: colour + letters/emoji (`null` = initials of the name), and the
/// Custom logo change: [photo] = new PNG picked, [removePhoto] = the saved one is to be removed.
class TileChoice {
  const TileChoice(this.colorValue, this.iconText, {this.photo, this.removePhoto = false});
  final int colorValue;
  final String? iconText;
  final Uint8List? photo;
  final bool removePhoto;
}

/// Emoji offered instead of letters (mockup order).
const tileEmoji = ['🎬', '🎵', '🎮', '📚', '☁️', '💪', '📱', '🤖'];

/// Whether [text] is a 1–2 character monogram (letters/digits) rather than an emoji.
bool isMonogram(String? text) => text == null || RegExp(r'^[\p{L}\p{N}+]{0,2}$', unicode: true).hasMatch(text);

/// S4 tile sheet (png 24): big preview + list-row preview, Letters | Emoji, letters field (1–2),
/// colour swatches (library colour first, then the 12 `tile-*` tokens), emoji row, Done.
/// With [canUsePhoto] (no bundled logo for this service) a Photo section offers Choose / Change /
/// Remove photo (Custom logo); [photo] is the current one shown in the previews.
Future<TileChoice?> showTileSheet(
  BuildContext context, {
  required String name,
  required int colorValue,
  required String? iconText,
  required String previewMeta,
  int? libraryColor,
  String? libraryName,
  bool canUsePhoto = false,
  ImageProvider? photo,
  Future<Uint8List?> Function(BuildContext context)? pickPhoto,
}) {
  return showAppSheet<TileChoice>(
    context,
    builder: (_) => TileSheet(
      name: name,
      colorValue: colorValue,
      iconText: iconText,
      previewMeta: previewMeta,
      libraryColor: libraryColor,
      libraryName: libraryName,
      canUsePhoto: canUsePhoto,
      photo: photo,
      pickPhoto: pickPhoto,
    ),
  );
}

class TileSheet extends StatefulWidget {
  const TileSheet({
    super.key,
    required this.name,
    required this.colorValue,
    required this.iconText,
    required this.previewMeta,
    this.libraryColor,
    this.libraryName,
    this.canUsePhoto = false,
    this.photo,
    this.pickPhoto,
  });

  final String name;
  final int colorValue;
  final String? iconText;
  final String previewMeta;
  final int? libraryColor;
  final String? libraryName;
  final bool canUsePhoto;
  final ImageProvider? photo;

  /// Gallery + crop ([pickCustomLogo]) unless replaced (tests).
  final Future<Uint8List?> Function(BuildContext context)? pickPhoto;

  @override
  State<TileSheet> createState() => _TileSheetState();
}

class _TileSheetState extends State<TileSheet> {
  late int _color = widget.colorValue;
  late bool _emojiMode = !isMonogram(widget.iconText);
  late final _letters = TextEditingController(text: _emojiMode ? '' : (widget.iconText ?? ''));
  late String? _emoji = _emojiMode ? widget.iconText : null;
  late ImageProvider? _photo = widget.canUsePhoto ? widget.photo : null;
  Uint8List? _newPhoto;
  bool _removed = false;

  Future<void> _pickPhoto() async {
    final png = await (widget.pickPhoto ?? pickCustomLogo)(context);
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
    if (_emojiMode) return _emoji;
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
                const SizedBox(height: AppSpace.s4),
                Row(
                  children: [
                    ServiceTile(name: name, colorValue: _color, iconText: shown, size: 80, logo: _photo),
                    const SizedBox(width: AppSpace.s4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l.subscriptionFormTilePreview, style: AppType.meta.copyWith(color: c.inkMuted)),
                          const SizedBox(height: AppSpace.s2),
                          Container(
                            padding: const EdgeInsets.all(AppSpace.s3),
                            decoration: BoxDecoration(
                              color: c.surface2,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Row(
                              children: [
                                ServiceTile(name: name, colorValue: _color, iconText: shown, logo: _photo),
                                const SizedBox(width: AppSpace.s3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name.isEmpty ? l.subscriptionFormNameHint : name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppType.titleSm.copyWith(color: c.ink),
                                      ),
                                      Text(
                                        widget.previewMeta,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppType.meta.copyWith(color: c.inkMuted).tabular,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.canUsePhoto) ...[
                  SectionHeader(
                    label: l.subscriptionFormTilePhoto,
                    padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
                  ),
                  Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: AppSpace.s2,
                    children: [
                      AppButton.tonal(
                        label: _photo == null ? l.subscriptionFormTilePhotoPick : l.subscriptionFormTilePhotoChange,
                        icon: LucideIcons.image,
                        small: true,
                        onPressed: _pickPhoto,
                      ),
                      if (_photo != null)
                        AppButton.text(
                          label: l.subscriptionFormTilePhotoRemove,
                          icon: AppIcons.delete,
                          small: true,
                          onPressed: _removePhoto,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.s2),
                  Text(l.subscriptionFormTilePhotoNote, style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
                const SizedBox(height: AppSpace.s4),
                AppSegmentedControl<bool>(
                  segments: [
                    AppSegment(value: false, label: l.subscriptionFormTileLetters),
                    AppSegment(value: true, label: l.subscriptionFormTileEmoji),
                  ],
                  selected: _emojiMode,
                  onChanged: (v) => setState(() => _emojiMode = v),
                ),
                const SizedBox(height: AppSpace.s3),
                if (!_emojiMode)
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpace.s3,
                    runSpacing: AppSpace.s2,
                    children: [
                      Text(l.subscriptionFormTileLetters, style: AppType.label.copyWith(color: c.ink)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 72,
                            child: TextField(
                              controller: _letters,
                              maxLength: 2,
                              textAlign: TextAlign.center,
                              textCapitalization: TextCapitalization.characters,
                              style: AppType.titleSm.copyWith(color: c.ink),
                              decoration: InputDecoration(
                                counterText: '',
                                semanticCounterText: '',
                                hintText: ServiceTile.initials(name.isEmpty ? '?' : name),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSpace.s3),
                          Text(l.subscriptionFormTileLettersHint, style: AppType.meta.copyWith(color: c.inkMuted)),
                        ],
                      ),
                    ],
                  ),
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
                        selected: color == _color,
                        label: i == 0 && widget.libraryColor != null
                            ? l.subscriptionFormTileLibraryColour
                            : l.subscriptionFormTileSwatch(i + 1),
                        onTap: () => setState(() => _color = color),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpace.s3),
                Text(
                  widget.libraryColor != null && widget.libraryName != null
                      ? l.subscriptionFormTileColourNote(widget.libraryName!)
                      : l.subscriptionFormTileColourNoteCustom,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
                SectionHeader(
                  label: l.subscriptionFormTileOrEmoji,
                  padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
                ),
                Wrap(
                  spacing: AppSpace.s2,
                  runSpacing: AppSpace.s2,
                  children: [
                    for (final e in tileEmoji)
                      _EmojiButton(
                        emoji: e,
                        selected: _emojiMode && _emoji == e,
                        onTap: () => setState(() {
                          _emojiMode = true;
                          _emoji = e;
                        }),
                      ),
                  ],
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
          padding: EdgeInsets.all(selected ? 3 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            border: selected ? Border.all(color: c.brand, width: 2) : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: c.tileRing),
            ),
            child: selected ? Icon(AppIcons.check, size: 18, color: ServiceTile.onTileColor(color, c)) : null,
          ),
        ),
      ),
    );
  }
}

class _EmojiButton extends StatelessWidget {
  const _EmojiButton({required this.emoji, required this.selected, required this.onTap});

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      label: emoji,
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected ? c.brandSoft : c.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected ? BorderSide(color: c.brand, width: 2) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Text(emoji, style: AppType.title, textScaler: TextScaler.noScaling),
            ),
          ),
        ),
      ),
    );
  }
}
