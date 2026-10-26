import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import 'services/storage_paths.dart';

/// Session-wide state: current language + settings row + storage paths.
/// Cheap ChangeNotifier — no extra packages.
class AppState extends ChangeNotifier {
  AppDatabase db;
  final StoragePaths paths;
  AppSetting settings;

  /// Set by main.dart: after a .zip restore, swaps in a fresh DB connection
  /// (the old one was closed) and rebuilds the whole UI.
  Future<void> Function()? onDatabaseReplaced;

  AppState({required this.db, required this.paths, required this.settings});

  String get lang => settings.language;
  bool get isRtl => lang != 'fr';

  /// Swap the (closed) DB for a new connection over restored files.
  Future<void> replaceDb(AppDatabase newDb) async {
    db = newDb;
    settings = await db.getAppSettings();
    notifyListeners();
  }

  Future<void> setLang(String newLang) async {
    if (newLang == lang) return;
    await db.updateSettings(AppSettingsCompanion(language: Value(newLang)));
    settings = await db.getAppSettings();
    notifyListeners();
  }

  Future<void> reloadSettings() async {
    settings = await db.getAppSettings();
    notifyListeners();
  }

  /// Called by ImportExportScreen after files were swapped on disk.
  Future<void> databaseReplaced() async {
    if (onDatabaseReplaced != null) await onDatabaseReplaced!();
  }
}
