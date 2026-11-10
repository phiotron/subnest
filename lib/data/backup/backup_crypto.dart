import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'backup_service.dart';

/// Encrypted backup envelope (F7 auto backup).
///
/// `{"format":"subnest-backup-encrypted","version":1,"kdf":"pbkdf2-hmac-sha256",
/// "iterations":N,"salt":b64,"nonce":b64,"ciphertext":b64}`. The 256-bit key is
/// derived with PBKDF2-HMAC-SHA256 from the password (UTF-8, no trimming, no
/// Unicode normalisation) and a 16-byte salt; AES-256-GCM with a 12-byte nonce;
/// `ciphertext` is the cipher text followed by the 16-byte GCM tag; AAD is the
/// UTF-8 of `"<format>:<version>"`.
const encryptedBackupFormat = 'subnest-backup-encrypted';
const encryptedBackupVersion = 1;
const backupKdf = 'pbkdf2-hmac-sha256';

/// Default work factor. The library is pure Dart (no native code), so 100.000
/// rounds takes a couple of seconds on a low-end phone. The number is stored in
/// the envelope, so it can be raised later without breaking old files.
const backupKdfIterations = 100000;

/// Highest work factor accepted when reading, so a hostile file cannot hang the phone.
const backupKdfMaxIterations = 1000000;

const _saltLength = 16;
const _nonceLength = 12;
const _tagLength = 16;

/// Wrong password, or a tampered envelope (the two cannot be told apart).
class BackupPasswordException implements Exception {
  @override
  String toString() => 'BackupPasswordException';
}

Uint8List _randomBytes(int n) {
  final r = Random.secure();
  return Uint8List.fromList([for (var i = 0; i < n; i++) r.nextInt(256)]);
}

List<int> _aad(String format, int version) => utf8.encode('$format:$version');

Future<SecretKey> _deriveKey(String password, List<int> salt, int iterations) =>
    Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: iterations, bits: 256)
        .deriveKeyFromPassword(password: password, nonce: salt);

/// Whether [content] is an encrypted envelope (only checks the `format` field).
bool isEncryptedBackup(String content) {
  try {
    final root = jsonDecode(content);
    return root is Map && root['format'] == encryptedBackupFormat;
  } catch (_) {
    return false;
  }
}

typedef _Envelope = ({
  int iterations,
  Uint8List salt,
  Uint8List nonce,
  Uint8List cipherText,
  Uint8List tag,
});

_Envelope _parseEnvelope(String content) {
  final Map<String, dynamic> root;
  try {
    root = jsonDecode(content) as Map<String, dynamic>;
  } catch (_) {
    throw const BackupFormatException('Not JSON');
  }
  if (root['format'] != encryptedBackupFormat) {
    throw const BackupFormatException('Not an encrypted Subnest backup');
  }
  final version = root['version'];
  if (version is! int || version < 1 || version > encryptedBackupVersion) {
    throw BackupFormatException('Unsupported version $version');
  }
  if (root['kdf'] != backupKdf) {
    throw const BackupFormatException('Unsupported key derivation');
  }
  final iterations = root['iterations'];
  if (iterations is! int || iterations < 1 || iterations > backupKdfMaxIterations) {
    throw const BackupFormatException('Invalid work factor');
  }
  Uint8List field(String name, {int? length, int minLength = 0}) {
    final v = root[name];
    if (v is! String) throw BackupFormatException('Missing $name');
    final Uint8List bytes;
    try {
      bytes = base64.decode(v);
    } catch (_) {
      throw BackupFormatException('$name is not base64');
    }
    if ((length != null && bytes.length != length) || bytes.length < minLength) {
      throw BackupFormatException('$name has the wrong length');
    }
    return bytes;
  }

  final salt = field('salt', length: _saltLength);
  final nonce = field('nonce', length: _nonceLength);
  final sealed = field('ciphertext', minLength: _tagLength);
  return (
    iterations: iterations,
    salt: salt,
    nonce: nonce,
    cipherText: Uint8List.sublistView(sealed, 0, sealed.length - _tagLength),
    tag: Uint8List.sublistView(sealed, sealed.length - _tagLength),
  );
}

/// Checks the envelope shape (no password, no expensive work). Throws
/// [BackupFormatException] on a bad format, version or field length.
void checkEncryptedBackup(String content) => _parseEnvelope(content);

/// Encrypts [json] (the text from `exportJsonText`) with [password]; returns the
/// JSON envelope. Two calls with the same data differ (random salt and nonce).
Future<String> encryptBackup(String json, String password, {int iterations = backupKdfIterations}) async {
  final salt = _randomBytes(_saltLength);
  final nonce = _randomBytes(_nonceLength);
  final key = await _deriveKey(password, salt, iterations);
  final box = await AesGcm.with256bits().encrypt(
    utf8.encode(json),
    secretKey: key,
    nonce: nonce,
    aad: _aad(encryptedBackupFormat, encryptedBackupVersion),
  );
  return jsonEncode({
    'format': encryptedBackupFormat,
    'version': encryptedBackupVersion,
    'kdf': backupKdf,
    'iterations': iterations,
    'salt': base64.encode(salt),
    'nonce': base64.encode(nonce),
    'ciphertext': base64.encode([...box.cipherText, ...box.mac.bytes]),
  });
}

/// Decrypts an envelope. Throws [BackupFormatException] on a bad shape and
/// [BackupPasswordException] on a wrong password or tampered content.
Future<String> decryptBackup(String envelope, String password) async {
  final e = _parseEnvelope(envelope);
  final key = await _deriveKey(password, e.salt, e.iterations);
  try {
    final plain = await AesGcm.with256bits().decrypt(
      SecretBox(e.cipherText, nonce: e.nonce, mac: Mac(e.tag)),
      secretKey: key,
      aad: _aad(encryptedBackupFormat, encryptedBackupVersion),
    );
    return utf8.decode(plain);
  } on SecretBoxAuthenticationError {
    throw BackupPasswordException();
  } on FormatException {
    // Decrypted, but not UTF-8: treat it as corrupted.
    throw BackupPasswordException();
  }
}

/// [encryptBackup] on a separate isolate so the UI does not freeze while the key
/// is derived (can take a few seconds).
Future<String> encryptBackupOffThread(String json, String password) =>
    Isolate.run(() => encryptBackup(json, password));

/// [decryptBackup] on a separate isolate.
Future<String> decryptBackupOffThread(String envelope, String password) =>
    Isolate.run(() => decryptBackup(envelope, password));
