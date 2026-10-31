import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/services/backup_service.dart';
import '../../core/services/csw_fiche_service.dart';
import '../../core/services/excel_service.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 5: Import/Export — Excel smart-merge import, 2-sheet export,
/// template download, and full .zip backup/restore.
class ImportExportScreen extends StatefulWidget {
  final AppState state;
  const ImportExportScreen({super.key, required this.state});

  @override
  State<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends State<ImportExportScreen> {
  bool _busy = false;

  String get lang => widget.state.lang;
  String t(String key) => tr(lang, key);

  BackupService get _backup =>
      BackupService(db: widget.state.db, paths: widget.state.paths);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: StreamBuilder<int>(
        stream: widget.state.db.watchAllDonors().map((l) => l.length),
        builder: (context, snap) {
          final count = snap.data ?? 0;
          return Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _importPanel()),
                    const SizedBox(width: 16),
                    Expanded(child: _exportPanel(count)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _backupPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget _importPanel() {
    return AppPanel(
      title: t('importX'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsetsDirectional.all(28),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                LucideIcons.fileSpreadsheet,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              child: Text(
                t('importHelp'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.upload, size: 16),
                  label: Text(t('importX')),
                  onPressed: _busy ? null : _import,
                ),
                OutlinedButton.icon(
                  icon: const Icon(LucideIcons.download, size: 16),
                  label: Text(t('template')),
                  onPressed: _busy ? null : _template,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exportPanel(int count) {
    return AppPanel(
      title: t('exportX'),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            Text(
              t('total'),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
              child: Text(
                t('exportHelp'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.download, size: 16),
              label: Text(t('exportX')),
              onPressed: _busy || count == 0 ? null : _export,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(LucideIcons.fileText, size: 16),
              label: Text(t('printBlankFiche')),
              onPressed: _busy ? null : _printBlankFiche,
            ),
          ],
        ),
      ),
    );
  }

  /// Prints one empty CSW fiche for handwriting at the reception desk.
  Future<void> _printBlankFiche() async {
    try {
      final now = DateTime.now().toIso8601String();
      final empty = Donor(
        id: '',
        name: '',
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
        birthPlace: '',
        lastDonation: '',
        lastTest: '',
        notes: '',
        photoFilename: '',
        donationCount: 0,
        createdAt: now,
        updatedAt: now,
      );
      await CswFicheService.printFiche(empty, const [], blank: true);
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    }
  }

  Widget _backupPanel() {
    return AppPanel(
      title: t('backupTitle'),
      fill: false,
      padding: const EdgeInsetsDirectional.all(14),
      child: Column(
        children: [
          Text(
            t('backupHelp'),
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                ),
                icon: const Icon(LucideIcons.save, size: 16),
                label: Text(t('exportBackup')),
                onPressed: _busy ? null : _exportBackup,
              ),
              OutlinedButton.icon(
                icon: const Icon(LucideIcons.rotateCcw, size: 16),
                label: Text(t('restoreBackup')),
                onPressed: _busy ? null : _restoreBackup,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _import() async {
    setState(() => _busy = true);
    try {
      final excel = ExcelService(widget.state.db.getEvents);
      final rows = await excel.pickAndParse();
      if (rows.isEmpty) return;
      // Safety snapshot before bulk import.
      await _backup.autoBackup();
      final (added, updated, skipped) = await widget.state.db.smartMergeDonors(
        rows,
      );
      _snack(
        '${t('imported')} $added ${t('added')}, $updated ${t('updated')}, $skipped ${t('skipped')}',
      );
    } on FileSystemException {
      _snack(t('closeExcel'));
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _template() async {
    try {
      final excel = ExcelService((_) async => []);
      final bytes = await excel.exportTemplate();
      final saved = await FilePicker.saveFile(
        fileName: 'modele_donneurs.xlsx',
        bytes: Uint8List.fromList(bytes),
      );
      if (saved == null) return;
      _snack('${t('exported')}: $saved');
    } on FileSystemException {
      _snack(t('closeExcel'));
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    }
  }

  Future<void> _export() async {
    try {
      final excel = ExcelService(widget.state.db.getEvents);
      final donors = await widget.state.db.getAllDonors();
      final bytes = await excel.exportWorkbook(donors);
      final now = DateTime.now();
      final saved = await FilePicker.saveFile(
        fileName:
            'donneurs_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.xlsx',
        bytes: Uint8List.fromList(bytes),
      );
      if (saved == null) return;
      _snack('${t('exported')}: $saved');
    } on FileSystemException {
      _snack(t('closeExcel'));
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    }
  }

  Future<void> _exportBackup() async {
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      String two(int v) => v.toString().padLeft(2, '0');
      final suggested =
          'cwts_setif_backup_${now.year}-${two(now.month)}-${two(now.day)}.zip';
      final target = await FilePicker.saveFile(
        dialogTitle: suggested,
        fileName: suggested,
        // Placeholder only: the real archive is streamed to disk below.
        bytes: Uint8List(0),
      );
      if (target == null) return;
      await _backup.writeBackupTo(target.toFilePath());
      _snack(t('backupDone'));
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restoreBackup() async {
    // Confirm with the admin password.
    if (!mounted) return;
    final ok = await _passwordGate('restoreBackup');
    if (!ok) return;
    if (!mounted) return;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('restoreBackup')),
        content: Text(t('restoreConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('confirm')),
          ),
        ],
      ),
    );
    if (proceed != true) return;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );
      if (picked?.path == null) return;
      // Reject bad archives while the live DB is still open and untouched.
      await _backup.validateBackup(picked!.path!);
      // Safety snapshot first (DB still open).
      await _backup.autoBackup(prefix: 'pre_restore');
      // Close DB, swap files, reopen (AppState callback remounts the UI).
      await widget.state.db.close();
      try {
        await _backup.restoreFiles(picked.path!);
      } finally {
        // Always reopen, even when the swap failed half-way.
        await widget.state.databaseReplaced();
      }
      _snack(t('restoreDone'));
    } catch (e) {
      _snack('${t('errorOccurred')}: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _passwordGate(String titleKey) async {
    final controller = TextEditingController();
    final settings = widget.state.settings;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t(titleKey)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t('enterPassword')),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              obscureText: true,
              onSubmitted: (_) => Navigator.pop(ctx, true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.destructive,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('confirm')),
          ),
        ],
      ),
    );
    if (ok != true) return false;
    return widget.state.db.login(settings.username, controller.text);
  }
}
