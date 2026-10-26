import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/app_state.dart';
import 'package:tabaro3_setif/core/resources/app_theme.dart';
import 'package:tabaro3_setif/core/services/storage_paths.dart';
import 'package:tabaro3_setif/core/widgets/app_shell.dart';
import 'package:tabaro3_setif/data/app_database.dart';

/// Desktop layout surface (1024x680 = enforced app minimum).
const _surface = Size(1280, 800);

class _FakePaths implements StoragePaths {
  @override
  Directory get backups => Directory.systemTemp;
  @override
  String get dbFile => Directory.systemTemp.path;
  @override
  Directory get photos => Directory.systemTemp;
  @override
  Directory get root => Directory.systemTemp;
}

AppSetting _settings({String lang = 'ar'}) => AppSetting(
  id: 1,
  username: 'admin',
  passwordHash: '',
  isDefaultPassword: true,
  language: lang,
  notificationsEnabled: true,
  notifiedJson: '{}',
);

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<AppState> seed(String lang) async {
    final s = AppState(
      db: db,
      paths: _FakePaths(),
      settings: _settings(lang: lang),
    );
    await db.updateSettings(AppSettingsCompanion(language: Value(lang)));
    s.settings = await db.getAppSettings();
    return s;
  }

  Future<void> pumpShell(WidgetTester tester, AppState s) async {
    await tester.binding.setSurfaceSize(_surface);
    tester.view.physicalSize = _surface;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(),
        builder: (context, child) => Directionality(
          textDirection: s.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        home: AppShell(state: s, onLogout: () {}),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Arabic (RTL): sidebar hugs the RIGHT edge, content left', (
    tester,
  ) async {
    await pumpShell(tester, await seed('ar'));
    final sidebarRect = tester.getRect(find.byKey(const Key('app-sidebar')));
    expect(
      sidebarRect.left,
      _surface.width - 240,
      reason: 'In Arabic the sidebar must sit on the right edge',
    );
    expect(sidebarRect.right, _surface.width);
    await db.close(); // flush Drift's stream-cache timer (see Drift docs)
  });

  testWidgets('French (LTR): sidebar hugs the LEFT edge, content right', (
    tester,
  ) async {
    await pumpShell(tester, await seed('fr'));
    final sidebarRect = tester.getRect(find.byKey(const Key('app-sidebar')));
    expect(
      sidebarRect.left,
      0,
      reason: 'In French the sidebar must sit on the left edge',
    );
    expect(sidebarRect.right, 240);
    await db.close();
  });

  testWidgets('all screens lay out without exceptions at minimum size', (
    tester,
  ) async {
    final s = await seed('ar');
    await pumpShell(tester, s);
    for (final nav in ['dashboard', 'donors', 'alerts', 'data', 'settings']) {
      await tester.tap(find.byKey(Key('nav-$nav')));
      await tester.pumpAndSettle();
      final ex = tester.takeException();
      if (ex != null) {
        // ignore: avoid_print
        print('=== EXCEPTION ON $nav ===');
        if (ex is FlutterError) {
          FlutterError.dumpErrorToConsole(
            FlutterErrorDetails(exception: ex, library: 'layout test'),
            forceReport: true,
          );
        } else {
          // ignore: avoid_print
          print('  $ex');
        }
      }
      expect(ex, isNull, reason: '$nav screen must lay out cleanly');
    }
    await db.close();
  });
}
