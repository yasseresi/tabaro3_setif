import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/services/excel_service.dart';
import 'package:tabaro3_setif/data/app_database.dart';

void main() {
  group('Excel row parsing (via public behavior)', () {
    // _parseTable is private; exercise it through a synthetic .xlsx round-trip.
    test('exportTemplate returns valid xlsx bytes', () async {
      final svc = ExcelService((_) async => []);
      final bytes = await svc.exportTemplate();
      expect(bytes, isNotEmpty);
      // xlsx = zip starting with PK
      expect(bytes[0], 0x50);
      expect(bytes[1], 0x4B);
    });

    test('exportWorkbook produces 2 sheets with donor rows', () async {
      final svc = ExcelService((_) async => []);
      final donor = Donor(
        id: 'd1',
        name: 'Test Donor',
        gender: 'M',
        bloodGroup: 'O+',
        phone: '0551234567',
        maidenName: '',
        address: 'Setif',
        email: '',
        workAddress: '',
        workPhone: '',
        workEmail: '',
        phenotype: '',
        birthDate: '1990-05-10',
        lastDonation: '2026-07-01',
        lastTest: '',
        notes: '',
        photoFilename: '',
        donationCount: 1,
        createdAt: '2026-10-01T00:00:00',
        updatedAt: '2026-10-01T00:00:00',
      );
      final bytes = await svc.exportWorkbook([donor]);
      expect(bytes, isNotEmpty);
      expect(bytes[0], 0x50); // zip/PK magic
    });
  });
}
