import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabaro3_setif/core/app_state.dart';
import 'package:tabaro3_setif/core/services/storage_paths.dart';
import 'package:tabaro3_setif/data/app_database.dart';
import 'package:tabaro3_setif/features/auth/login_screen.dart';
import 'package:tabaro3_setif/features/donors/donor_form_screen.dart';

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    state = AppState(
        db: db,
        paths: _FakePaths(),
        settings: _settingRow(db: db));
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('login screen: bad credentials show error, good ones succeed',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(state: state, onSuccess: () {}),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('اسم المستخدم أو كلمة المرور غير صحيحة'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'admin');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('اسم المستخدم أو كلمة المرور غير صحيحة'), findsNothing);
  });

  testWidgets('donor form: saving without name/group shows required message',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DonorFormScreen(state: state, donorId: null, onClose: () {}),
      ),
    ));
    await tester.pumpAndSettle();

    // No name, no group -> Save shows the validation snackbar.
    await tester.ensureVisible(find.text('حفظ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حفظ'));
    await tester.pump();
    expect(find.text('الاسم وزمرة الدم مطلوبان'), findsOneWidget);
  });

  testWidgets('donor form: full save flow persists a donor', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DonorFormScreen(
          state: state,
          donorId: null,
          onClose: () {},
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'ياسين عماري');
    // Pick blood group O+
    await tester.tap(find.text('O+'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('حفظ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حفظ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final donors = await db.getAllDonors();
    expect(donors.length, 1);
    expect(donors.first.name, 'ياسين عماري');
    expect(donors.first.bloodGroup, 'O+');
    expect(donors.first.gender, 'M');

    // After saving, the history card subscribes to a Drift stream; closing
    // the DB here flushes Drift's internal cache timer before the tree is
    // disposed (per Drift's guidance for widget tests).
    await db.close();
  });
}

AppSetting _settingRow({required AppDatabase db}) => AppSetting(
      id: 1,
      username: 'admin',
      passwordHash: '',
      isDefaultPassword: true,
      language: 'ar',
      notificationsEnabled: true,
      notifiedJson: '{}',
    );

class _FakePaths implements StoragePaths {
  @override
  Directory get backups => Directory.systemTemp;

  @override
  String get dbFile => Directory.systemTemp.path;

  @override
  Directory get photos => Directory.systemTemp;

  @override
  Directory get root => Directory.systemTemp;
}
