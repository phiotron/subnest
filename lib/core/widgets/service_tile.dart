import 'package:flutter/material.dart';

/// Monogram tile of a Service (product.md §7.4) — PLACEHOLDER look; the Design-system
/// session restyles it (sizes 24/40/56/80, radius, typography). Keep the constructor.
class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.name, required this.colorValue, this.iconText, this.size = 40});

  final String name;
  final int colorValue;

  /// Monogram or emoji; `null` = initials of [name].
  final String? iconText;
  final double size;

  static String initials(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.take(1).toString().toUpperCase();
    return (words[0].characters.first + words[1].characters.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Color(colorValue);
    final fg = ThemeData.estimateBrightnessForColor(bg) == Brightness.dark ? Colors.white : Colors.black87;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(size * 0.25)),
      child: Text(
        iconText ?? initials(name),
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: size * 0.4),
      ),
    );
  }
}
