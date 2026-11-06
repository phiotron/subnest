import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';

/// PLACEHOLDER — S13 Scan (session S): open store subscription page → pick screenshots → on-device OCR →
/// `SubscriptionRepository.applyDetections` → result list with Undo per line (product.md §10.6).
/// Keep the class name + constructor (router).
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.scanTitle)),
    body: Center(child: Text(context.l10n.scanPlaceholder)),
  );
}
