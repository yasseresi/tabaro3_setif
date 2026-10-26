import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'storage_paths.dart';

/// Donor photo handling: pick → decode → resize ≤600x600 JPEG →
/// `photos/<donor_id>.jpg`. Only the relative filename is stored in SQLite.
class PhotoService {
  final StoragePaths paths;
  PhotoService({required this.paths});

  /// Opens a picker and returns raw image bytes (null when cancelled).
  Future<List<int>?> pickBytes() async {
    final picked = await FilePicker.pickFile(type: FileType.image);
    if (picked == null || picked.path == null) return null;
    final data = await File(picked.path!).readAsBytes();
    return data.toList();
  }

  Future<String> store(String donorId, List<int> bytes) async {
    final decoded = img.decodeImage(Uint8List.fromList(bytes));
    if (decoded == null) return '';
    var image = decoded;
    if (image.width > 600 || image.height > 600) {
      image = img.copyResize(
        image,
        width: image.width >= image.height ? 600 : null,
        height: image.height > image.width ? 600 : null,
      );
    }
    final jpeg = img.encodeJpg(image, quality: 82);
    final name = '$donorId.jpg';
    await File('${paths.photos.path}/$name').writeAsBytes(jpeg);
    return name;
  }

  File fileFor(String filename) => File('${paths.photos.path}/$filename');

  Future<void> remove(String filename) async {
    if (filename.isEmpty) return;
    final f = fileFor(filename);
    if (await f.exists()) await f.delete();
  }
}

/// Clipboard helper for the Alerts "Call" button (desktop-safe: no tel: links).
Future<void> copyPhoneToClipboard(String phone) async {
  await Clipboard.setData(ClipboardData(text: phone));
}
