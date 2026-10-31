import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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

/// Appends one line to the crash log inside the app's data folder, so a
/// silent Windows launch failure (no console, no dialog) leaves evidence.
Future<void> _logCrash(String message) async {
  final line = '${DateTime.now().toIso8601String()}  $message\n';
  for (final dir in [
    Directory(
      p.join(
        (await getApplicationSupportDirectory()).path,
        'CWTS_Setif',
        AppEnv.appDataFolderName,
      ),
    ),
    Directory.systemTemp,
  ]) {
    try {
      await dir.create(recursive: true);
      await File(
        p.join(dir.path, 'tabaro3_crash.log'),
      ).writeAsString(line, mode: FileMode.append);
      return;
    } catch (_) {
      // try the next fallback location
    }
  }
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) =>
        _logCrash('FlutterError: ${details.exception}\n${details.stack}');
    await _logCrash('startup: begin v${AppEnv.version}');

    await windowManager.ensureInitialized();
    await _logCrash('startup: windowManager ready');
    await NotificationService.init();
    await _logCrash('startup: notifications ready');

    final windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1024, 680),
      title: AppEnv.appTitle('Gestion des donneurs de sang – CWTS Sétif'),
      center: true,
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    await _logCrash('startup: window shown');

    final paths = await StoragePaths.resolve();
    final db = AppDatabase(paths.dbFile);
    final settings = await db.getAppSettings();
    final state = AppState(db: db, paths: paths, settings: settings);

    // After a .zip restore the files on disk changed: open a fresh connection
    // over the restored files and rebuild the whole UI from the new DB.
    state.onDatabaseReplaced = () => state.replaceDb(AppDatabase(paths.dbFile));

    runApp(Tabaro3App(state: state));
    await _logCrash('startup: runApp done');
  }, (error, stack) => _logCrash('Uncaught: $error\n$stack'));
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
          locale: Locale(state.lang),
          supportedLocales: const [Locale('ar'), Locale('fr')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
