import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/domain/eligibility.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 1: Dashboard — KPI cards, rule banner, group chart, recent donors.
class DashboardScreen extends StatefulWidget {
  final AppState state;
  final void Function(String screen) onNavigate;
  final void Function({String? donorId}) onEdit;
  const DashboardScreen({
    super.key,
    required this.state,
    required this.onNavigate,
    required this.onEdit,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _statusOf(Donor d) => eligibilityStatus(
    gender: d.gender,
    lastDonation: d.lastDonation,
    lastTest: d.lastTest,
  );

  String t(String key) => tr(widget.state.lang, key);

  @override
  Widget build(BuildContext context) {
    final lang = widget.state.lang;
    return StreamBuilder<List<Donor>>(
      stream: widget.state.db.watchAllDonors(),
      builder: (context, snap) {
        final donors = snap.data ?? const <Donor>[];
        final due = donors.where((d) => _statusOf(d) == 'due').length;
        final soon = donors.where((d) => _statusOf(d) == 'soon').length;
        final byGroup = {for (final g in bloodGroups) g: 0};
        for (final d in donors) {
          byGroup[d.bloodGroup] = (byGroup[d.bloodGroup] ?? 0) + 1;
        }
        final maxCount = byGroup.values.fold(1, (a, b) => a > b ? a : b);
        final recent = donors.take(5).toList();

        return SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      icon: LucideIcons.users,
                      value: '${donors.length}',
                      label: t('total'),
                      color: AppColors.primary,
                      onTap: () => widget.onNavigate('donors'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      icon: LucideIcons.checkCircle,
                      value: '$due',
                      label: t('eligibleNow'),
                      color: AppColors.success,
                      onTap: () => widget.onNavigate('alerts'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      icon: LucideIcons.clock,
                      value: '$soon',
                      label: t('thisWeek'),
                      color: AppColors.warning,
                      onTap: () => widget.onNavigate('alerts'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsetsDirectional.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bloodSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.blood.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.info,
                      size: 18,
                      color: AppColors.blood,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t('rule'),
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.5,
                          color: AppColors.blood,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: AppPanel(
                      title: t('byGroup'),
                      child: _GroupChart(byGroup: byGroup, maxCount: maxCount),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 320,
                      child: AppPanel(
                        title: t('recent'),
                        trailing: TextButton(
                          onPressed: () => widget.onNavigate('donors'),
                          child: Text(t('viewAll')),
                        ),
                        child: recent.isEmpty
                            ? Center(
                                child: Text(
                                  t('noData'),
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: recent.length,
                                itemBuilder: (context, i) {
                                  final d = recent[i];
                                  final st = _statusOf(d);
                                  return ListTile(
                                    dense: true,
                                    leading: BloodGroupCircle(
                                      group: d.bloodGroup,
                                      size: 36,
                                    ),
                                    title: Text(
                                      d.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    trailing: StatusBadge(
                                      status: st,
                                      label: tr(lang, 'st_$st'),
                                    ),
                                    onTap: () => widget.onEdit(donorId: d.id),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _KpiCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupChart extends StatelessWidget {
  final Map<String, int> byGroup;
  final int maxCount;
  const _GroupChart({required this.byGroup, required this.maxCount});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final g in bloodGroups)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 4,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${byGroup[g] ?? 0}',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor: (byGroup[g] ?? 0) / maxCount,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.blood,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  for (final g in bloodGroups)
                    Expanded(
                      child: Center(
                        child: LtrText(
                          g,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
