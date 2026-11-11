import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/settings_bits.dart';

/// Minimum length of a backup-file password.
const backupPasswordMinLength = 6;

/// Encrypts backup content with a password; tests can replace it.
typedef BackupExportEncryptor = Future<String> Function(String password);

/// Decrypts an envelope with a password; tests can replace it.
typedef BackupDecryptor = Future<String> Function(String envelope, String password);

/// Password input (`.input` with a lock in front and an eye to show it): `surface-2`, 1 px `line`
/// ring, `brand` ring while focused, `danger` ring + "⚠ message" under it on [errorText].
class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    required this.hint,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    OutlineInputBorder ring(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText: !_show,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          style: AppType.body.copyWith(color: c.ink),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppType.body.copyWith(color: c.inkMuted),
            filled: true,
            fillColor: c.surface2,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefixIcon: Icon(LucideIcons.lock, size: 18, color: c.inkMuted),
            suffixIcon: IconButton(
              tooltip: _show ? l.settingsBackupPasswordHide : l.settingsBackupPasswordShow,
              onPressed: () => setState(() => _show = !_show),
              icon: Icon(_show ? LucideIcons.eyeOff : LucideIcons.eye, size: 18, color: c.inkMuted),
            ),
            border: ring(c.line, 1),
            enabledBorder: ring(widget.errorText == null ? c.line : c.danger, widget.errorText == null ? 1 : 2),
            focusedBorder: ring(widget.errorText == null ? c.brand : c.danger, 2),
            disabledBorder: ring(c.line, 1),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(LucideIcons.circleAlert, size: 14, color: c.danger),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(widget.errorText!, style: AppType.meta.copyWith(color: c.danger)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Two password fields (new + repeat) with the length rule; shared by Back up now and the
/// Automatic backup set-up.
mixin TwoPasswords<T extends StatefulWidget> on State<T> {
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

  /// Password · "✓ At least 6 characters" · Repeat password.
  List<Widget> passwordFields(
    AppLocalizations l, {
    required VoidCallback onSubmit,
    bool enabled = true,
    bool autofocus = false,
  }) {
    final c = context.colors;
    final longEnough = password.text.runes.length >= backupPasswordMinLength;
    return [
      PasswordInput(
        controller: password,
        hint: l.settingsBackupPassword,
        errorText: passwordError,
        enabled: enabled,
        autofocus: autofocus,
        textInputAction: TextInputAction.next,
        onChanged: (_) => setState(() => passwordError = null),
      ),
      if (passwordError == null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(LucideIcons.check, size: 13, color: longEnough ? c.success : c.inkMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l.settingsAutoBackupPasswordRule,
                  style: AppType.meta.copyWith(color: longEnough ? c.success : c.inkMuted),
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: AppSpace.s3),
      PasswordInput(
        controller: confirm,
        hint: l.settingsBackupPasswordConfirm,
        errorText: confirmError,
        enabled: enabled,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => onSubmit(),
        onChanged: (_) {
          if (confirmError != null) setState(() => confirmError = null);
        },
      ),
    ];
  }

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

/// "Back up now" sheet (mockup 098): the file that will be saved (name, what it holds, size),
/// "Protect with a password" (off by default; on → two password fields, encrypted with
/// AES-256-GCM while the sheet stays open), "Save file…" / Cancel. Pops null when cancelled, an
/// empty string for an unprotected file, or the encrypted envelope text.
class BackupNowSheet extends StatefulWidget {
  const BackupNowSheet({super.key, required this.fileName, required this.meta, required this.encrypt});

  final String fileName;

  /// "12 subscriptions · 148 payments · 41 KB".
  final String meta;
  final BackupExportEncryptor encrypt;

  @override
  State<BackupNowSheet> createState() => _BackupNowSheetState();
}

class _BackupNowSheetState extends State<BackupNowSheet> with TwoPasswords {
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

  void _toggle() => setState(() {
    _protect = !_protect;
    passwordError = null;
    confirmError = null;
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return PopScope(
      canPop: !_busy,
      child: AppSheet(
        title: l.settingsBackupNow,
        actions: [
          AppButton.primary(
            label: _busy ? l.settingsBackupWorking : l.settingsBackupSave,
            icon: LucideIcons.hardDriveDownload,
            expand: true,
            loading: _busy,
            onPressed: _busy ? null : () => _submit(l),
          ),
          AppButton.text(label: l.commonCancel, expand: true, onPressed: _busy ? null : () => Navigator.pop(context)),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              FileChip(name: widget.fileName, meta: widget.meta),
              const SizedBox(height: AppSpace.s1),
              MergeSemantics(
                child: InkWell(
                  onTap: _busy ? null : _toggle,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.s2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.settingsBackupProtect, style: AppType.label.copyWith(color: c.ink)),
                              const SizedBox(height: 2),
                              Text(l.settingsBackupProtectHint, style: AppType.meta.copyWith(color: c.inkMuted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpace.s3),
                        AppToggle(
                          value: _protect,
                          semanticLabel: l.settingsBackupProtect,
                          onChanged: _busy ? null : (_) => _toggle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_protect) ...[
                const SizedBox(height: AppSpace.s2),
                ...passwordFields(l, enabled: !_busy, autofocus: true, onSubmit: () => _submit(l)),
                const SizedBox(height: AppSpace.s3),
                Text(l.settingsBackupPasswordWarning, style: AppType.meta.copyWith(color: c.warningInk)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
