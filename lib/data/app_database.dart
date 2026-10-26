import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:uuid/uuid.dart';

import '../core/domain/eligibility.dart';

part 'app_database.g.dart';

/// Donors table — identity + latest eligibility reference dates.
class Donors extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get gender => text()(); // 'M' | 'F'
  TextColumn get bloodGroup => text()(); // A+..O-
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get maidenName => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get workAddress => text().withDefault(const Constant(''))();
  TextColumn get workPhone => text().withDefault(const Constant(''))();
  TextColumn get workEmail => text().withDefault(const Constant(''))();
  TextColumn get phenotype => text().withDefault(const Constant(''))();
  TextColumn get birthDate =>
      text().withDefault(const Constant(''))(); // YYYY-MM-DD
  TextColumn get lastDonation => text().withDefault(const Constant(''))();
  TextColumn get lastTest => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get photoFilename => text().withDefault(const Constant(''))();
  IntColumn get donationCount => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Historical donations & blood tests per donor (rows of the CSW fiche table).
class DonationEvents extends Table {
  TextColumn get id => text()();
  TextColumn get donorId => text()();
  TextColumn get eventType => text()(); // 'donation' | 'test'
  TextColumn get eventDate => text()(); // YYYY-MM-DD
  TextColumn get ta =>
      text().withDefault(const Constant(''))(); // tension artérielle
  TextColumn get weight =>
      text().withDefault(const Constant(''))(); // poids (kg)
  TextColumn get donationType =>
      text().withDefault(const Constant(''))(); // type de don
  TextColumn get bilan => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(
    const Constant(''),
  )(); // contre-indications & observations
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE',
  ];
}

