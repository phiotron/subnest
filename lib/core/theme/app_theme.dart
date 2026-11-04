import 'package:flutter/material.dart';

/// TEMPORARY minimal theme. The Design-system session (F) replaces this file with
/// tokens from the Claude Design export (colours, type scale, radius, spacing).
abstract final class AppTheme {
  static const Color _seed = Color(0xFF00796B); // teal placeholder

  /// Semantic colours used by placeholder screens (map to tokens later).
  static const Color warning = Color(0xFFE6A100); // Awaiting confirmation / trial ending
  static const Color success = Color(0xFF2E7D32); // paid / savings

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
  );
}
