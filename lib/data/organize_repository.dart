import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/domain.dart';
import 'db/app_database.dart';
import 'db/mappers.dart';

/// The user's lists for organising subscriptions (Settings › Categories / Labels / Payment methods /
/// Budgets): Category, Label, PaymentMethod, Budget. Rules live in the domain ([CategoryRules]).
class OrganizeRepository {
  OrganizeRepository(this._db, {String Function()? newId, DateTime Function()? clock})
    : _newId = newId ?? const Uuid().v4,
      _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final String Function() _newId;
  final DateTime Function() _clock;

  // ---- Categories ----------------------------------------------------------------------------

  Stream<List<Category>> watchCategories() => (_db.select(_db.categories)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch()
      .map((rows) => [for (final r in rows) r.toDomain()]);

  Future<List<Category>> categories() async =>
      [for (final r in await (_db.select(_db.categories)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get()) r.toDomain()];

  /// Adds a custom category at the end. Returns it.
  Future<Category> addCategory({required String name, required int colorValue, String? icon}) async {
    final c = Category(
      id: _newId(),
      name: name.trim(),
      colorValue: colorValue,
      icon: icon,
      sortOrder: await _nextOrder(_db.categories, _db.categories.sortOrder),
    );
    await _db.into(_db.categories).insert(c.toCompanion());
    return c;
  }

  /// Renames / recolours (name `null` on a built-in = back to the translated name).
  Future<void> saveCategory(Category c) => _db.into(_db.categories).insertOnConflictUpdate(c.toCompanion());

  /// Deletes [id] and moves its subscriptions to [moveTo] (default: "other"). Not allowed for "other".
  Future<void> deleteCategory(String id, {String? moveTo}) => _db.transaction(() async {
    final target = CategoryRules.reassignTarget(id, moveTo);
    await (_db.update(_db.subscriptions)..where((t) => t.categoryId.equals(id)))
        .write(SubscriptionsCompanion(categoryId: Value(target), updatedAt: Value(_clock())));
    await (_db.delete(_db.budgets)..where((t) => t.categoryId.equals(id))).go();
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  });

  /// Saves a new order (ids first → last).
  Future<void> reorderCategories(List<String> ids) => _db.transaction(() async {
    for (final (i, id) in ids.indexed) {
      await (_db.update(_db.categories)..where((t) => t.id.equals(id))).write(CategoriesCompanion(sortOrder: Value(i)));
    }
  });

  // ---- Labels --------------------------------------------------------------------------------

  Stream<List<Label>> watchLabels() => (_db.select(_db.labels)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch()
      .map((rows) => [for (final r in rows) r.toDomain()]);

  Future<Label> addLabel(String name, {int? colorValue}) async {
    final l = Label(
      id: _newId(),
      name: name.trim(),
      colorValue: colorValue,
      sortOrder: await _nextOrder(_db.labels, _db.labels.sortOrder),
    );
    await _db.into(_db.labels).insert(l.toCompanion());
    return l;
  }

  Future<void> saveLabel(Label l) => _db.into(_db.labels).insertOnConflictUpdate(l.toCompanion());

  /// Deletes the label; links to subscriptions go with it (cascade).
  Future<void> deleteLabel(String id) => (_db.delete(_db.labels)..where((t) => t.id.equals(id))).go();

  // ---- Payment methods -----------------------------------------------------------------------

  Stream<List<PaymentMethod>> watchPaymentMethods() => (_db.select(_db.paymentMethods)
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch()
      .map((rows) => [for (final r in rows) r.toDomain()]);

  Future<PaymentMethod> addPaymentMethod(String name) async {
    final p = PaymentMethod(
      id: _newId(),
      name: name.trim(),
      sortOrder: await _nextOrder(_db.paymentMethods, _db.paymentMethods.sortOrder),
    );
    await _db.into(_db.paymentMethods).insert(p.toCompanion());
    return p;
  }

  Future<void> savePaymentMethod(PaymentMethod p) =>
      _db.into(_db.paymentMethods).insertOnConflictUpdate(p.toCompanion());

  /// Deletes the method; subscriptions using it keep no method.
  Future<void> deletePaymentMethod(String id) => _db.transaction(() async {
    await (_db.update(_db.subscriptions)..where((t) => t.paymentMethodId.equals(id)))
        .write(const SubscriptionsCompanion(paymentMethodId: Value(null)));
    await (_db.delete(_db.paymentMethods)..where((t) => t.id.equals(id))).go();
  });

  // ---- Budgets -------------------------------------------------------------------------------

  Stream<List<Budget>> watchBudgets() =>
      _db.select(_db.budgets).watch().map((rows) => [for (final r in rows) r.toDomain()]);

  /// Sets the monthly budget of [categoryId] (`null` = overall). One budget per category.
  Future<void> setBudget({String? categoryId, required int amountMinor, required String currency}) =>
      _db.transaction(() async {
        final existing = await (_db.select(_db.budgets)
              ..where((t) => categoryId == null ? t.categoryId.isNull() : t.categoryId.equals(categoryId)))
            .get();
        final id = existing.firstOrNull?.id ?? _newId();
        await _db.into(_db.budgets).insertOnConflictUpdate(
          Budget(id: id, categoryId: categoryId, amountMinor: amountMinor, currency: currency.toUpperCase()).toCompanion(),
        );
      });

  Future<void> removeBudget({String? categoryId}) => (_db.delete(_db.budgets)
        ..where((t) => categoryId == null ? t.categoryId.isNull() : t.categoryId.equals(categoryId)))
      .go();

  // ---- Helpers -------------------------------------------------------------------------------

  Future<int> _nextOrder(TableInfo table, GeneratedColumn<int> column) async {
    final max = column.max();
    final row = await (_db.selectOnly(table)..addColumns([max])).getSingle();
    return (row.read(max) ?? -1) + 1;
  }
}
