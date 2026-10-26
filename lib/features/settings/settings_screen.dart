import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_env.dart';
import '../../core/resources/app_strings.dart';
import '../../core/services/backup_service.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 6: Settings — account, language, reset data, version info.
class SettingsScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onLogout;
  const SettingsScreen({
    super.key,
    required this.state,
    required this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();

  String get lang => widget.state.lang;
  String t(String key) => tr(lang, key);

  @override
  void initState() {
    super.initState();
    _user.text = widget.state.settings.username;
  }

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.state.settings;
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: ListView(
        children: [
          AppPanel(
            title: t('account'),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(t('username')),
                  TextField(
                    controller: _user,
                    textDirection: TextDirection.ltr,
                    maxLength: 40,
                  ),
                  _label('${t('newPass')} (${t('optional')})'),
                  TextField(
                    controller: _pass,
                    obscureText: true,
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(LucideIcons.save, size: 16),
                    label: Text(t('save')),
                    onPressed: _saveAccount,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppPanel(
            title: t('language'),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: Row(
                children: [
                  _langButton('ar', 'العربية'),
                  const SizedBox(width: 8),
                  _langButton('fr', 'Français'),
                  const SizedBox(width: 24),
                  const Icon(LucideIcons.bell, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    settings.notificationsEnabled
                        ? t('notifOn')
                        : t('notificationsDisabled'),
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                  ),
                  const Spacer(),
                  Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (v) => widget.state.db
                        .updateSettings(
                          AppSettingsCompanion(notificationsEnabled: Value(v)),
                        )
                        .then((_) => widget.state.reloadSettings()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppPanel(
            title: t('resetData'),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.triangleAlert,
                    size: 20,
                    color: AppColors.destructive,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(t('confirmReset'))),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,
                    ),
                    icon: const Icon(LucideIcons.trash2, size: 16),
                    label: Text(t('resetData')),
                    onPressed: _resetData,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppPanel(
            title: t('versionLabel'),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Version ${AppEnv.version} (${AppEnv.isBeta ? 'Beta' : 'Stable'})',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    '${t('dbPath')}: ${widget.state.paths.dbFile}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String s) => Padding(
    padding: const EdgeInsetsDirectional.only(top: 8, bottom: 4),
    child: Text(
      s,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _langButton(String code, String label) {
    final active = lang == code;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: active ? AppColors.primary : AppColors.card,
        foregroundColor: active ? Colors.white : AppColors.textPrimary,
        side: BorderSide(color: active ? AppColors.primary : AppColors.border),
      ),
      onPressed: () => widget.state.setLang(code),
      child: Text(label),
    );
  }

  Future<void> _saveAccount() async {
    final pass = _pass.text.trim();
    if (pass.isNotEmpty && pass.length < 4) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t('password_min'))));
      }
      return;
    }
    await widget.state.db.updateAccount(_user.text, pass.isEmpty ? null : pass);
    await widget.state.reloadSettings();
    _pass.clear();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t('saved'))));
    }
  }

  Future<void> _resetData() async {
    // Gate 1: admin password (with the confirm text acting as the dialog title).
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('resetData')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t('confirmReset')),
            const SizedBox(height: 10),
            Text(t('enterPassword')),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              obscureText: true,
              onSubmitted: (_) => Navigator.pop(ctx, true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.destructive,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('confirm')),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final settings = widget.state.settings;
    final passOk = await widget.state.db.login(
      settings.username,
      controller.text,
    );
    if (!mounted) return;
    if (!passOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t('wrongPassword'))),
      );
      return;
    }
    // Gate 2: automatic pre-wipe .zip backup.
    final backup = BackupService(
      db: widget.state.db,
      paths: widget.state.paths,
    );
    final messenger = ScaffoldMessenger.of(context);
    await backup.autoBackup(prefix: 'pre_reset');
    await widget.state.db.deleteAllData();
    messenger.showSnackBar(
      SnackBar(content: Text('${t('deleted')} — ${t('backupDone')}')),
    );
  }
}
