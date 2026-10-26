import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/domain/eligibility.dart';
import 'package:tabaro3_setif/data/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  DonorsCompanion donor(String name,
      {String gender = 'M',
      String group = 'O+',
      String phone = '',
      String lastDonation = '',
      String lastTest = ''}) {
    return DonorsCompanion.insert(
      id: 'id_$name',
      name: name,
      gender: gender,
      bloodGroup: group,
      phone: Value(phone),
      lastDonation: Value(lastDonation),
      lastTest: Value(lastTest),
      createdAt: '2026-01-01T00:00:00',
      updatedAt: '2026-01-01T00:00:00',
    );
  }

  group('auth', () {
    test('default admin/admin works', () async {
      expect(await db.login('admin', 'admin'), isTrue);
      expect(await db.login('admin', 'wrong'), isFalse);
    });

    test('password change persists & hides default flag', () async {
      await db.updateAccount('boss', 'secret1');
      final s = await db.getAppSettings();
      expect(s.username, 'boss');
      expect(s.isDefaultPassword, isFalse);
      expect(await db.login('boss', 'secret1'), isTrue);
      expect(await db.login('admin', 'admin'), isFalse);
      // Restart simulation: new connection over same memory? (settings row
      // logic is covered by insertOrIgnore in beforeOpen)
    });
  });

  group('donor CRUD', () {
    test('insert & watch donors', () async {
      await db.insertDonor(donor('Ahmed'));
      final list = await db.getAllDonors();
      expect(list.length, 1);
      expect(list.first.name, 'Ahmed');
    });

    test('update donor', () async {
      await db.insertDonor(donor('Ahmed'));
      final d = await db.getDonor('id_Ahmed');
      await db.updateDonor(d.copyWith(phone: '0551112233'));
      final d2 = await db.getDonor('id_Ahmed');
      expect(d2.phone, '0551112233');
    });

    test('delete donor cascades events', () async {
      await db.insertDonor(donor('Ahmed'));
      await db.recordEvent(
          donorId: 'id_Ahmed', eventType: 'donation', eventDate: '2026-05-01');
      await db.deleteDonor('id_Ahmed');
      expect(await db.getAllDonors(), isEmpty);
      expect(await db.getEvents('id_Ahmed'), isEmpty);
    });
  });

  group('recordEvent transactional invariant', () {
    test('recording donation updates lastDonation + count + inserts event',
        () async {
      await db.insertDonor(donor('Sara', gender: 'F'));
      await db.recordEvent(
          donorId: 'id_Sara', eventType: 'donation', eventDate: '2026-06-15');
      final d = await db.getDonor('id_Sara');
      expect(d.lastDonation, '2026-06-15');
      expect(d.donationCount, 1);
      final events = await db.getEvents('id_Sara');
      expect(events.length, 1);
      expect(events.first.eventType, 'donation');
    });

    test('re-recording same date does not duplicate', () async {
      await db.insertDonor(donor('Sara', gender: 'F'));
      await db.recordEvent(
          donorId: 'id_Sara', eventType: 'donation', eventDate: '2026-06-15');
      await db.recordEvent(
          donorId: 'id_Sara',
          eventType: 'donation',
          eventDate: '2026-06-15',
          ta: '12/8');
      final events = await db.getEvents('id_Sara');
      expect(events.length, 1);
      expect(events.first.ta, '12/8');
    });

    test('donation then test keeps both latest dates', () async {
      await db.insertDonor(donor('Karim'));
      await db.recordEvent(
          donorId: 'id_Karim', eventType: 'donation', eventDate: '2026-05-01');
      await db.recordEvent(
          donorId: 'id_Karim', eventType: 'test', eventDate: '2026-08-01');
      final d = await db.getDonor('id_Karim');
      expect(d.lastDonation, '2026-05-01');
      expect(d.lastTest, '2026-08-01');
      // reference = test -> wait
      expect(
        eligibilityStatus(
            gender: 'M',
            lastDonation: d.lastDonation,
            lastTest: d.lastTest,
            now: DateTime(2026, 10, 20)),
        'wait',
      );
    });

    test('deleting an event recomputes donor summary', () async {
      await db.insertDonor(donor('Karim'));
      await db.recordEvent(
          donorId: 'id_Karim', eventType: 'donation', eventDate: '2026-05-01');
      await db.recordEvent(
          donorId: 'id_Karim', eventType: 'donation', eventDate: '2026-08-01');
      expect((await db.getDonor('id_Karim')).donationCount, 2);
      final events = await db.getEvents('id_Karim');
      final first = events.firstWhere((e) => e.eventDate == '2026-05-01');
      await db.deleteEvent(first.id);
      final d = await db.getDonor('id_Karim');
      expect(d.donationCount, 1);
      expect(d.lastDonation, '2026-08-01');
    });
  });

  group('smart merge', () {
    test('new rows added, matching rows merged, invalid rows skipped',
        () async {
      await db.insertDonor(donor('Ahmed', group: 'O+', phone: '0551112233'));
      // History is created through recordEvent (transactional invariant),
      // exactly like the app does when registering a donation.
      await db.recordEvent(
        donorId: 'id_Ahmed',
        eventType: 'donation',
        eventDate: '2026-01-01',
      );

      final rows = [
        // exact new donor
        ImportedDonor(
            name: 'Nadia',
            gender: 'F',
            bloodGroup: 'A+',
            phone: '0559998877',
            maidenName: '',
            address: '',
            email: '',
            workAddress: '',
            workPhone: '',
            workEmail: '',
            phenotype: '',
            birthDate: '',
            lastDonation: '2026-02-01',
            lastTest: '',
            notes: ''),
        // same phone -> merge, keep max date, fill address
        ImportedDonor(
            name: 'Ahmed',
            gender: 'M',
            bloodGroup: 'O+',
            phone: '0551 11 22 33',
            maidenName: '',
            address: 'El Eulma',
            email: '',
            workAddress: '',
            workPhone: '',
            workEmail: '',
            phenotype: '',
            birthDate: '',
            lastDonation: '2026-05-01',
            lastTest: '',
            notes: ''),
        // no phone, name+group match -> merge
        ImportedDonor(
            name: 'ahmed',
            gender: 'M',
            bloodGroup: 'O+',
            phone: '',
            maidenName: '',
            address: '',
            email: '',
            workAddress: '',
            workPhone: '',
            workEmail: '',
            phenotype: '',
            birthDate: '',
            lastDonation: '',
            lastTest: '2026-03-01',
            notes: ''),
        // invalid group -> skipped
        ImportedDonor(
            name: 'Bad Row',
            gender: 'M',
            bloodGroup: 'ZZ',
            phone: '',
            maidenName: '',
            address: '',
            email: '',
            workAddress: '',
            workPhone: '',
            workEmail: '',
            phenotype: '',
            birthDate: '',
            lastDonation: '',
            lastTest: '',
            notes: ''),
      ];

      final (added, updated, skipped) = await db.smartMergeDonors(rows);
      expect(added, 1);
      expect(updated, 2);
      expect(skipped, 1);

      final all = await db.getAllDonors();
      expect(all.length, 2);
      final ahmed = all.firstWhere((d) => d.name == 'Ahmed');
      expect(ahmed.lastDonation, '2026-05-01'); // max kept
      expect(ahmed.lastTest, '2026-03-01'); // filled from third row
      expect(ahmed.address, 'El Eulma');
      expect(ahmed.phone, '0551112233');
      // merged events appended, not duplicated
      final ahmedEvents = await db.getEvents(ahmed.id);
      final donDates = ahmedEvents
          .where((e) => e.eventType == 'donation')
          .map((e) => e.eventDate)
          .toList();
      expect(donDates, containsAll(['2026-01-01', '2026-05-01']));
      expect(donDates.length, 2);
      expect(ahmed.donationCount, 2);
    });

    test('re-importing the same file never duplicates', () async {
      final rows = [
        ImportedDonor(
            name: 'Nadia',
            gender: 'F',
            bloodGroup: 'A+',
            phone: '0559998877',
            maidenName: '',
            address: '',
            email: '',
            workAddress: '',
            workPhone: '',
            workEmail: '',
            phenotype: '',
            birthDate: '',
            lastDonation: '2026-02-01',
            lastTest: '',
            notes: ''),
      ];
      await db.smartMergeDonors(rows);
      await db.smartMergeDonors(rows);
      final all = await db.getAllDonors();
      expect(all.length, 1);
      expect(all.first.donationCount, 1);
    });
  });
}
