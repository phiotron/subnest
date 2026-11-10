import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/features/lock/privacy_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late List<MethodCall> calls;
  const channel = MethodChannel(SecureWindow.channelName);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    await db.close();
  });

  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

  ProviderContainer container() {
    final c = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    c.listen(privacyScreenSyncProvider, (_, _) {});
    return c;
  }

  test('off by default: the app opens with setSecure(false)', () async {
    container();
    await settle();
    expect(calls.map((c) => '${c.method}(${c.arguments})'), ['setSecure(false)']);
  });

  test('saved on → applied when the app opens', () async {
    await SettingsRepository(db).set(privacyScreenKey, 'true');
    container();
    await settle();
    expect(calls.last.arguments, true);
  });

  test('switching applies at once, and the value is saved in the settings table', () async {
    final c = container();
    await settle();
    await c.read(settingsRepositoryProvider).set(privacyScreenKey, 'true');
    await settle();
    expect(calls.last.arguments, true);
    expect((await SettingsRepository(db).raw())[privacyScreenKey], 'true');
    expect(await c.read(privacyScreenProvider.future), isTrue);

    await c.read(settingsRepositoryProvider).set(privacyScreenKey, null);
    await settle();
    expect(calls.last.arguments, false);
  });

  test('"Delete all data" (every settings row deleted) turns it off like a new install', () async {
    await SettingsRepository(db).set(privacyScreenKey, 'true');
    container();
    await settle();
    expect(calls.last.arguments, true);
    await db.wipeEverything();
    await settle();
    expect(calls.last.arguments, false);
  });

  test('not in a backup file: a restore never changes it', () {
    expect(SettingsRepository.backupKeys, isNot(contains(privacyScreenKey)));
  });

  test('no native side or a refusal never throws', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => throw PlatformException(code: 'nope'),
    );
    await const SecureWindow().setSecure(true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
    await const SecureWindow().setSecure(true); // MissingPluginException swallowed
  });
}
