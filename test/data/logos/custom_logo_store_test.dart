import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_logos.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/logos/custom_logo_store.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';

import '../backup/backup_test_utils.dart';

/// A valid 8×8 PNG (and a second, different one).
final Uint8List png1 = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAEUlEQVR4nGMQVHqHFTEMLQkABCxIQSPERjoAAAAASUVORK5CYII=',
);
final Uint8List png2 = Uint8List.fromList([...png1, 0]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tmp;
  late CustomLogoStore store;
  var t = 1000;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('custom_logos');
    store = CustomLogoStore(
      () async => Directory('${tmp.path}/custom_logos'),
      clock: () => DateTime.fromMillisecondsSinceEpoch(t),
    );
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  File fileOf(String name) => File('${tmp.path}/custom_logos/$name');

  group('CustomLogoStore', () {
    test('save gives a new name each time; fileOf / delete', () async {
      expect(store.fileOf('a.png'), isNull, reason: 'folder not resolved yet');
      final a = await store.save('sub-1', png1);
      expect(a, 'sub-1-1000.png');
      final b = await store.save('sub-1', png2); // same millisecond → next free name
      expect(b, 'sub-1-1001.png');
      expect(store.fileOf(a)!.readAsBytesSync(), png1);
      expect(store.fileOf(b)!.readAsBytesSync(), png2);
      await store.delete(a);
      expect(fileOf(a).existsSync(), isFalse);
      await store.delete(null);
      await store.delete('../escape.png');
      expect(await store.names(), {b});
    });

    test('load drops half-written files and notifies (tiles redraw)', () async {
      Directory('${tmp.path}/custom_logos').createSync();
      fileOf('x-1.png').writeAsBytesSync(png1);
      File('${tmp.path}/custom_logos/y-2.png.part').writeAsBytesSync([1]);
      var notified = 0;
      store.addListener(() => notified++);
      await store.load();
      expect(notified, 1);
      expect(await store.names(), {'x-1.png'});
    });

    test('refuses non-images and odd names', () async {
      expect(() => store.save('a', Uint8List.fromList(utf8.encode('<svg>hello world</svg>'))), throwsArgumentError);
      expect(() => store.save('a', Uint8List(CustomLogoStore.maxBytes + 1)), throwsArgumentError);
      expect(await store.save('../../evil', png1), 'evil-1000.png', reason: 'id cleaned, stays in the folder');
      expect(CustomLogoStore.validName('a/b.png'), isFalse);
      expect(CustomLogoStore.validName('..png'), isFalse);
      expect(CustomLogoStore.looksLikeImage(Uint8List.fromList([0xFF, 0xD8, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])), isTrue);
    });

    test('keepOnly removes pictures nobody points at; clear removes all', () async {
      final a = await store.save('a', png1);
      t++;
      final b = await store.save('b', png1);
      t++;
      final c = await store.save('c', png1);
      await store.keepOnly({a, c, 'zzz.png'});
      expect(await store.names(), {a, c});
      expect(fileOf(b).existsSync(), isFalse);
      await store.clear();
      expect(await store.names(), isEmpty);
    });

    test('readAll / replaceAll round trip; invalid entries skipped', () async {
      final a = await store.save('a', png1);
      t++;
      final b = await store.save('b', png2);
      expect((await store.readAll({a, b, 'missing.png'})).keys, [a, b]);
      final n = await store.replaceAll({'c-1.png': png1, '../x.png': png1, 'd-1.png': Uint8List.fromList([1, 2, 3])});
      expect(n, 1);
      expect(await store.names(), {'c-1.png'});
    });
  });

  group('Backup with Custom logos', () {
    final now = DateTime(2026, 11, 10, 9);
    late BackupWorld world;
    late BackupService backup;

    setUp(() {
      world = BackupWorld(clock: () => now);
      backup = BackupService(
        world.db,
        world.subs,
        world.settings,
        ExchangeRateRepository(world.db, world.settings, clock: () => now),
        clock: () => now,
        logos: store,
      );
    });
    tearDown(() => world.close());

    Future<String> withLogo(String id, Uint8List bytes) async {
      final name = await store.save(id, bytes);
      t++;
      final s = (await world.subs.get(id))!;
      await world.subs.save(s.copyWith(customLogoFile: name));
      return name;
    }

    test('no logos → no customLogos key', () async {
      await world.addSub('s1');
      final json = jsonDecode(await backup.exportJsonText()) as Map<String, Object?>;
      expect(json.containsKey(BackupLogos.key), isFalse);
    });

    test('logo survives backup → delete all → restore; pictures nobody uses are not exported', () async {
      await world.addSub('s1', name: 'My gym');
      await world.addSub('s2', name: 'Other');
      final name = await withLogo('s1', png1);
      await store.save('deleted-sub', png2); // orphan
      final text = await backup.exportJsonText();
      final json = jsonDecode(text) as Map<String, Object?>;
      expect((json[BackupLogos.key]! as Map).keys, [name]);
      expect(((json['subscriptions']! as List).first as Map)['customLogoFile'], name);

      // "Delete all data", then restore the file.
      await world.db.wipeEverything();
      await store.clear();

      final result = await backup.importJson(text);
      expect(result.subscriptions, 2);
      expect((await world.subs.get('s1'))!.customLogoFile, name);
      expect((await world.subs.get('s2'))!.customLogoFile, isNull);
      expect(await store.names(), {name});
      expect(fileOf(name).readAsBytesSync(), png1);
    });

    test('restoring a file without logos removes the current pictures (restore replaces everything)', () async {
      await world.addSub('s1');
      final text = await backup.exportJsonText();
      await withLogo('s1', png1);
      await backup.importJson(text);
      expect(await store.names(), isEmpty);
      expect((await world.subs.get('s1'))!.customLogoFile, isNull);
    });

    test('a corrupt picture entry is skipped; the rest restores; editing without re-signing is refused', () async {
      await world.addSub('s1');
      await world.addSub('s2');
      final n1 = await withLogo('s1', png1);
      final n2 = await withLogo('s2', png2);
      final json = jsonDecode(await backup.exportJsonText()) as Map<String, Object?>;
      (json[BackupLogos.key]! as Map)[n2] = '%%% not base64';
      final data = {...json}..removeWhere((k, _) => const {'format', 'version', 'exportedAt', 'checksum'}.contains(k));
      json['checksum'] = BackupService.checksumOf(data);
      await store.clear();
      await backup.importJson(jsonEncode(json));
      expect(await store.names(), {n1});

      (json[BackupLogos.key]! as Map)[n1] = base64Encode(png2); // edited without re-signing
      expect(() => backup.parse(jsonEncode(json)), throwsA(isA<BackupFormatException>()));
    });
  });
}
