import 'dart:io';

import 'package:archive/archive_io.dart';

import '../../data/app_database.dart';
import 'storage_paths.dart';

/// Full PC-to-PC backup/restore (.zip = SQLite DB via VACUUM INTO + photos/)
/// plus automatic pre-destructive snapshots with rolling pruning.
///
/// Restore orchestration (screen layer):
/// 1. `validateBackup()` + `autoBackup()` while the DB is open,
/// 2. `await db.close()` in the app layer,
/// 3. `restoreFiles()` (pure file swap),
/// 4. reopen a fresh AppDatabase (also when step 3 fails).
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

    await writeBackupTo(target);
    return target;
  }

  /// Streams the full backup (DB snapshot + photos) straight to [target] on
  /// disk, so memory stays flat however many photos exist.
  Future<void> writeBackupTo(String target) async {
    final tmp = File('${paths.root.path}/vacuum_tmp.sqlite');
    if (await tmp.exists()) await tmp.delete();
    await db.customStatement('VACUUM INTO ?', [tmp.path]);
    final zip = ZipFileEncoder()..create(target);
    try {
      await zip.addFile(tmp, 'tabaro3_setif.sqlite');
      if (await paths.photos.exists()) {
        await for (final f in paths.photos.list()) {
          if (f is File) {
            await zip.addFile(f, 'photos/${f.uri.pathSegments.last}');
          }
        }
      }
    } finally {
      await zip.close();
      await tmp.delete();
    }
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

  /// Checks that [zipPath] holds a usable donor database, without touching
  /// the live files. Call BEFORE closing the DB; throws on a bad archive.
  Future<void> validateBackup(String zipPath) async {
    final dbEntry = await _dbEntry(zipPath);
    final tmp = File('${paths.root.path}/validate_tmp.sqlite');
    await tmp.writeAsBytes(dbEntry.content);
    final probe = AppDatabase(tmp.path);
    try {
      await probe.getAppSettings();
      await probe.getAllDonors();
    } catch (_) {
      throw Exception('invalid backup archive');
    } finally {
      await probe.close();
      for (final s in ['', '-wal', '-shm']) {
        final f = File('${tmp.path}$s');
        if (await f.exists()) await f.delete();
      }
    }
  }

  Future<ArchiveFile> _dbEntry(String zipPath) async {
    final file = File(zipPath);
    if (!await file.exists()) throw Exception('backup file not found');
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(await file.readAsBytes());
    } catch (_) {
      throw Exception('invalid backup archive');
    }
    final entry = archive.files
        .where((f) => f.name.endsWith('.sqlite'))
        .firstOrNull;
    if (entry == null ||
        entry.content.length < 100 ||
        !String.fromCharCodes(
          entry.content.sublist(0, 15),
        ).startsWith('SQLite format 3')) {
      throw Exception('invalid backup archive');
    }
    return entry;
  }

  /// Swaps DB file & photos from an archive already checked by
  /// [validateBackup]. Call only AFTER the database connection was closed.
  /// Returns the number of restored photo files.
  Future<int> restoreFiles(String zipPath) async {
    final archive = ZipDecoder().decodeBytes(await File(zipPath).readAsBytes());
    final dbEntry = await _dbEntry(zipPath);

    // Swap DB file (stale WAL/SHM from the old DB must not be replayed).
    final target = File(paths.dbFile);
    for (final s in ['', '-wal', '-shm']) {
      final f = File('${target.path}$s');
      if (await f.exists()) await f.delete();
    }
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
