import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/domain/eligibility.dart';

void main() {
  group('addMonthsClamped', () {
    test('adds 3 months', () {
      final r = addMonthsClamped(DateTime(2026, 1, 15), 3);
      expect(r.year, 2026);
      expect(r.month, 4);
      expect(r.day, 15);
    });

    test('crosses year', () {
      final r = addMonthsClamped(DateTime(2026, 11, 20), 3);
      expect(r.year, 2027);
      expect(r.month, 2);
      expect(r.day, 20);
    });

    test('clamps Feb 30 to last day of February', () {
      // Nov 30 + 3 = Feb 30 -> Feb 28 (2027 not a leap year)
      final r = addMonthsClamped(DateTime(2026, 11, 30), 3);
      expect(r.year, 2027);
      expect(r.month, 2);
      expect(r.day, 28);
    });

    test('clamps to Feb 29 in a leap year', () {
      final r = addMonthsClamped(DateTime(2027, 11, 30), 3);
      expect(r.year, 2028);
      expect(r.month, 2);
      expect(r.day, 29);
    });

    test('Jan 31 + 1 clamps to Feb 28', () {
      final r = addMonthsClamped(DateTime(2026, 1, 31), 1);
      expect(r.month, 2);
      expect(r.day, 28);
    });
  });

  group('eligibilityStatus', () {
    test('no dates -> none', () {
      expect(
          eligibilityStatus(gender: 'M', lastDonation: '', lastTest: ''), 'none');
    });

    test('male 3 months ago -> due', () {
      final now = DateTime(2026, 10, 20);
      final st = eligibilityStatus(
          gender: 'M', lastDonation: '2026-07-15', lastTest: '', now: now);
      expect(st, 'due');
    });

    test('male 3 months + 3 days -> soon', () {
      final now = DateTime(2026, 10, 20);
      // next eligible Oct 23 -> in 3 days
      final st = eligibilityStatus(
          gender: 'M', lastDonation: '2026-07-23', lastTest: '', now: now);
      expect(st, 'soon');
    });

    test('male 3 months - 10 days -> wait', () {
      final now = DateTime(2026, 10, 20);
      final st = eligibilityStatus(
          gender: 'M', lastDonation: '2026-07-30', lastTest: '', now: now);
      expect(st, 'wait');
    });

    test('female needs 4 months — still waiting at 3', () {
      final now = DateTime(2026, 10, 20);
      final st = eligibilityStatus(
          gender: 'F', lastDonation: '2026-07-15', lastTest: '', now: now);
      expect(st, 'wait');
    });

    test('female 4 months ago -> due', () {
      final now = DateTime(2026, 10, 20);
      final st = eligibilityStatus(
          gender: 'F', lastDonation: '2026-06-15', lastTest: '', now: now);
      expect(st, 'due');
    });

    test('max(lastDonation, lastTest) is the reference', () {
      final now = DateTime(2026, 10, 20);
      // donation old, test recent -> reference = test
      final st = eligibilityStatus(
          gender: 'M',
          lastDonation: '2026-01-01',
          lastTest: '2026-08-20',
          now: now);
      expect(st, 'wait');
    });

    test('test in the past beyond cooldown -> due', () {
      final now = DateTime(2026, 10, 20);
      final st = eligibilityStatus(
          gender: 'M',
          lastDonation: '',
          lastTest: '2026-06-01',
          now: now);
      expect(st, 'due');
    });
  });

  group('date normalization', () {
    test('ISO', () {
      expect(normalizeDate('2026-10-23'), '2026-10-23');
      expect(normalizeDate('2026-1-5'), '2026-01-05');
    });

    test('French formats', () {
      expect(normalizeDate('23/10/2026'), '2026-10-23');
      expect(normalizeDate('23-10-2026'), '2026-10-23');
      expect(normalizeDate('23.10.2026'), '2026-10-23');
      expect(normalizeDate('5/1/2026'), '2026-01-05');
    });

    test('Excel serial numbers', () {
      // Excel day 1 = 1900-01-01; day 25569 = 1970-01-01.
      expect(normalizeDate(45222), '2023-10-23');
      expect(normalizeDate('45222'), '2023-10-23');
      expect(normalizeDate('43831'), '2020-01-01');
    });

    test('invalid dates rejected', () {
      expect(normalizeDate('32/13/2026'), '');
      expect(normalizeDate('hello'), '');
      expect(normalizeDate(''), '');
      expect(normalizeDate(null), '');
      expect(normalizeDate('2026-02-30'), '');
    });

    test('DateTime passthrough', () {
      expect(normalizeDate(DateTime(2026, 3, 7)), '2026-03-07');
    });
  });

  group('display/round-trip', () {
    test('displayDate formats DD/MM/YYYY', () {
      expect(displayDate('2026-10-23'), '23/10/2026');
      expect(displayDate(''), '');
    });

    test('maxIsoDate', () {
      expect(maxIsoDate('2026-01-01', '2026-05-05'), '2026-05-05');
      expect(maxIsoDate('', '2026-05-05'), '2026-05-05');
      expect(maxIsoDate('', ''), '');
    });
  });

  group('normalization helpers', () {
    test('gender', () {
      expect(normalizeGender('femme'), 'F');
      expect(normalizeGender('F'), 'F');
      expect(normalizeGender('أنثى'), 'F');
      expect(normalizeGender('H'), 'M');
      expect(normalizeGender('ذكر'), 'M');
      expect(normalizeGender('M'), 'M');
      expect(normalizeGender(''), 'M');
    });

    test('blood groups', () {
      expect(normalizeBloodGroup(' o + '), 'O+');
      expect(normalizeBloodGroup('ab-'), 'AB-');
      expect(normalizeBloodGroup('XX'), null);
      expect(normalizeBloodGroup(''), null);
    });

    test('phone', () {
      expect(normalizePhone('0551 23 45 67'), '0551234567');
      expect(normalizePhone('+213-551-234-567'), '+213551234567');
      expect(normalizePhone('  '), '');
    });

    test('name', () {
      expect(normalizeName('  AHMED   Ben ali '), 'ahmed ben ali');
    });

    test('splitBloodGroup', () {
      final s = splitBloodGroup('AB-');
      expect(s.abo, 'AB');
      expect(s.rhesus, '-');
      final s2 = splitBloodGroup('O+');
      expect(s2.abo, 'O');
      expect(s2.rhesus, '+');
    });
  });
}
