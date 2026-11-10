import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

/// A small v4 Catalog. Prices: Netflix Standard US 17.99 / VN 220000, Premium US 24.99; Spotify one plan
/// US 11.99; Old Box `basic` with [boxStatus] (and `renamedFrom` when [boxRenamedFrom] is set).
Map<String, Object?> catalogMap({
  int version = 12,
  int schemaVersion = 4,
  double standardUs = 17.99,
  double premiumUs = 24.99,
  int standardVn = 220000,
  String boxStatus = 'active',
  String? boxRenamedFrom,
  String boxName = 'Basic',
  bool withSpotify = true,
  String? netflixCancelUrl = 'https://www.netflix.com/cancelplan',
  List<Map<String, Object?>> extraServices = const [],
}) {
  Map<String, Object?> price(String cur, num amount) => {
    'currency': cur,
    'amount': amount,
    'verifiedAt': '2026-11-06',
    'source': 'https://example.com',
    'method': 'manual',
  };
  Map<String, Object?> plan(String id, String name, Map<String, Object?> prices, {String status = 'active', String? renamedFrom}) => {
    'id': id,
    'name': name,
    'status': status,
    'renamedFrom': ?renamedFrom,
    'cycle': {'unit': 'month', 'count': 1},
    'prices': prices,
  };
  Map<String, Object?> service(String id, String name, List<Map<String, Object?>> plans, {String? cancelUrl}) => {
    'id': id,
    'name': name,
    'category': 'video',
    'color': '#E50914',
    'monogram': name[0],
    'market': 'global',
    'aliases': [id],
    'cancelUrl': cancelUrl,
    'plans': plans,
  };
  return {
    'schemaVersion': schemaVersion,
    'version': version,
    'updatedAt': '2026-11-0${version % 9 + 1}',
    'staleAfterDays': 90,
    'regions': {'US': 'USD', 'VN': 'VND'},
    'services': [
      service('netflix', 'Netflix', [
        plan('standard', 'Standard', {'US': price('USD', standardUs), 'VN': price('VND', standardVn)}),
        plan('premium', 'Premium', {'US': price('USD', premiumUs)}),
      ], cancelUrl: netflixCancelUrl),
      if (withSpotify) service('spotify', 'Spotify', [plan('individual', 'Individual', {'US': price('USD', 11.99)})]),
      service('old-box', 'Old Box', [
        plan('basic', boxName, {'US': price('USD', 5)}, status: boxStatus, renamedFrom: boxRenamedFrom),
        plan('plus', 'Plus', {'US': price('USD', 9)}),
      ]),
      ...extraServices,
    ],
  };
}

String catalogJson({int version = 12, double standardUs = 17.99, double premiumUs = 24.99}) =>
    jsonEncode(catalogMap(version: version, standardUs: standardUs, premiumUs: premiumUs));

String sha(List<int> bytes) => sha256.convert(bytes).toString();

String metaJson(String catalogText, {int? version, int schemaVersion = 4, String? overrideSha}) {
  final bytes = utf8.encode(catalogText);
  return jsonEncode({
    'schemaVersion': schemaVersion,
    'version': version ?? (jsonDecode(catalogText) as Map)['version'],
    'files': {
      'services.min.json': {'sha256': overrideSha ?? sha(bytes), 'bytes': bytes.length},
    },
  });
}

/// Smallest valid-looking PNG header + payload.
Uint8List png(int seed) => Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, seed, 1, 2, 3, 4]);

/// Serves one asset text as `assets/catalog/services.json`.
class StringBundle extends CachingAssetBundle {
  StringBundle(this.text);
  final String? text;

  @override
  Future<ByteData> load(String key) async {
    if (text == null) throw StateError('no asset $key');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(text!)));
  }
}
