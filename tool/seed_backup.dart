// Builds a restorable backup .zip full of fake donors for manual testing.
//
//   dart run tool/seed_backup.dart [count=300] [out=seed_backup.zip]
//
// Then in the app: Import/Export -> Restore backup -> pick the zip.
// WARNING: restoring REPLACES all data in the app you restore into (use beta).
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:image/image.dart' as img;
import 'package:tabaro3_setif/data/app_database.dart';

const _first = [
  'Yacine',
  'Amine',
  'Karim',
  'Nadia',
  'Samira',
  'Lina',
  'Walid',
  'Meriem',
  'ياسين',
  'أمينة',
  'كريم',
  'نادية',
  'سميرة',
  'وليد',
  'مريم',
  'إسلام',
];
const _last = [
  'Benali',
  'Messahli',
  'Boudiaf',
  'Hamdi',
  'Cherif',
  'Khelifi',
  'بن علي',
  'مسهلي',
  'بوضياف',
  'حمدي',
  'شريف',
  'خليفي',
];
const _groups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
const _places = ['Sétif', 'Alger', 'Constantine', 'Béjaïa', 'سطيف', 'باتنة'];

String _iso(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Future<void> main(List<String> args) async {
  final count = args.isNotEmpty ? int.parse(args[0]) : 300;
  final out = args.length > 1 ? args[1] : 'seed_backup.zip';
  final rnd = Random(42);
  final work = Directory.systemTemp.createTempSync('seed_');
  final live = File('${work.path}/live.sqlite');
  final photosDir = Directory('${work.path}/photos')..createSync();
  final db = AppDatabase(live.path);
  final now = DateTime.now();

  for (var i = 0; i < count; i++) {
    final id = 'seed-$i';
    final female = rnd.nextInt(100) < 40;
    final name =
        '${_first[rnd.nextInt(_first.length)]} ${_last[rnd.nextInt(_last.length)]}';
    final hasPhone = i % 10 != 0; // some donors without a phone
    var hasPhoto = false;
    if (i < 5) {
      File('${photosDir.path}/$id.jpg').writeAsBytesSync(
        img.encodeJpg(
          img.fill(
            img.Image(width: 200, height: 200),
            color: img.ColorRgb8(180, 30 + i * 40, 50),
          ),
          quality: 80,
        ),
      );
      hasPhoto = true;
    }
    await db.insertDonorData(
      Donor(
        id: id,
        name: name,
        gender: female ? 'F' : 'M',
        bloodGroup: _groups[rnd.nextInt(_groups.length)],
        phone: hasPhone ? '05${rnd.nextInt(90000000) + 10000000}' : '',
        maidenName: female ? _last[rnd.nextInt(_last.length)] : '',
        address: 'Cité $i, Sétif',
        email: i % 4 == 0 ? 'donor$i@example.com' : '',
        workAddress: '',
        workPhone: '',
        workEmail: '',
        phenotype: '',
        birthDate: _iso(
          DateTime(
            1960 + rnd.nextInt(45),
            1 + rnd.nextInt(12),
            1 + rnd.nextInt(28),
          ),
        ),
        birthPlace: _places[rnd.nextInt(_places.length)],
        lastDonation: '',
        lastTest: '',
        notes: i % 15 == 0 ? 'Note de test $i' : '',
        photoFilename: hasPhoto ? '$id.jpg' : '',
        donationCount: 0,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
      ),
    );
    // 0-4 past donations, spread so donors land in due / soon / waiting.
    var daysAgo = rnd.nextInt(400);
    for (var e = rnd.nextInt(5); e > 0; e--) {
      await db.recordEvent(
        donorId: id,
        eventType: 'donation',
        eventDate: _iso(now.subtract(Duration(days: daysAgo))),
        ta: '12/7',
        weight: '${60 + rnd.nextInt(30)}',
      );
      daysAgo += 90 + rnd.nextInt(120);
    }
  }

  final snapshot = File('${work.path}/snapshot.sqlite');
  await db.customStatement('VACUUM INTO ?', [snapshot.path]);
  await db.close();

  final zip = ZipFileEncoder()..create(out);
  await zip.addFile(snapshot, 'tabaro3_setif.sqlite');
  for (final f in photosDir.listSync().whereType<File>()) {
    await zip.addFile(f, 'photos/${f.uri.pathSegments.last}');
  }
  await zip.close();
  work.deleteSync(recursive: true);
  stdout.writeln(
    'Wrote \$out with \$count donors. After restoring, log in with admin / admin (you will be asked to set a new password).',
  );
}
