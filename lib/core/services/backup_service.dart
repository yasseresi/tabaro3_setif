import 'dart:io';

import 'package:archive/archive.dart';

import '../../data/app_database.dart';
import 'storage_paths.dart';

/// Full PC-to-PC backup/restore (.zip = SQLite DB via VACUUM INTO + photos/)
/// plus automatic pre-destructive snapshots with rolling pruning.
///
/// Restore orchestration (screen layer):
/// 1. `exportBackup()` / `autoBackup()` while the DB is open (uses VACUUM INTO),
/// 2. `await db.close()` in the app layer,
/// 3. `restoreFiles()` (pure file swap),
/// 4. reopen a fresh AppDatabase.
class BackupService {
  final AppDatabase db;
  final StoragePaths paths;
  BackupService({required this.db, required this.paths});

  /// Writes `cwts_setif_backup_YYYY-MM-DD_HHMMSS.zip` (or [targetPath]) and
  /// returns the path.
  Future<String> exportBackup({String? targetPath}) async {
    final stamp = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final target =
        targetPath ??
        '${paths.backups.path}/cwts_setif_backup_'
            '${stamp.year}-${two(stamp.month)}-${two(stamp.day)}_'
            '${two(stamp.hour)}${two(stamp.minute)}${two(stamp.second)}.zip';

    final bytes = await buildBackupArchive();
    await File(target).writeAsBytes(bytes);
    return target;
  }

  /// Builds the full backup archive in memory (DB snapshot + photos).
  Future<List<int>> buildBackupArchive() async {
    final tmp = File('${paths.root.path}/vacuum_tmp.sqlite');
    if (await tmp.exists()) await tmp.delete();
    await db.customStatement('VACUUM INTO ?', [tmp.path]);

    final archive = Archive();
    final dbBytes = await tmp.readAsBytes();
    archive.addFile(
      ArchiveFile('tabaro3_setif.sqlite', dbBytes.length, dbBytes),
    );
    await tmp.delete();
    await _addPhotos(archive, 'photos/');
    return ZipEncoder().encode(archive)!;
  }

  /// Silent auto snapshot in backups/ + prune to last 10. Returns the path.
  Future<String> autoBackup({String prefix = 'auto_backup'}) async {
    final stamp = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final name =
        '${prefix}_${stamp.year}-${two(stamp.month)}-${two(stamp.day)}_'
        '${two(stamp.hour)}${two(stamp.minute)}${two(stamp.second)}.zip';
    final target = await exportBackup(
      targetPath: '${paths.backups.path}/$name',
    );
    await _pruneBackups();
    return target;
  }

  Future<void> _addPhotos(Archive archive, String prefix) async {
    if (!await paths.photos.exists()) return;
    await for (final f in paths.photos.list()) {
      if (f is File) {
        final bytes = await f.readAsBytes();
        archive.addFile(
          ArchiveFile('$prefix${f.uri.pathSegments.last}', bytes.length, bytes),
        );
      }
    }
  }

  Future<void> _pruneBackups() async {
    final files =
        (await paths.backups.list().toList())
            .whereType<File>()
            .where((f) => f.path.endsWith('.zip'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final f in files.skip(10)) {
      await f.delete();
    }
  }

  /// Validates + extracts the archive, then swaps DB file & photos.
  /// Call only AFTER the database connection has been closed.
  /// Returns the number of restored photo files.
  Future<int> restoreFiles(String zipPath) async {
    final file = File(zipPath);
    if (!await file.exists()) {
      throw Exception('backup file not found');
    }
    final archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    final dbEntry = archive.files
        .where((f) => f.name.endsWith('.sqlite'))
        .firstOrNull;
    if (dbEntry == null || dbEntry.content.length < 100) {
      throw Exception('invalid backup archive');
    }
    final header = String.fromCharCodes(dbEntry.content.sublist(0, 15));
    if (!header.startsWith('SQLite format 3')) {
      throw Exception('invalid backup archive');
    }

    // Swap DB file.
    final target = File(paths.dbFile);
    if (await target.exists()) await target.delete();
    await target.writeAsBytes(dbEntry.content);

    // Swap photos.
    var photoCount = 0;
    if (await paths.photos.exists()) {
      await paths.photos.delete(recursive: true);
    }
    await paths.photos.create(recursive: true);
    for (final entry in archive.files) {
      if (entry.name.startsWith('photos/') && entry.size > 0) {
        final name = entry.name.split('/').last;
        if (name.isEmpty) continue;
        await File('${paths.photos.path}/$name').writeAsBytes(entry.content);
        photoCount++;
      }
    }
    return photoCount;
  }
}
