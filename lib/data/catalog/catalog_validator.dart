import '../../domain/domain.dart';
import '../catalog_repository.dart';
import 'catalog_data.dart';

/// Gate for a remote Catalog file before the app uses it (the app-side twin of the catalog repo's
/// `tools/validate.py`). Any failure → [CatalogFormatException]; the caller keeps the Catalog it has.
///
/// Rules: schema [supportedSchemas]; `version` ≥ 1; `updatedAt` a date; at least one service; every
/// service parses (strict) with a slug id, ≥ 1 plan and unique plan ids; ids unique; `cancelUrl` /
/// `manageUrl` https or null; prices finite and > 0 in a 3-letter currency. With [previous], no service
/// or plan id of it may be missing (Catalog links point at ids — the repo promises never to delete them).
abstract final class CatalogValidator {
  /// Schemas this build reads. A breaking schema is published under a new path (`subnest/v2/`).
  static const supportedSchemas = {4};

  /// Same slug as the catalog repo (`^[a-z0-9]+(-[a-z0-9]+)*$`).
  static final slug = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
  static final _currency = RegExp(r'^[A-Z]{3}$');

  static CatalogData validate(String text, {CatalogData? previous, LocalDate? today}) {
    final CatalogData data;
    try {
      data = CatalogRepository.parseData(text, today: today, origin: CatalogOrigin.remote, strict: true);
    } on CatalogFormatException {
      rethrow;
    } catch (e) {
      throw CatalogFormatException('not a catalog: $e');
    }
    if (!supportedSchemas.contains(data.schemaVersion)) {
      throw CatalogFormatException('schemaVersion ${data.schemaVersion} not supported');
    }
    if (data.version < 1) throw const CatalogFormatException('version missing');
    if (data.updatedOn == null) throw const CatalogFormatException('updatedAt missing');
    if (data.services.isEmpty) throw const CatalogFormatException('no services');

    final ids = <String>{};
    for (final s in data.services) {
      if (!slug.hasMatch(s.id)) throw CatalogFormatException('bad service id "${s.id}"');
      if (!ids.add(s.id)) throw CatalogFormatException('duplicate service id "${s.id}"');
      if (s.name.trim().isEmpty) throw CatalogFormatException('${s.id}: empty name');
      for (final u in [s.cancelUrl, s.manageUrl]) {
        if (u != null && !isHttps(u)) throw CatalogFormatException('${s.id}: url must be https');
      }
      if (s.plans.isEmpty) throw CatalogFormatException('${s.id}: no plans');
      final planIds = <String>{};
      for (final p in s.plans) {
        if (!slug.hasMatch(p.id)) throw CatalogFormatException('${s.id}: bad plan id "${p.id}"');
        if (!planIds.add(p.id)) throw CatalogFormatException('${s.id}: duplicate plan id "${p.id}"');
        for (final e in p.prices.entries) {
          final price = e.value;
          if (!_currency.hasMatch(price.currency) || !price.amount.isFinite || price.amount <= 0) {
            throw CatalogFormatException('${s.id}/${p.id}/${e.key}: bad price');
          }
        }
      }
    }

    if (previous != null) {
      for (final old in previous.services) {
        final now = data.byId(old.id);
        if (now == null) throw CatalogFormatException('service "${old.id}" removed');
        for (final p in old.plans) {
          if (!now.plans.any((n) => n.id == p.id)) throw CatalogFormatException('plan "${old.id}/${p.id}" removed');
        }
      }
    }
    return data;
  }

  static bool isHttps(String url) {
    final u = Uri.tryParse(url);
    return u != null && u.scheme == 'https' && u.host.isNotEmpty && !url.contains(' ');
  }
}
