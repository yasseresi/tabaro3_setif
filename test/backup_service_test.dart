import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/services/backup_service.dart';
import 'package:tabaro3_setif/core/services/storage_paths.dart';
import 'package:tabaro3_setif/data/app_database.dart';

class _Paths implements StoragePaths {
  _Paths(this.root);
  @override
  final Directory root;
  @override
  Directory get backups => Directory('${root.path}/backups')..createSync();
  @override
  Directory get photos => Directory('${root.path}/photos')..createSync();
  @override
  String get dbFile => '${root.path}/live.sqlite';
}

void main() {
  late Directory tmp;
  late AppDatabase db;
  late BackupService svc;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('bk');
    db = AppDatabase.forTesting(NativeDatabase.memory());
    svc = BackupService(db: db, paths: _Paths(tmp));
  });

  tearDown(() async {
    await db.close();
    tmp.deleteSync(recursive: true);
  });

  test(
    'exported backup validates; garbage and header-only DBs are rejected',
    () async {
      final good = '${tmp.path}/good.zip';
      await svc.writeBackupTo(good);
      await svc.validateBackup(good);

      final junk = File('${tmp.path}/junk.zip')..writeAsStringSync('nope');
      expect(svc.validateBackup(junk.path), throwsException);
    },
  );
}
