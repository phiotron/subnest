import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/backup_crypto.dart';

/// Minimum length of a backup-file password.
const backupPasswordMinLength = 6;

/// Encrypts backup content with a password; tests can replace it.
typedef BackupExportEncryptor = Future<String> Function(String password);

/// Decrypts an envelope with a password; tests can replace it.
typedef BackupDecryptor = Future<String> Function(String envelope, String password);

/// A password input styled like the rest of Settings. Obscured, with an error line.
class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: AppType.body.copyWith(color: c.ink),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        filled: true,
        fillColor: c.surface2,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md))),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.md)),
          borderSide: BorderSide(color: c.line),
        ),
      ),
    );
  }
}

/// Warning line above password fields: the password cannot be recovered.
class _PasswordWarning extends StatelessWidget {
  const _PasswordWarning(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.alert, size: 18, color: c.danger),
          const SizedBox(width: AppSpace.s2),
          Expanded(child: Text(text, style: AppType.meta.copyWith(color: c.danger))),
        ],
      ),
    );
  }
}

mixin _TwoPasswords<T extends StatefulWidget> on State<T> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  String? passwordError;
  String? confirmError;

  /// A valid password, or null (the error is already shown under the field).
  String? validated(AppLocalizations l) {
    final pw = password.text;
    final tooShort = pw.runes.length < backupPasswordMinLength;
    final mismatch = pw != confirm.text;
    setState(() {
      passwordError = tooShort ? l.settingsBackupPasswordTooShort : null;
      confirmError = !tooShort && mismatch ? l.settingsBackupPasswordMismatch : null;
    });
    return tooShort || mismatch ? null : pw;
  }

  List<Widget> fields(
    AppLocalizations l, {
    required VoidCallback onSubmit,
    bool enabled = true,
    bool autofocus = false,
  }) => [
    _PasswordField(
      controller: password,
      label: l.settingsBackupPassword,
      errorText: passwordError,
      enabled: enabled,
      autofocus: autofocus,
      textInputAction: TextInputAction.next,
    ),
    const SizedBox(height: AppSpace.s3),
    _PasswordField(
      controller: confirm,
      label: l.settingsBackupPasswordConfirm,
      errorText: confirmError,
      enabled: enabled,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmit(),
    ),
  ];

  @override
  void dispose() {
    // Clear the passwords from the fields before releasing them.
    password.clear();
    confirm.clear();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }
}

/// "Export backup": the password is optional (off by default). Turning it on shows the warning
/// and two password fields, then encrypts while the dialog stays open ("Working…"). Returns null
/// when cancelled, an empty string for an unprotected export, or the encrypted envelope text.
class BackupExportDialog extends StatefulWidget {
  const BackupExportDialog({super.key, required this.encrypt});

  final BackupExportEncryptor encrypt;

  @override
  State<BackupExportDialog> createState() => _BackupExportDialogState();
}

class _BackupExportDialogState extends State<BackupExportDialog> with _TwoPasswords {
  bool _protect = false;
  bool _busy = false;

  Future<void> _submit(AppLocalizations l) async {
    if (_busy) return;
    if (!_protect) {
      Navigator.pop(context, '');
      return;
    }
    final pw = validated(l);
    if (pw == null) return;
    setState(() => _busy = true);
    try {
      final content = await widget.encrypt(pw);
      if (mounted) Navigator.pop(context, content);
    } catch (_) {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: AppDialog(
        title: l.settingsExportBackup,
        body: l.settingsBackupExportNote,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _busy ? null : () => setState(() => _protect = !_protect),
              child: Row(
                children: [
                  Expanded(child: Text(l.settingsBackupProtect, style: AppType.body)),
                  const SizedBox(width: AppSpace.s3),
                  AppToggle(
                    value: _protect,
                    semanticLabel: l.settingsBackupProtect,
                    onChanged: _busy ? null : (on) => setState(() => _protect = on),
                  ),
                ],
              ),
            ),
            if (_protect) ...[
              const SizedBox(height: AppSpace.s2),
              _PasswordWarning(l.settingsBackupPasswordWarning),
              ...fields(l, enabled: !_busy, autofocus: true, onSubmit: () => _submit(l)),
            ],
          ],
        ),
        actions: [
          AppButton.text(label: l.commonCancel, expand: true, onPressed: _busy ? null : () => Navigator.pop(context)),
          AppButton.primary(
            label: _busy ? l.settingsBackupWorking : l.settingsBackupExportAction,
            icon: AppIcons.backup,
            expand: true,
            loading: _busy,
            onPressed: _busy ? null : () => _submit(l),
          ),
        ],
      ),
    );
  }
}

/// Asks for the password of an encrypted backup. A wrong password is shown under the field and
/// what was typed stays for a retry. While decrypting, the field and Cancel are disabled. Returns
/// the decrypted JSON, null when cancelled.
class BackupUnlockDialog extends StatefulWidget {
  const BackupUnlockDialog({super.key, required this.envelope, this.decrypt = decryptBackupOffThread});

  final String envelope;
  final BackupDecryptor decrypt;

  @override
  State<BackupUnlockDialog> createState() => _BackupUnlockDialogState();
}

class _BackupUnlockDialogState extends State<BackupUnlockDialog> {
  final _password = TextEditingController();
  bool _busy = false;
  bool _wrong = false;

  @override
  void dispose() {
    _password.clear();
    _password.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    if (_busy || _password.text.isEmpty) return;
    setState(() {
      _busy = true;
      _wrong = false;
    });
    try {
      final json = await widget.decrypt(widget.envelope, _password.text);
      if (mounted) Navigator.pop(context, json);
    } catch (_) {
      // A wrong password and a modified file cannot be told apart; keep the dialog open.
      if (!mounted) return;
      setState(() {
        _busy = false;
        _wrong = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: AppDialog(
        title: l.settingsBackupEnterPasswordTitle,
        body: l.settingsBackupEnterPasswordBody,
        content: _PasswordField(
          controller: _password,
          label: l.settingsBackupPassword,
          enabled: !_busy,
          autofocus: true,
          textInputAction: TextInputAction.done,
          errorText: _wrong ? l.settingsBackupWrongPassword : null,
          onSubmitted: (_) => _open(),
        ),
        actions: [
          AppButton.text(label: l.commonCancel, expand: true, onPressed: _busy ? null : () => Navigator.pop(context)),
          AppButton.primary(
            label: _busy ? l.settingsBackupWorking : l.settingsBackupOpen,
            expand: true,
            loading: _busy,
            onPressed: _busy ? null : _open,
          ),
        ],
      ),
    );
  }
}

/// Sets the password for automatic backups (always required): warning, at least 6 characters,
/// typed twice. Returns the password, null when cancelled.
class AutoBackupPasswordDialog extends StatefulWidget {
  const AutoBackupPasswordDialog({super.key});

  @override
  State<AutoBackupPasswordDialog> createState() => _AutoBackupPasswordDialogState();
}

class _AutoBackupPasswordDialogState extends State<AutoBackupPasswordDialog> with _TwoPasswords {
  void _submit(AppLocalizations l) {
    final pw = validated(l);
    if (pw != null) Navigator.pop(context, pw);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppDialog(
      title: l.settingsAutoBackupPasswordTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _PasswordWarning(l.settingsAutoBackupPasswordWarning),
          ...fields(l, autofocus: true, onSubmit: () => _submit(l)),
        ],
      ),
      actions: [
        AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(context)),
        AppButton.primary(label: l.settingsAutoBackupTurnOn, expand: true, onPressed: () => _submit(l)),
      ],
    );
  }
}
