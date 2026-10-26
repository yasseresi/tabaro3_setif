import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../resources/app_env.dart';

/// Resolved locations for the database, photos and backups under the OS
/// Application Support directory (never next to the .exe).
class StoragePaths {
  final Directory root;
  final Directory photos;
  final Directory backups;

  StoragePaths._(this.root, this.photos, this.backups);

  String get dbFile => p.join(root.path, 'tabaro3_setif.sqlite');

  static Future<StoragePaths> resolve() async {
    final support = await getApplicationSupportDirectory();
    final root = Directory(
      p.join(support.path, 'CWTS_Setif', AppEnv.appDataFolderName),
    );
    final photos = Directory(p.join(root.path, 'photos'));
    final backups = Directory(p.join(root.path, 'backups'));
    await root.create(recursive: true);
    await photos.create(recursive: true);
    await backups.create(recursive: true);
    return StoragePaths._(root, photos, backups);
  }
}
