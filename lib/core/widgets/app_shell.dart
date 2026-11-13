import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/alerts/alerts_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/donors/donor_form_screen.dart';
import '../../features/donors/donors_list_screen.dart';
import '../../features/import_export/import_export_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../app_state.dart';
import '../resources/app_colors.dart';
import '../resources/app_env.dart';
import '../resources/app_strings.dart';
import 'brand_emblems.dart';

/// Sidebar + institutional header + routed feature screens.
class AppShell extends StatefulWidget {
  final AppState state;
  final VoidCallback onLogout;
  const AppShell({super.key, required this.state, required this.onLogout});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _screen = 'dashboard';
  String? _editingDonorId;

  void openDonorForm({String? donorId}) {
    setState(() {
      _editingDonorId = donorId;
      _screen = 'form';
    });
  }

  void go(String screen) => setState(() {
    _screen = screen;
    _editingDonorId = null;
  });

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Directionality(
          textDirection: state.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            body: Row(
              children: [
                _sidebar(state),
                Expanded(
                  child: Column(
                    children: [
                      _header(state),
                      Expanded(child: _body(state)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sidebar(AppState state) {
    final lang = state.lang;
    String t(String key) => tr(lang, key);
    final items = [
      ('dashboard', LucideIcons.layoutDashboard, t('dashboard')),
      ('donors', LucideIcons.users, t('donors')),
      ('form', LucideIcons.userPlus, t('addDonor')),
      ('alerts', LucideIcons.bell, t('alerts')),
      ('data', LucideIcons.fileSpreadsheet, t('data')),
      ('settings', LucideIcons.settings, t('settings')),
    ];
    return Container(
      key: const Key('app-sidebar'),
      width: 240,
      decoration: const BoxDecoration(gradient: AppColors.sidebarGradient),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Row(
              children: [
                BloodDropLogo(
                  size: 34,
                  color: Colors.white,
                  heartColor: AppColors.primaryDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppEnv.appTitle(t('appName')),
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: StreamBuilder<int>(
              stream: state.db.dueCountStream(),
              builder: (context, snap) {
                final dueCount = snap.data ?? 0;
                return ListView(
                  padding: const EdgeInsetsDirectional.all(8),
                  children: [
                    for (final (id, icon, label) in items)
                      _NavItem(
                        key: Key('nav-$id'),
                        icon: icon,
                        label: label,
                        active: _screen == id,
                        badge: id == 'alerts' && dueCount > 0 ? dueCount : null,
                        onTap: () => go(id),
                      ),
                    const Divider(color: Colors.white24, height: 24),
                    _NavItem(
                      icon: LucideIcons.logOut,
                      label: t('logout'),
                      active: false,
                      onTap: widget.onLogout,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              children: [
                BloodDropLogo(
                  size: 56,
                  color: Colors.white,
                  heartColor: AppColors.primaryDark,
                ),
                const SizedBox(height: 8),
                Text(
                  t('together'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(AppState state) {
    final lang = state.lang;
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        children: [
          const AlgerianEmblem(size: 56),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  tr(lang, 'republic'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  tr(lang, 'ministry'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  tr(lang, 'center'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            tr(lang, 'slogan'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: AppColors.blood,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          BloodDropLogo(size: 44),
        ],
      ),
    );
  }

  Widget _body(AppState state) {
    switch (_screen) {
      case 'donors':
        return DonorsListScreen(state: state, onEdit: openDonorForm);
      case 'form':
        return DonorFormScreen(
          state: state,
          donorId: _editingDonorId,
          onClose: () => go('donors'),
        );
      case 'alerts':
        return AlertsScreen(state: state, onEdit: openDonorForm);
      case 'data':
        return ImportExportScreen(state: state);
      case 'settings':
        return SettingsScreen(state: state, onLogout: widget.onLogout);
      case 'dashboard':
      default:
        return DashboardScreen(
          state: state,
          onNavigate: go,
          onEdit: openDonorForm,
        );
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final int? badge;
  final VoidCallback onTap;
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 2),
      child: Material(
        color: active ? AppColors.sidebarActive : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blood,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$badge',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
