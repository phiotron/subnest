import 'package:flutter/material.dart';

/// A go_router page shown as a modal bottom sheet (S6 confirm sheet), so the sheet
/// is deep-linkable from a notification and closes with `context.pop()`.
class BottomSheetPage<T> extends Page<T> {
  const BottomSheetPage({required this.child, super.key, super.name, super.arguments});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    settings: this,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => child,
  );
}
