import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/domain/eligibility.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/services/csw_fiche_service.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 2: Donors list — search, filters, table, pagination (10/page).
class DonorsListScreen extends StatefulWidget {
  final AppState state;
  final void Function({String? donorId}) onEdit;
  const DonorsListScreen({
    super.key,
    required this.state,
    required this.onEdit,
  });

  @override
  State<DonorsListScreen> createState() => _DonorsListScreenState();
}

class _DonorsListScreenState extends State<DonorsListScreen> {
  String _query = '';
  String? _group;
  String? _status;
  int _page = 0;
  static const _pageSize = 10;

  String get lang => widget.state.lang;
  String t(String key) => tr(lang, key);

  String _statusOf(Donor d) => eligibilityStatus(
    gender: d.gender,
    lastDonation: d.lastDonation,
    lastTest: d.lastTest,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Donor>>(
      stream: widget.state.db.watchAllDonors(),
      builder: (context, snap) {
        final all = snap.data ?? const <Donor>[];
        final q = _query.trim().toLowerCase();
        final filtered = all.where((d) {
          if (q.isNotEmpty &&
              !d.name.toLowerCase().contains(q) &&
              !d.phone.contains(q)) {
            return false;
          }
          if (_group != null && d.bloodGroup != _group) return false;
          if (_status != null && _statusOf(d) != _status) return false;
          return true;
        }).toList();
        // Most overdue first for planning; plain creation order otherwise.
        final pages = (filtered.length / _pageSize).ceil().clamp(1, 1 << 31);
        if (_page >= pages) _page = pages - 1;
        final pageItems = filtered
            .skip(_page * _pageSize)
            .take(_pageSize)
            .toList();

        return Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: AppPanel(
            title: t('donors'),
            child: Column(
              children: [
                _filterBar(),
                const SizedBox(height: 10),
                Expanded(
                  child: pageItems.isEmpty
                      ? Center(
                          child: Text(
                            t('noData'),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            _table(pageItems),
                            const SizedBox(height: 8),
                            _footer(filtered.length, pages),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterBar() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: (v) => setState(() {
              _query = v;
              _page = 0;
            }),
            decoration:
                InputDecoration(
                  prefixIcon: const Icon(LucideIcons.search, size: 18),
                  hintText: t('search'),
                ).copyWith(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _group,
            hint: LtrText(t('all')),
            items: [
              DropdownMenuItem(value: null, child: LtrText(t('all'))),
              ...bloodGroups.map(
                (g) =>
                    DropdownMenuItem(value: g, child: LtrText(g, bold: true)),
              ),
            ],
            onChanged: (v) => setState(() {
              _group = v;
              _page = 0;
            }),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _status,
            hint: Text(t('all')),
            items: [
              DropdownMenuItem(value: null, child: Text(t('all'))),
              ...['due', 'soon', 'wait', 'none'].map(
                (s) =>
                    DropdownMenuItem(value: s, child: Text(tr(lang, 'st_$s'))),
              ),
            ],
            onChanged: (v) => setState(() {
              _status = v;
              _page = 0;
            }),
          ),
        ),
      ],
    );
  }

  Widget _table(List<Donor> items) {
    final rows = items.map((d) {
      final st = _statusOf(d);
      return DataRow(
        cells: [
          DataCell(
            Text(
              d.name,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          DataCell(
            Text(
              d.gender == 'M' ? tr(lang, 'male') : tr(lang, 'female'),
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5),
            ),
          ),
          DataCell(
            LtrText(
              d.bloodGroup,
              bold: true,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.blood,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          DataCell(LtrText(d.phone.isEmpty ? '—' : d.phone)),
          DataCell(
            Text(
              displayDate(d.lastDonation).isEmpty
                  ? '—'
                  : displayDate(d.lastDonation),
            ),
          ),
          DataCell(Text(_nextDate(d).isEmpty ? '—' : _nextDate(d))),
          DataCell(StatusBadge(status: st, label: tr(lang, 'st_$st'))),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: t('edit'),
                  icon: const Icon(LucideIcons.pencil, size: 17),
                  onPressed: () => widget.onEdit(donorId: d.id),
                ),
                IconButton(
                  tooltip: t('cswFiche'),
                  icon: const Icon(LucideIcons.fileText, size: 17),
                  onPressed: () async {
                    final events = await widget.state.db.getEvents(d.id);
                    await CswFicheService.printFiche(d, events);
                  },
                ),
                IconButton(
                  tooltip: t('delete'),
                  icon: const Icon(
                    LucideIcons.trash2,
                    size: 17,
                    color: AppColors.destructive,
                  ),
                  onPressed: () => _confirmDelete(d),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(AppColors.muted),
          columnSpacing: 18,
          columns: [
            DataColumn(label: Text(t('name'))),
            DataColumn(label: Text(t('gender'))),
            DataColumn(label: Text(t('bloodGroup'))),
            DataColumn(label: Text(t('phone'))),
            DataColumn(label: Text(t('lastDonation'))),
            DataColumn(label: Text(t('nextEligible'))),
            DataColumn(label: Text(t('status'))),
            DataColumn(label: Text(t('actions'))),
          ],
          rows: rows,
        ),
      ),
    );
  }

  String _nextDate(Donor d) {
    final next = nextEligibleDate(
      gender: d.gender,
      lastDonation: d.lastDonation,
      lastTest: d.lastTest,
    );
    return next == null ? '' : displayDate(isoDate(next));
  }

  Widget _footer(int count, int pages) {
    return Row(
      children: [
        Text(
          '${t('records')}: $count',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: _page > 0 ? () => setState(() => _page--) : null,
          icon: const Icon(LucideIcons.chevronLeft, size: 18),
        ),
        Text(
          '${t('page')} ${_page + 1} / $pages',
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
        ),
        IconButton(
          onPressed: _page < pages - 1 ? () => setState(() => _page++) : null,
          icon: const Icon(LucideIcons.chevronRight, size: 18),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(Donor d) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t('confirmDel')),
        content: Text(d.name, style: const TextStyle(fontFamily: 'Cairo')),
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
            child: Text(t('delete')),
          ),
        ],
      ),
    );
    if (ok == true) {
      await widget.state.db.deleteDonor(d.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t('deleted'))));
      }
    }
  }
}
