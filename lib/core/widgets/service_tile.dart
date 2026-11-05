import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';

/// Monogram tile of a Service (product.md §7.4, design Components › ServiceTile).
///
/// * Sizes 24 · 32 (widgets) · 40 (rows) · 56 (form/sheet) · 80 (detail hero); other sizes interpolate.
/// * Letter colour is `on-tile-light` or `on-tile-dark`, whichever contrasts more with the tile
///   (≥ 4.5:1 for every palette colour) — see [ServiceTile.onTileColor].
/// * 1px inner `tile-ring` keeps dark tiles edged on dark surfaces.
/// * [awaiting] adds the 12px `warning` dot (top-right); [trial] the hourglass badge
///   (bottom-right); [off] greys the tile out (cancelled); [faded] dims it (queued period).
/// * Never grows with system text size (layout grid stays fixed).
class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.name,
    required this.colorValue,
    this.iconText,
    this.size = 40,
    this.awaiting = false,
    this.trial = false,
    this.off = false,
    this.faded = false,
    this.badgeRingColor,
  });

  final String name;

  /// ARGB tile colour (library colour or a custom `tile-*`).
  final int colorValue;

  /// Monogram (1–2 chars) or emoji; `null` = initials of [name].
  final String? iconText;

  final double size;

  /// Period awaiting confirmation → warning dot.
  final bool awaiting;

  /// Free trial → hourglass badge.
  final bool trial;

  /// Cancelled → greyscale, 55% opacity.
  final bool off;

  /// Queued (not the current pending period) → 55% opacity.
  final bool faded;

  /// Ring around the dot/badge so it separates from what is behind the tile; defaults to `surface`.
  final Color? badgeRingColor;

  static String initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.take(1).toString().toUpperCase();
    return (words[0].characters.first + words[1].characters.first).toUpperCase();
  }

  /// WCAG contrast ratio between two opaque colours.
  static double contrast(Color a, Color b) {
    final la = a.computeLuminance(), lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// `on-tile-light` or `on-tile-dark`, whichever reaches the higher contrast on [tile].
  static Color onTileColor(Color tile, [AppColors tokens = AppColors.light]) {
    final light = tokens.onTileLight, dark = tokens.onTileDark;
    return contrast(tile, light) >= contrast(tile, dark) ? light : dark;
  }

  /// Corner radius for a tile side (tokens `radius-tile-*`, ≈ 0.27 × side).
  static double radiusFor(double size) => switch (size) {
    24 => AppRadius.tile24,
    32 => 9,
    40 => AppRadius.tile40,
    56 => AppRadius.tile56,
    80 => AppRadius.tile80,
    _ => (size * 0.275).roundToDouble(),
  };

  /// Monogram font size: one character ≈ 0.48 × side, two ≈ 0.38 × side (mockup values).
  static double fontSizeFor(double size, int chars) {
    final key = size.round();
    if (chars <= 1) return const {24: 12.0, 32: 15.0, 40: 19.0, 56: 27.0, 80: 38.0}[key] ?? (size * 0.48).roundToDouble();
    if (chars == 2) return const {24: 9.0, 32: 12.0, 40: 15.0, 56: 21.0, 80: 30.0}[key] ?? (size * 0.38).roundToDouble();
    return (size * 0.3).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bg = Color(colorValue).withValues(alpha: 1);
    final fg = onTileColor(bg, c);
    final text = iconText?.trim().isNotEmpty == true ? iconText!.trim() : initials(name);
    final chars = text.characters.length;
    final radius = radiusFor(size);
    final ring = badgeRingColor ?? c.surface;

    Widget tile = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: c.tileRing, width: 1),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.clip,
        textScaler: TextScaler.noScaling,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppType.fontFamily,
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: fontSizeFor(size, chars),
          height: 1,
          letterSpacing: -0.03 * fontSizeFor(size, chars),
        ),
      ),
    );

    if (off) {
      tile = Opacity(opacity: .55, child: ColorFiltered(colorFilter: _greyscale, child: tile));
    } else if (faded) {
      tile = Opacity(opacity: .55, child: tile);
    }

    final badges = <Widget>[
      if (awaiting && !off)
        Positioned(
          top: -3,
          right: -3,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: c.warning,
              shape: BoxShape.circle,
              border: Border.all(color: ring, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
            ),
          ),
        ),
      if (trial && !off)
        Positioned(
          right: -size * 0.15,
          bottom: -size * 0.15,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.warningSoft,
              shape: BoxShape.circle,
              border: Border.all(color: ring, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
            ),
            child: Icon(AppIcons.trial, size: 12, color: c.warningInk),
          ),
        ),
    ];

    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: badges.isEmpty
          ? tile
          : SizedBox(
              width: size,
              height: size,
              child: Stack(clipBehavior: Clip.none, children: [tile, ...badges]),
            ),
    );
  }

  static const _greyscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0,
  ]);
}

/// Dashed/ghost tile for "Add a custom service" rows (S3): `surface-2` fill, `brand` plus.
class GhostTile extends StatelessWidget {
  const GhostTile({super.key, this.size = 40, this.icon = AppIcons.add});

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.surface2,
        borderRadius: BorderRadius.circular(ServiceTile.radiusFor(size)),
        border: Border.all(color: c.lineStrong, width: 1.5),
      ),
      child: Icon(icon, size: size / 2, color: c.brand),
    );
  }
}
