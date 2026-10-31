import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/widgets/brand_emblems.dart';

/// Screen 0: Login — centered card over radial navy gradient.
class LoginScreen extends StatefulWidget {
  final AppState state;
  final VoidCallback onSuccess;
  const LoginScreen({super.key, required this.state, required this.onSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false;
  bool _bad = false;

  String get lang => widget.state.lang;
  String t(String key) => tr(lang, key);

  Future<void> _login() async {
    setState(() => _busy = true);
    final ok = await widget.state.db.login(_user.text, _pass.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      _bad = false;
      if (widget.state.settings.isDefaultPassword && !await _forceChange()) {
        return;
      }
      widget.onSuccess();
    } else {
      setState(() => _bad = true);
    }
  }

  /// First login with the shipped admin/admin: a new password is mandatory.
  Future<bool> _forceChange() async {
    final ctrl = TextEditingController();
    var tooWeak = false;
    final pass = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(t('newPass')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(t('mustChangePass')),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl,
                obscureText: true,
                decoration: InputDecoration(
                  errorText: tooWeak ? t('password_min6') : null,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('cancel')),
            ),
            FilledButton(
              onPressed: () {
                final v = ctrl.text.trim();
                if (v.length < 6 || v.toLowerCase() == 'admin') {
                  setD(() => tooWeak = true);
                } else {
                  Navigator.pop(ctx, v);
                }
              },
              child: Text(t('confirm')),
            ),
          ],
        ),
      ),
    );
    if (pass == null) return false;
    await widget.state.db.updateAccount(widget.state.settings.username, pass);
    await widget.state.reloadSettings();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.state.settings;
    return Directionality(
      textDirection: widget.state.isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.4,
              colors: [AppColors.primaryDark, AppColors.primaryDeep],
            ),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BloodDropLogo(size: 72),
                    const SizedBox(height: 12),
                    Text(
                      tr(lang, 'appName'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr(lang, 'slogan'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.blood,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _user,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.user, size: 18),
                        hintText: t('username'),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pass,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.lock, size: 18),
                        hintText: t('password'),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    if (_bad)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 10),
                        child: Text(
                          t('badLogin'),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.destructive,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _busy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(LucideIcons.logIn, size: 16),
                        label: Text(t('login')),
                        onPressed: _busy ? null : _login,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          widget.state.setLang(lang == 'ar' ? 'fr' : 'ar'),
                      child: Text(lang == 'ar' ? 'Français' : 'العربية'),
                    ),
                    if (settings.isDefaultPassword)
                      Text(
                        t('defaultHint'),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
