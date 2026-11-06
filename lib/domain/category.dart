/// Built-in Category keys (product.md §5 S3). Catalog services and old data use these keys.
/// A seeded [Category] has `id == key` and `builtInKey == key`.
enum SubscriptionCategory {
  video('video'),
  music('music'),
  ai('ai'),
  storage('storage'),
  software('software'),
  gaming('gaming'),
  reading('reading'),
  health('health'),
  education('education'),
  telecom('telecom'),
  other('other');

  const SubscriptionCategory(this.key);

  final String key;

  /// Unknown keys (e.g. from an older catalog or backup, or a custom category id) map to [other].
  static SubscriptionCategory fromKey(String? key) =>
      values.firstWhere((c) => c.key == key, orElse: () => SubscriptionCategory.other);

  static SubscriptionCategory? tryKey(String? key) => values.where((c) => c.key == key).firstOrNull;
}

/// The user's Category (glossary: Category). Built-ins are seeded and editable; custom ones are added
/// in Settings › Categories. Every Subscription has exactly one.
class Category {
  const Category({
    required this.id,
    required this.colorValue,
    required this.sortOrder,
    this.name,
    this.icon,
    this.builtInKey,
  });

  final String id;

  /// User-chosen name; `null` = show the translated name of [builtInKey].
  final String? name;
  final int colorValue;

  /// Icon name (Lucide name the UI maps); `null` = default icon of the built-in / generic.
  final String? icon;
  final int sortOrder;

  /// Key of the built-in category this row was seeded from (`video`…); `null` for custom ones.
  final String? builtInKey;

  bool get isBuiltIn => builtInKey != null;

  SubscriptionCategory? get builtIn => SubscriptionCategory.tryKey(builtInKey);

  Category copyWith({Object? name = _keep, int? colorValue, Object? icon = _keep, int? sortOrder}) => Category(
    id: id,
    name: identical(name, _keep) ? this.name : name as String?,
    colorValue: colorValue ?? this.colorValue,
    icon: identical(icon, _keep) ? this.icon : icon as String?,
    sortOrder: sortOrder ?? this.sortOrder,
    builtInKey: builtInKey,
  );

  @override
  bool operator ==(Object other) =>
      other is Category &&
      other.id == id &&
      other.name == name &&
      other.colorValue == colorValue &&
      other.icon == icon &&
      other.sortOrder == sortOrder &&
      other.builtInKey == builtInKey;

  @override
  int get hashCode => Object.hash(id, name, colorValue, icon, sortOrder, builtInKey);

  @override
  String toString() => 'Category($id, ${name ?? builtInKey})';
}

const Object _keep = Object();

/// Seed + rules for Categories.
abstract final class CategoryRules {
  /// Fallback colours of the seeded categories (UI may still theme them via chart colours).
  static const Map<SubscriptionCategory, int> _seedColors = {
    SubscriptionCategory.video: 0xFFE5484D,
    SubscriptionCategory.music: 0xFF30A46C,
    SubscriptionCategory.ai: 0xFF8E4EC6,
    SubscriptionCategory.storage: 0xFF0090FF,
    SubscriptionCategory.software: 0xFF3E63DD,
    SubscriptionCategory.gaming: 0xFFF76B15,
    SubscriptionCategory.reading: 0xFFAD7F58,
    SubscriptionCategory.health: 0xFFE93D82,
    SubscriptionCategory.education: 0xFF12A594,
    SubscriptionCategory.telecom: 0xFF0D74CE,
    SubscriptionCategory.other: 0xFF8B8D98,
  };

  /// The 11 built-in categories seeded on install / migration (id = key).
  static List<Category> seed() => [
    for (final (i, c) in SubscriptionCategory.values.indexed)
      Category(id: c.key, builtInKey: c.key, colorValue: _seedColors[c]!, sortOrder: i),
  ];

  /// Id used when a category is missing (deleted, unknown in a backup). Never deletable.
  static const String fallbackId = 'other';

  static bool canDelete(Category c) => c.id != fallbackId;

  /// Deleting [deletedId] moves its subscriptions to [targetId] (the user picks it). Returns the target.
  /// Throws when deleting the fallback or moving into the category being deleted.
  static String reassignTarget(String deletedId, String? targetId) {
    if (deletedId == fallbackId) throw StateError('The "other" category cannot be deleted');
    final t = targetId ?? fallbackId;
    if (t == deletedId) throw ArgumentError('Target must differ from the deleted category');
    return t;
  }

  /// Resolves [id] against [known] ids, falling back to [fallbackId].
  static String resolve(String id, Set<String> known) => known.contains(id) ? id : fallbackId;
}
