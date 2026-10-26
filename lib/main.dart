import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'core/app_state.dart';
import 'core/resources/app_env.dart';
import 'core/resources/app_strings.dart';
import 'core/resources/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_paths.dart';
import 'core/widgets/app_shell.dart';
import 'data/app_database.dart';
import 'features/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await NotificationService.init();

  const windowOptions = WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(1024, 680),
    title: 'Gestion des donneurs de sang – CWTS Sétif',
    center: true,
    titleBarStyle: TitleBarStyle.normal,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final paths = await StoragePaths.resolve();
  final db = AppDatabase(paths.dbFile);
  final settings = await db.getAppSettings();
  final state = AppState(db: db, paths: paths, settings: settings);

  // After a .zip restore the files on disk changed: open a fresh connection
  // over the restored files and rebuild the whole UI from the new DB.
  state.onDatabaseReplaced = () => state.replaceDb(AppDatabase(paths.dbFile));

  runApp(Tabaro3App(state: state));
}

/// Root widget: listens to AppState for instant AR/FR + direction switching.
class Tabaro3App extends StatefulWidget {
  final AppState state;
  const Tabaro3App({super.key, required this.state});

  @override
  State<Tabaro3App> createState() => _Tabaro3AppState();
}

class _Tabaro3AppState extends State<Tabaro3App> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return MaterialApp(
          title: AppEnv.appTitle(tr(state.lang, 'appName')),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(),
          builder: (context, child) {
            final rtl = state.isRtl;
            return Directionality(
              textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: _loggedIn
              ? AppShell(
                  state: state,
                  onLogout: () => setState(() => _loggedIn = false),
                )
              : LoginScreen(
                  state: state,
                  onSuccess: () => setState(() => _loggedIn = true),
                ),
        );
      },
    );
  }
}
