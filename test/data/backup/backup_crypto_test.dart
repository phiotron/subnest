import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_crypto.dart';
import 'package:subnest/data/backup/backup_service.dart';

import 'backup_test_utils.dart';

/// Encrypted backup envelope (AES-256-GCM + PBKDF2), same rules as A002 AC-55 / D-010.
void main() {
  const fast = 1000;
  late BackupWorld w;

  setUp(() => w = BackupWorld(clock: () => DateTime(2026, 11, 10, 10, 30)));
  tearDown(() => w.close());

  Future<String> sampleJson() async {
    await w.addSub('netflix', name: 'Netflix 🍿', price: 1599);
    return w.backup.exportJsonText();
  }

  String flipByte(String envelope, String field) {
    final root = jsonDecode(envelope) as Map<String, dynamic>;
    final bytes = base64.decode(root[field] as String);
    bytes[bytes.length ~/ 2] ^= 0x01;
    root[field] = base64.encode(bytes);
    return jsonEncode(root);
  }

  String edit(String envelope, void Function(Map<String, dynamic>) change) {
    final root = jsonDecode(envelope) as Map<String, dynamic>;
    change(root);
    return jsonEncode(root);
  }

  test('encrypts, decrypts byte for byte, and the content is unreadable', () async {
    final json = await sampleJson();
    final envelope = await encryptBackup(json, 'password1', iterations: fast);
    final root = jsonDecode(envelope) as Map<String, dynamic>;
    expect(root['format'], 'subnest-backup-encrypted');
    expect(root['version'], 1);
    expect(root['kdf'], 'pbkdf2-hmac-sha256');
    expect(root['iterations'], fast);
    expect(base64.decode(root['salt'] as String), hasLength(16));
    expect(base64.decode(root['nonce'] as String), hasLength(12));
    expect(envelope, isNot(contains('Netflix')));
    expect(envelope, isNot(contains('1599')));
    expect(envelope, isNot(contains('"subnest-backup"')));

    expect(isEncryptedBackup(envelope), isTrue);
    checkEncryptedBackup(envelope);
    final plain = await decryptBackup(envelope, 'password1');
    expect(plain, json);
    expect(w.backup.parse(plain).subscriptions.single.name, 'Netflix 🍿');
  });

  test('a wrong password is refused', () async {
    final envelope = await encryptBackup(await sampleJson(), 'password1', iterations: fast);
    for (final bad in ['password2', 'PASSWORD1', '', 'password1 ']) {
      await expectLater(decryptBackup(envelope, bad), throwsA(isA<BackupPasswordException>()), reason: bad);
    }
  });

  test('one changed byte (cipher text, salt, nonce, tag, work factor) is refused', () async {
    final envelope = await encryptBackup(await sampleJson(), 'password1', iterations: fast);
    for (final field in ['ciphertext', 'salt', 'nonce']) {
      await expectLater(
        decryptBackup(flipByte(envelope, field), 'password1'),
        throwsA(isA<BackupPasswordException>()),
        reason: field,
      );
    }
    final sealed = base64.decode((jsonDecode(envelope) as Map)['ciphertext'] as String);
    sealed[sealed.length - 1] ^= 0x80;
    await expectLater(
      decryptBackup(edit(envelope, (r) => r['ciphertext'] = base64.encode(sealed)), 'password1'),
      throwsA(isA<BackupPasswordException>()),
    );
    await expectLater(
      decryptBackup(edit(envelope, (r) => r['iterations'] = fast + 1), 'password1'),
      throwsA(isA<BackupPasswordException>()),
    );
  });

  test('the additional data binds format and version', () async {
    final envelope = await encryptBackup(await sampleJson(), 'password1', iterations: fast);
    final root = jsonDecode(envelope) as Map<String, dynamic>;
    final key = await Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: fast, bits: 256)
        .deriveKeyFromPassword(password: 'password1', nonce: base64.decode(root['salt'] as String));
    final sealed = base64.decode(root['ciphertext'] as String);
    final box = SecretBox(
      sealed.sublist(0, sealed.length - 16),
      nonce: base64.decode(root['nonce'] as String),
      mac: Mac(sealed.sublist(sealed.length - 16)),
    );
    final aes = AesGcm.with256bits();
    await aes.decrypt(box, secretKey: key, aad: utf8.encode('subnest-backup-encrypted:1'));
    for (final aad in ['subnest-backup-encrypted:2', 'subnest-backup:1', '']) {
      await expectLater(
        aes.decrypt(box, secretKey: key, aad: utf8.encode(aad)),
        throwsA(isA<SecretBoxAuthenticationError>()),
        reason: aad,
      );
    }
    for (final bad in [
      edit(envelope, (r) => r['format'] = 'subnest-backup'),
      edit(envelope, (r) => r['version'] = 2),
      edit(envelope, (r) => r['kdf'] = 'scrypt'),
    ]) {
      await expectLater(decryptBackup(bad, 'password1'), throwsA(isA<BackupFormatException>()));
    }
  });

  test('a malformed envelope is a format error, before any key work', () async {
    final envelope = await encryptBackup('{}', 'password1', iterations: fast);
    final bads = [
      'not json',
      edit(envelope, (r) => r['iterations'] = 0),
      edit(envelope, (r) => r['iterations'] = 2000000000),
      edit(envelope, (r) => r['iterations'] = '1000'),
      edit(envelope, (r) => r['salt'] = base64.encode([1, 2, 3])),
      edit(envelope, (r) => r['nonce'] = '***'),
      edit(envelope, (r) => r['ciphertext'] = base64.encode([1, 2, 3])),
      edit(envelope, (r) => r.remove('ciphertext')),
    ];
    for (final bad in bads) {
      expect(() => checkEncryptedBackup(bad), throwsA(isA<BackupFormatException>()));
      await expectLater(decryptBackup(bad, 'password1'), throwsA(isA<BackupFormatException>()));
    }
  });

  test('a plain backup is not mistaken for an encrypted one', () async {
    final json = await sampleJson();
    expect(isEncryptedBackup(json), isFalse);
    expect(isEncryptedBackup('abc'), isFalse);
    expect(isEncryptedBackup('[1]'), isFalse);
  });

  test('Vietnamese and emoji passwords; no Unicode normalisation', () async {
    const pw = 'Mật khẩu Đẹp 🔐🇻🇳';
    final json = await sampleJson();
    final envelope = await encryptBackup(json, pw, iterations: fast);
    expect(await decryptBackup(envelope, pw), json);
    await expectLater(decryptBackup(envelope, 'Mat khẩu Đẹp 🔐🇻🇳'), throwsA(isA<BackupPasswordException>()));
  });

  test('two encryptions of the same data differ (random salt and nonce)', () async {
    final json = await sampleJson();
    final a = jsonDecode(await encryptBackup(json, 'password1', iterations: fast));
    final b = jsonDecode(await encryptBackup(json, 'password1', iterations: fast));
    expect(a['salt'], isNot(b['salt']));
    expect(a['nonce'], isNot(b['nonce']));
    expect(a['ciphertext'], isNot(b['ciphertext']));
  });

  test('off-thread with the default work factor', () async {
    final json = await sampleJson();
    final envelope = await encryptBackupOffThread(json, 'password1');
    expect((jsonDecode(envelope) as Map)['iterations'], backupKdfIterations);
    expect(await decryptBackupOffThread(envelope, 'password1'), json);
    await expectLater(decryptBackupOffThread(envelope, 'wrong-one'), throwsA(isA<BackupPasswordException>()));
  });

  test('the backup checksum catches an edited plain file', () async {
    final json = await sampleJson();
    final edited = json.replaceFirst('"priceMinor": 1599', '"priceMinor": 1');
    expect(edited, isNot(json));
    expect(() => w.backup.parse(edited), throwsA(isA<BackupFormatException>()));
  });
}
