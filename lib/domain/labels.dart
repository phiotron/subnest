/// A user tag; a Subscription can carry many (glossary: Label). Not to be confused with Category.
class Label {
  const Label({required this.id, required this.name, required this.sortOrder, this.colorValue});

  final String id;
  final String name;

  /// Optional chip colour (ARGB); `null` = neutral chip.
  final int? colorValue;
  final int sortOrder;

  Label copyWith({String? name, Object? colorValue = _keep, int? sortOrder}) => Label(
    id: id,
    name: name ?? this.name,
    colorValue: identical(colorValue, _keep) ? this.colorValue : colorValue as int?,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  @override
  bool operator ==(Object other) =>
      other is Label && other.id == id && other.name == name && other.colorValue == colorValue && other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(id, name, colorValue, sortOrder);

  @override
  String toString() => 'Label($name)';
}

/// A card / wallet / account the user pays with (glossary: Payment method). At most one per Subscription.
class PaymentMethod {
  const PaymentMethod({required this.id, required this.name, required this.sortOrder});

  final String id;

  /// "Visa ••4821", "MoMo"…
  final String name;
  final int sortOrder;

  PaymentMethod copyWith({String? name, int? sortOrder}) =>
      PaymentMethod(id: id, name: name ?? this.name, sortOrder: sortOrder ?? this.sortOrder);

  /// Key used to merge duplicates ("visa  ••4821" == "Visa ••4821").
  static String normalizeName(String name) => name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  @override
  bool operator ==(Object other) => other is PaymentMethod && other.id == id && other.name == name && other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(id, name, sortOrder);

  @override
  String toString() => 'PaymentMethod($name)';
}

/// Monthly spending cap for one Category, or the overall cap when [categoryId] is `null` (glossary: Budget).
/// [amountMinor] is in the Primary currency (minor units) at the time it was set.
class Budget {
  const Budget({required this.id, required this.amountMinor, required this.currency, this.categoryId});

  final String id;
  final String? categoryId;
  final int amountMinor;
  final String currency;

  bool get isTotal => categoryId == null;

  @override
  bool operator ==(Object other) =>
      other is Budget && other.id == id && other.categoryId == categoryId && other.amountMinor == amountMinor && other.currency == currency;

  @override
  int get hashCode => Object.hash(id, categoryId, amountMinor, currency);
}

const Object _keep = Object();
