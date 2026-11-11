import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';

// PLACEHOLDERS for Settings › Categories / Labels / Payment methods / Budgets (session U4, product.md §10.5).
// Data: categoriesProvider, labelsProvider, paymentMethodsProvider, budgetsProvider, budgetUsageProvider;
// writes: organizeRepositoryProvider (see notes/2026-11-06-m1-core.md). Keep class names + constructors (router).

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: const Text('')),
  );
}

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) => _Placeholder(context.l10n.manageCategoriesTitle);
}

class ManageLabelsScreen extends StatelessWidget {
  const ManageLabelsScreen({super.key});

  @override
  Widget build(BuildContext context) => _Placeholder(context.l10n.manageLabelsTitle);
}

class ManagePaymentMethodsScreen extends StatelessWidget {
  const ManagePaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) => _Placeholder(context.l10n.managePaymentMethodsTitle);
}

class ManageBudgetsScreen extends StatelessWidget {
  const ManageBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) => _Placeholder(context.l10n.manageBudgetsTitle);
}
