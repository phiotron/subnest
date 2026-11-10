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

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('custom_logos');
    store = CustomLogoStore(() async => Directory('${tmp.path}/custom_logos'));
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  File fileOf(String id) => File('${tmp.path}/custom_logos/$id.png');

  group('CustomLogoStore', () {
    test('save / has / fileOf / replace / remove, notifying each change', () async {
      var notified = 0;
      store.addListener(() => notified++);
      await store.load();
      expect(store.has('a'), isFalse);
      expect(store.fileOf('a'), isNull);

      await store.save('a', png1);
      expect(store.has('a'), isTrue);
      expect(store.fileOf('a')!.readAsBytesSync(), png1);
      await store.save('a', png2);
      expect(fileOf('a').readAsBytesSync(), png2);
      expect(notified, 2);

      await store.remove('a');
      expect(store.has('a'), isFalse);
      expect(fileOf('a').existsSync(), isFalse);
      expect(notified, 3);
      await store.remove('a'); // nothing to remove → no notification
      expect(notified, 3);
    });

    test('load finds files from an earlier run and drops half-written ones', () async {
      Directory('${tmp.path}/custom_logos').createSync();
      fileOf('x').writeAsBytesSync(png1);
      File('${tmp.path}/custom_logos/y.png.part').writeAsBytesSync([1]);
      await store.load();
      expect(store.ids, {'x'});
      expect(File('${tmp.path}/custom_logos/y.png.part').existsSync(), isFalse);
    });

    test('refuses bad ids (path tricks) and non-images', () async {
      expect(() => store.save('../evil', png1), throwsArgumentError);
      expect(() => store.save('a', Uint8List.fromList(utf8.encode('<svg>hello world</svg>'))), throwsArgumentError);
      expect(() => store.save('a', Uint8List(CustomLogoStore.maxBytes + 1)), throwsArgumentError);
      expect(CustomLogoStore.looksLikeImage(Uint8List.fromList([0xFF, 0xD8, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])), isTrue);
    });

    test('keepOnly prunes logos of deleted subscriptions; clear removes all', () async {
      await store.save('a', png1);
      await store.save('b', png1);
      await store.save('c', png1);
      await store.keepOnly({'a', 'c', 'zzz'});
      expect(store.ids, {'a', 'c'});
      expect(fileOf('b').existsSync(), isFalse);
      await store.clear();
      expect(store.ids, isEmpty);
      expect(Directory('${tmp.path}/custom_logos').listSync(), isEmpty);
    });

    test('readAll / replaceAll round trip; invalid entries skipped', () async {
      await store.save('a', png1);
      await store.save('b', png2);
      expect((await store.readAll()).keys, ['a', 'b']);
      expect((await store.readAll(only: {'b'})).keys, ['b']);
      final n = await store.replaceAll({'c': png1, '../x': png1, 'd': Uint8List.fromList([1, 2, 3])});
      expect(n, 1);
      expect(store.ids, {'c'});
      expect(fileOf('a').existsSync(), isFalse);
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

    test('no logos → no customLogos key (file unchanged from before)', () async {
      await world.addSub('s1');
      final json = jsonDecode(await backup.exportJsonText()) as Map<String, Object?>;
      expect(json.containsKey(BackupLogos.key), isFalse);
    });

    test('logo survives backup → delete all → restore; orphan logos are not exported', () async {
      await world.addSub('s1', name: 'My gym');
      await world.addSub('s2', name: 'Other');
      await store.save('s1', png1);
      await store.save('deleted-sub', png2);
      final text = await backup.exportJsonText();
      final json = jsonDecode(text) as Map<String, Object?>;
      expect((json[BackupLogos.key]! as Map).keys, ['s1']);

      // "Delete all data", then restore the file.
      await world.db.wipeEverything();
      await store.clear();
      expect(store.has('s1'), isFalse);

      final result = await backup.importJson(text);
      expect(result.subscriptions, 2);
      expect(store.ids, {'s1'});
      expect(fileOf('s1').readAsBytesSync(), png1);
    });

    test('restoring a file without logos removes the current ones (restore replaces everything)', () async {
      await world.addSub('s1');
      final text = await backup.exportJsonText();
      await store.save('s1', png1);
      await backup.importJson(text);
      expect(store.ids, isEmpty);
    });

    test('a corrupt logo entry is skipped; the rest of the restore works; checksum still checked', () async {
      await world.addSub('s1');
      await world.addSub('s2');
      await store.save('s1', png1);
      await store.save('s2', png2);
      final json = jsonDecode(await backup.exportJsonText()) as Map<String, Object?>;
      // Re-sign after editing, as a hand-made file would have to.
      (json[BackupLogos.key]! as Map)['s2'] = '%%% not base64';
      final data = {...json}..removeWhere((k, _) => const {'format', 'version', 'exportedAt', 'checksum'}.contains(k));
      json['checksum'] = BackupService.checksumOf(data);
      await store.clear();
      await backup.importJson(jsonEncode(json));
      expect(store.ids, {'s1'});

      (json[BackupLogos.key]! as Map)['s1'] = base64Encode(png2); // edited without re-signing
      expect(() => backup.parse(jsonEncode(json)), throwsA(isA<BackupFormatException>()));
    });
  });
}