/// Single-row app configuration (id always 1).
class AppSettings extends Table {
  IntColumn get id => integer()();
  TextColumn get username => text().withDefault(const Constant('admin'))();
  TextColumn get passwordHash => text().withDefault(const Constant(''))();
  BoolColumn get isDefaultPassword =>
      boolean().withDefault(const Constant(true))();
  TextColumn get language => text().withDefault(const Constant('ar'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get notifiedJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Donors, DonationEvents, AppSettings])
class AppDatabase extends _$AppDatabase {
  /// [dbFilePath]: absolute path of the SQLite file (resolved in main()).
  AppDatabase(String dbFilePath)
    : super(NativeDatabase(File(dbFilePath), logStatements: false));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_donors_name ON donors(name)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_donors_phone ON donors(phone)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_events_donor ON donation_events(donor_id)',
      );
      // Create the settings row only if missing — never overwrite the
      // admin password hash on restart.
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          id: const Value(1),
          passwordHash: Value(SettingsAuth.hashPassword('admin')),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    },
  );

  // ---- Auth ------------------------------------------------------------

  Future<bool> login(String username, String password) async {
    final row = await getAppSettings();
    return row.username == username.trim() &&
        row.passwordHash == SettingsAuth.hashPassword(password);
  }

  Future<AppSetting> getAppSettings() =>
      (select(appSettings)..where((s) => s.id.equals(1))).getSingle();

  Future<void> updateAccount(String username, String? newPassword) async {
    await (update(appSettings)..where((s) => s.id.equals(1))).write(
      AppSettingsCompanion(
        username: Value(username.trim()),
        passwordHash: newPassword == null || newPassword.isEmpty
            ? const Value.absent()
            : Value(SettingsAuth.hashPassword(newPassword)),
        isDefaultPassword: newPassword == null || newPassword.isEmpty
            ? const Value.absent()
            : const Value(false),
      ),
    );
  }

  Future<void> updateSettings(AppSettingsCompanion entry) =>
      (update(appSettings)..where((s) => s.id.equals(1))).write(entry);

  // ---- Donors CRUD ------------------------------------------------------

  Stream<List<Donor>> watchAllDonors() => (select(
    donors,
  )..orderBy([(d) => OrderingTerm.desc(d.createdAt)])).watch();

  /// Count of donors currently 'due' (eligible to donate) — sidebar badge.
  Stream<int> dueCountStream() => watchAllDonors().map(
    (list) => list
        .where(
          (d) =>
              eligibilityStatus(
                gender: d.gender,
                lastDonation: d.lastDonation,
                lastTest: d.lastTest,
              ) ==
              'due',
        )
        .length,
  );

  Future<List<Donor>> getAllDonors() => select(donors).get();

  Future<Donor> getDonor(String id) =>
      (select(donors)..where((d) => d.id.equals(id))).getSingle();

  Future<void> insertDonor(DonorsCompanion entry) => into(donors).insert(entry);

  Future<void> insertDonorData(Donor donor) => into(donors).insert(donor);

  Future<bool> updateDonor(Donor donor) =>
      update(donors).replace(donor.copyWith(updatedAt: _nowIso()));

  Future<int> deleteDonor(String id) =>
      (delete(donors)..where((d) => d.id.equals(id))).go();

  Future<void> deleteAllData() async {
    await delete(donationEvents).go();
    await delete(donors).go();
  }

  // ---- Donation events (transactional invariant) ------------------------

  Stream<List<DonationEvent>> watchEvents(String donorId) =>
      (select(donationEvents)
            ..where((e) => e.donorId.equals(donorId))
            ..orderBy([
              (e) => OrderingTerm(expression: e.eventDate),
              (e) => OrderingTerm(expression: e.createdAt),
            ]))
          .watch();

  Future<List<DonationEvent>> getEvents(String donorId) =>
      (select(donationEvents)..where((e) => e.donorId.equals(donorId))).get();

  /// Records a donation or test: inserts the event and recomputes the donor's
  /// lastDonation / lastTest / donationCount in one SQLite transaction.
  Future<void> recordEvent({
    required String donorId,
    required String eventType, // 'donation' | 'test'
    required String eventDate, // YYYY-MM-DD
    String ta = '',
    String weight = '',
    String donationType = '',
    String bilan = '',
    String notes = '',
  }) async {
    await transaction(() async {
      final donor = await getDonor(donorId);
      final existing =
          await (select(donationEvents)..where(
                (e) =>
                    e.donorId.equals(donorId) &
                    e.eventType.equals(eventType) &
                    e.eventDate.equals(eventDate),
              ))
              .getSingleOrNull();
      if (existing == null) {
        await into(donationEvents).insert(
          DonationEventsCompanion.insert(
            id: _uuid(),
            donorId: donorId,
            eventType: eventType,
            eventDate: eventDate,
            ta: Value(ta),
            weight: Value(weight),
            donationType: Value(donationType),
            bilan: Value(bilan),
            notes: Value(notes),
            createdAt: _nowIso(),
          ),
        );
      } else {
        await (update(
          donationEvents,
        )..where((e) => e.id.equals(existing.id))).write(
          DonationEventsCompanion(
            ta: Value(ta.isEmpty ? existing.ta : ta),
            weight: Value(weight.isEmpty ? existing.weight : weight),
            donationType: Value(
              donationType.isEmpty ? existing.donationType : donationType,
            ),
            bilan: Value(bilan.isEmpty ? existing.bilan : bilan),
            notes: Value(notes.isEmpty ? existing.notes : notes),
          ),
        );
      }
      final donationDate = eventType == 'donation'
          ? eventDate
          : donor.lastDonation;
      final testDate = eventType == 'test' ? eventDate : donor.lastTest;
      final donations =
          await (select(donationEvents)..where(
                (e) =>
                    e.donorId.equals(donorId) & e.eventType.equals('donation'),
              ))
              .get();
      await (update(donors)..where((d) => d.id.equals(donorId))).write(
        DonorsCompanion(
          lastDonation: Value(maxIsoDate(donor.lastDonation, donationDate)),
          lastTest: Value(maxIsoDate(donor.lastTest, testDate)),
          donationCount: Value(donations.length),
          updatedAt: Value(_nowIso()),
        ),
      );
    });
  }

  /// Removes one event and recomputes the donor's summary fields.
  Future<void> deleteEvent(String eventId) async {
    await transaction(() async {
      final event = await (select(
        donationEvents,
      )..where((e) => e.id.equals(eventId))).getSingle();
      await (delete(donationEvents)..where((e) => e.id.equals(eventId))).go();
      await _recomputeDonor(event.donorId);
    });
  }

  Future<void> _recomputeDonor(String donorId) async {
    final events = await getEvents(donorId);
    final donations = events.where((e) => e.eventType == 'donation').toList();
    final tests = events.where((e) => e.eventType == 'test').toList();
    String maxDate(List<DonationEvent> list) =>
        list.map((e) => e.eventDate).fold('', maxIsoDate);
    await (update(donors)..where((d) => d.id.equals(donorId))).write(
      DonorsCompanion(
        lastDonation: Value(maxDate(donations)),
        lastTest: Value(maxDate(tests)),
        donationCount: Value(donations.length),
        updatedAt: Value(_nowIso()),
      ),
    );
  }

  // ---- Smart-merge import (Excel/CSV) ------------------------------------

  /// Returns (added, updated, skipped). Matches by normalized phone, or
  /// normalized name + blood group when the imported row has no phone;
  /// merges non-empty fields and keeps the latest dates. Appends new events.
  Future<(int, int, int)> smartMergeDonors(List<ImportedDonor> rows) async {
    var added = 0, updated = 0, skipped = 0;
    await transaction(() async {
      final all = await select(donors).get();
      final byPhone = <String, Donor>{
        for (final d in all)
          if (normalizePhone(d.phone).length >= 4) normalizePhone(d.phone): d,
      };
      final byNameGroup = <String, Donor>{
        for (final d in all) '${normalizeName(d.name)}|${d.bloodGroup}': d,
      };
      for (final row in rows) {
        String? insertedId, mergedId;
        final name = normalizeName(row.name);
        final group = normalizeBloodGroup(row.bloodGroup);
        if (name.isEmpty || group == null) {
          skipped++;
          continue;
        }
        final phone = normalizePhone(row.phone);
        final match = phone.length >= 4
            ? (byPhone[phone] ?? byNameGroup['$name|$group'])
            : byNameGroup['$name|$group'];
        if (match == null) {
          final donor = Donor(
            id: _uuid(),
            name: row.name.trim(),
            gender: row.gender,
            bloodGroup: group,
            phone: phone,
            maidenName: row.maidenName,
            address: row.address,
            email: row.email,
            workAddress: row.workAddress,
            workPhone: row.workPhone,
            workEmail: row.workEmail,
            phenotype: row.phenotype,
            birthDate: row.birthDate,
            lastDonation: row.lastDonation,
            lastTest: row.lastTest,
            notes: row.notes,
            photoFilename: '',
            donationCount: 0,
            createdAt: _nowIso(),
            updatedAt: _nowIso(),
          );
          await into(donors).insert(donor);
          added++;
          if (row.lastDonation.isNotEmpty) {
            await _addEventIfNew(donor.id, 'donation', row.lastDonation);
          }
          if (row.lastTest.isNotEmpty) {
            await _addEventIfNew(donor.id, 'test', row.lastTest);
          }
          insertedId = donor.id;
        } else {
          mergedId = match.id;
          await (update(donors)..where((d) => d.id.equals(match.id))).write(
            DonorsCompanion(
              // Canonical DB name is kept — matching is case-insensitive and
              // an import row must not degrade the stored display name.
              phone: match.phone.isEmpty ? Value(phone) : const Value.absent(),
              address: match.address.isEmpty
                  ? Value(row.address)
                  : const Value.absent(),
              email: match.email.isEmpty
                  ? Value(row.email)
                  : const Value.absent(),
              maidenName: match.maidenName.isEmpty
                  ? Value(row.maidenName)
                  : const Value.absent(),
              workAddress: match.workAddress.isEmpty
                  ? Value(row.workAddress)
                  : const Value.absent(),
              workPhone: match.workPhone.isEmpty
                  ? Value(row.workPhone)
                  : const Value.absent(),
              workEmail: match.workEmail.isEmpty
                  ? Value(row.workEmail)
                  : const Value.absent(),
              phenotype: match.phenotype.isEmpty
                  ? Value(row.phenotype)
                  : const Value.absent(),
              birthDate: match.birthDate.isEmpty
                  ? Value(row.birthDate)
                  : const Value.absent(),
              notes: match.notes.isEmpty
                  ? Value(row.notes)
                  : const Value.absent(),
              lastDonation: Value(
                maxIsoDate(match.lastDonation, row.lastDonation),
              ),
              lastTest: Value(maxIsoDate(match.lastTest, row.lastTest)),
              updatedAt: Value(_nowIso()),
            ),
          );
          if (row.lastDonation.isNotEmpty &&
              row.lastDonation.compareTo(match.lastDonation) > 0) {
            await _addEventIfNew(match.id, 'donation', row.lastDonation);
          }
          if (row.lastTest.isNotEmpty &&
              row.lastTest.compareTo(match.lastTest) > 0) {
            await _addEventIfNew(match.id, 'test', row.lastTest);
          }
          updated++;
        }
        // Refresh the in-memory index so a later row matching the same donor
        // never writes back stale dates from the pre-merge snapshot.
        final fresh = await (select(
          donors,
        )..where((d) => d.id.equals(mergedId ?? insertedId!))).getSingle();
        if (normalizePhone(fresh.phone).length >= 4) {
          byPhone[normalizePhone(fresh.phone)] = fresh;
        }
        byNameGroup['${normalizeName(fresh.name)}|${fresh.bloodGroup}'] = fresh;
      }
      await _recomputeCounts();
    });
    return (added, updated, skipped);
  }

  Future<void> _addEventIfNew(String donorId, String type, String date) async {
    final existing =
        await (select(donationEvents)..where(
              (e) =>
                  e.donorId.equals(donorId) &
                  e.eventType.equals(type) &
                  e.eventDate.equals(date),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await into(donationEvents).insert(
        DonationEventsCompanion.insert(
          id: _uuid(),
          donorId: donorId,
          eventType: type,
          eventDate: date,
          createdAt: _nowIso(),
        ),
      );
    }
  }

  Future<void> _recomputeCounts() async {
    final counts = await customSelect(
      "SELECT donor_id, COUNT(*) AS c FROM donation_events WHERE event_type = 'donation' GROUP BY donor_id",
      readsFrom: {donationEvents},
    ).get();
    for (final row in counts) {
      await (update(donors)
            ..where((d) => d.id.equals(row.read<String>('donor_id'))))
          .write(DonorsCompanion(donationCount: Value(row.read<int>('c'))));
    }
  }

  static String _nowIso() => DateTime.now().toIso8601String();

  static String _uuid() => const Uuid().v4();
}

/// Row shape used by smart-merge before touching the DB.
class ImportedDonor {
  final String name, gender, bloodGroup, phone, maidenName, address, email;
  final String workAddress, workPhone, workEmail, phenotype;
  final String birthDate, lastDonation, lastTest, notes;
  ImportedDonor({
    required this.name,
    required this.gender,
    required this.bloodGroup,
    required this.phone,
    required this.maidenName,
    required this.address,
    required this.email,
    required this.workAddress,
    required this.workPhone,
    required this.workEmail,
    required this.phenotype,
    required this.birthDate,
    required this.lastDonation,
    required this.lastTest,
    required this.notes,
  });
}

/// Salted SHA-256 helper for the local admin password.
class SettingsAuth {
  SettingsAuth._();
  static const _salt = 'CWTS-Setif-2026';
  static String hashPassword(String password) =>
      sha256.convert(utf8.encode('$_salt:$password')).toString();
}
