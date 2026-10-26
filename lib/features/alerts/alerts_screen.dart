import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/app_state.dart';
import '../../core/domain/eligibility.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/services/photo_service.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 4: Alerts — donors due or due soon, most overdue first.
class AlertsScreen extends StatefulWidget {
  final AppState state;
  final void Function({String? donorId}) onEdit;
  const AlertsScreen({super.key, required this.state, required this.onEdit});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
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
        final donors =
            (snap.data ?? const <Donor>[])
                .where((d) => isAlertStatus(_statusOf(d)))
                .toList()
              ..sort((a, b) {
                final na =
                    nextEligibleDate(
                      gender: a.gender,
                      lastDonation: a.lastDonation,
                      lastTest: a.lastTest,
                    ) ??
                    DateTime(9999);
                final nb =
                    nextEligibleDate(
                      gender: b.gender,
                      lastDonation: b.lastDonation,
                      lastTest: b.lastTest,
                    ) ??
                    DateTime(9999);
                return na.compareTo(nb);
              });

        return Padding(
          padding: const EdgeInsetsDirectional.all(20),
          child: AppPanel(
            title: t('alertsTitle'),
            child: donors.isEmpty
                ? Center(
                    child: Text(
                      t('noAlerts'),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: donors.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, i) {
                      final d = donors[i];
                      final st = _statusOf(d);
                      final next = nextEligibleDate(
                        gender: d.gender,
                        lastDonation: d.lastDonation,
                        lastTest: d.lastTest,
                      );
                      final ref = referenceDate(d.lastDonation, d.lastTest);
                      return Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            BloodGroupCircle(group: d.bloodGroup, size: 44),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () => widget.onEdit(donorId: d.id),
                                    child: Text(
                                      d.name,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${d.gender == 'M' ? tr(lang, 'male') : tr(lang, 'female')} · '
                                    '${t('lastDonation')}: ${ref == null ? '—' : displayDate(isoDate(ref))} · '
                                    '${t('nextEligible')}: ${next == null ? '—' : displayDate(isoDate(next))}',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: st, label: tr(lang, 'st_$st')),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: const Icon(LucideIcons.phone, size: 15),
                              label: Text(t('call')),
                              onPressed: () => _call(d),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.success,
                              ),
                              icon: const Icon(LucideIcons.droplet, size: 15),
                              label: Text(t('markDonated')),
                              onPressed: () => _markDonated(d),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Future<void> _call(Donor d) async {
    await copyPhoneToClipboard(d.phone);
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${t('dialThisNumber')} — ${d.name}'),
        content: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            d.phone,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('cancel')),
          ),
        ],
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t('phoneCopied'))));
    }
  }

  Future<void> _markDonated(Donor d) async {
    final today = isoDate(DateTime.now());
    await widget.state.db.recordEvent(
      donorId: d.id,
      eventType: 'donation',
      eventDate: today,
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t('saved'))));
    }
  }
}
