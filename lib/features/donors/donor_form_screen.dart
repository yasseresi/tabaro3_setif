import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/app_state.dart';
import '../../core/domain/eligibility.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_strings.dart';
import '../../core/services/csw_fiche_service.dart';
import '../../core/services/pdf_card_service.dart';
import '../../core/services/photo_service.dart';
import '../../core/widgets/shared.dart';
import '../../data/app_database.dart';

/// Screen 3: Add/Edit donor — form + photo + live eligibility + history.
class DonorFormScreen extends StatefulWidget {
  final AppState state;
  final String? donorId; // null = new donor
  final VoidCallback onClose;
  const DonorFormScreen({
    super.key,
    required this.state,
    required this.donorId,
    required this.onClose,
  });

  @override
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _name = TextEditingController();
  final _maiden = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _workAddress = TextEditingController();
  final _workPhone = TextEditingController();
  final _workEmail = TextEditingController();
  final _phenotype = TextEditingController();
  final _birth = TextEditingController();
  final _birthPlace = TextEditingController();
  final _lastDonation = TextEditingController();
  final _lastTest = TextEditingController();
  final _notes = TextEditingController();

  String _gender = 'M';
  String? _group;
  String _photo = '';
  bool _loaded = false;
  bool _busy = false;
  bool _showGroupError = false;
  final _formKey = GlobalKey<FormState>();
  String? _donorId;

  PhotoService get _photos => PhotoService(paths: widget.state.paths);

  String get lang => widget.state.lang;
  String t(String key) => tr(lang, key);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.donorId;
    if (id != null) {
      final d = await widget.state.db.getDonor(id);
      _donorId = d.id;
      _name.text = d.name;
      _maiden.text = d.maidenName;
      _phone.text = d.phone;
      _address.text = d.address;
      _email.text = d.email;
      _workAddress.text = d.workAddress;
      _workPhone.text = d.workPhone;
      _workEmail.text = d.workEmail;
      _phenotype.text = d.phenotype;
      _birth.text = displayDate(d.birthDate);
      _birthPlace.text = d.birthPlace;
      _lastDonation.text = displayDate(d.lastDonation);
      _lastTest.text = displayDate(d.lastTest);
      _notes.text = d.notes;
      _gender = d.gender;
      _group = d.bloodGroup;
      _photo = d.photoFilename;
    }
    if (mounted) setState(() => _loaded = true);
  }

  List<int>? _pendingPhotoBytes;
  List<int>? _previewBytes;

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    setState(() => _showGroupError = _group == null);
    if (!valid || _group == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final id = _donorId ?? const Uuid().v4();
      final existing = _donorId == null
          ? null
          : await widget.state.db.getDonor(_donorId!);
      final donor = Donor(
        id: id,
        name: _name.text.trim(),
        gender: _gender,
        bloodGroup: _group!,
        phone: _phone.text.trim(),
        maidenName: _maiden.text.trim(),
        address: _address.text.trim(),
        email: _email.text.trim(),
        workAddress: _workAddress.text.trim(),
        workPhone: _workPhone.text.trim(),
        workEmail: _workEmail.text.trim(),
        phenotype: _phenotype.text.trim(),
        birthDate: normalizeDate(_birth.text),
        birthPlace: _birthPlace.text.trim(),
        lastDonation: existing?.lastDonation ?? '',
        lastTest: existing?.lastTest ?? '',
        notes: _notes.text.trim(),
        photoFilename: _photo,
        donationCount: existing?.donationCount ?? 0,
        createdAt: existing?.createdAt ?? DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      if (existing == null) {
        await widget.state.db.insertDonorData(donor);
      } else {
        await widget.state.db.updateDonor(donor);
      }
      _donorId = id;
      await _linkPhoto(id);

      // Date edits (set, correct or clear) keep donation_events in sync.
      for (final (type, text, old) in [
        ('donation', _lastDonation.text, existing?.lastDonation ?? ''),
        ('test', _lastTest.text, existing?.lastTest ?? ''),
      ]) {
        final date = normalizeDate(text);
        if (date != old) {
          await widget.state.db.replaceLastEvent(
            donorId: id,
            eventType: type,
            oldDate: old,
            newDate: date,
          );
        }
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t('saved'))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// New donors get a photo picked before first save; copy it in after insert.
  Future<void> _linkPhoto(String donorId) async {
    if (_pendingPhotoBytes != null) {
      final name = await _photos.store(donorId, _pendingPhotoBytes!);
      setState(() {
        _photo = name;
        _pendingPhotoBytes = null;
      });
      final d = await widget.state.db.getDonor(donorId);
      await widget.state.db.updateDonor(d.copyWith(photoFilename: name));
    }
  }

  Future<void> _pickPhoto() async {
    final bytes = await _photos.pickBytes();
    if (bytes == null) return;
    // Staged in memory; written to disk only on Save so Cancel undoes it.
    setState(() {
      _pendingPhotoBytes = bytes;
      _previewBytes = bytes;
    });
  }

  Future<void> _clearForm() async {
    _formKey.currentState?.reset();
    for (final c in [
      _name,
      _maiden,
      _phone,
      _address,
      _email,
      _workAddress,
      _workPhone,
      _workEmail,
      _phenotype,
      _birth,
      _birthPlace,
      _lastDonation,
      _lastTest,
      _notes,
    ]) {
      c.clear();
    }
    setState(() {
      _gender = 'M';
      _group = null;
      _showGroupError = false;
      _photo = '';
      _pendingPhotoBytes = null;
      _previewBytes = null;
      _donorId = null;
    });
  }

  // ---- Live eligibility preview -----------------------------------------

  ({String date, String status}) get _live {
    final next = nextEligibleDate(
      gender: _gender,
      lastDonation: normalizeDate(_lastDonation.text),
      lastTest: normalizeDate(_lastTest.text),
    );
    final st = eligibilityStatus(
      gender: _gender,
      lastDonation: normalizeDate(_lastDonation.text),
      lastTest: normalizeDate(_lastTest.text),
    );
    return (date: next == null ? '' : displayDate(isoDate(next)), status: st);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final live = _live;
    return Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: AppPanel(
        title: _donorId == null ? t('addDonor') : t('editDonor'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _formColumn()),
            const SizedBox(width: 16),
            SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _photoBox(),
                  const SizedBox(height: 12),
                  _eligibilityCard(live),
                  if (_donorId != null) ...[
                    const SizedBox(height: 12),
                    Expanded(child: _historyCard()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formColumn() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label(t('name')),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(hintText: t('name')),
              validator: (value) => value == null || value.trim().isEmpty
                  ? t('requiredField')
                  : null,
            ),
            _label(t('maidenName')),
            TextFormField(controller: _maiden),
            const SizedBox(height: 10),
            _label(t('gender')),
            Row(
              children: [
                _genderToggle('M'),
                const SizedBox(width: 8),
                _genderToggle('F'),
              ],
            ),
            const SizedBox(height: 10),
            _label(t('bloodGroup')),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [for (final g in bloodGroups) _groupButton(g)],
            ),
            if (_showGroupError)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 4),
                child: Text(
                  t('requiredField'),
                  style: const TextStyle(
                    color: AppColors.destructive,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            _label(t('birthDate')),
            TextFormField(
              controller: _birth,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(hintText: t('dateHint')),
              validator: _dateValidator,
            ),
            _label(t('birthPlace')),
            TextFormField(controller: _birthPlace),
            const SizedBox(height: 10),
            _label(t('homeAddress')),
            TextFormField(controller: _address, maxLines: 2, minLines: 1),
            _label(t('homeContact')),
            _label(t('homePhone')),
            TextFormField(
              controller: _phone,
              textDirection: TextDirection.ltr,
              maxLength: 15,
              decoration: const InputDecoration(counterText: ''),
              validator: _phoneValidator,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d+\s]')),
              ],
            ),
            _label(t('homeEmail')),
            TextFormField(
              controller: _email,
              textDirection: TextDirection.ltr,
              validator: _emailValidator,
            ),
            const SizedBox(height: 10),
            _label(t('workContact')),
            _label(t('workAddress')),
            TextFormField(controller: _workAddress, maxLines: 2, minLines: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(t('workPhone')),
                      TextFormField(
                        controller: _workPhone,
                        textDirection: TextDirection.ltr,
                        maxLength: 15,
                        decoration: const InputDecoration(counterText: ''),
                        validator: _phoneValidator,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d+\s]')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(t('workEmail')),
                      TextFormField(
                        controller: _workEmail,
                        textDirection: TextDirection.ltr,
                        validator: _emailValidator,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(t('lastDonation')),
                      _dateField(_lastDonation),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_label(t('lastTest')), _dateField(_lastTest)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _label(t('phenotype')),
            TextFormField(controller: _phenotype),
            _label(t('notes')),
            TextFormField(controller: _notes, maxLines: 2, minLines: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: _busy
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(LucideIcons.save, size: 16),
                    label: Text(t('save')),
                    onPressed: _busy ? null : _save,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    icon: const Icon(LucideIcons.plus, size: 16),
                    label: Text(t('newBtn')),
                    onPressed: _clearForm,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(LucideIcons.x, size: 16),
                    label: Text(t('cancel')),
                    onPressed: widget.onClose,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(LucideIcons.printer, size: 16),
                    label: Text(t('card')),
                    onPressed: _donorId == null ? null : _printCard,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(LucideIcons.fileText, size: 16),
                    label: Text(tr(lang, 'printCswFiche')),
                    onPressed: _donorId == null ? null : _printCsw,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printCard() async {
    final d = await widget.state.db.getDonor(_donorId!);
    final events = await widget.state.db.getEvents(d.id);
    await PdfCardService.printDonorCard(
      d,
      widget.state.isRtl,
      eventsOf: (_) async => events,
    );
  }

  Future<void> _printCsw() async {
    final d = await widget.state.db.getDonor(_donorId!);
    final events = await widget.state.db.getEvents(d.id);
    await CswFicheService.printFiche(d, events);
  }

  Widget _label(String s) => Padding(
    padding: const EdgeInsetsDirectional.only(top: 10, bottom: 4),
    child: Text(
      s,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
  );

  Widget _genderToggle(String g) {
    final active = _gender == g;
    return Expanded(
      child: Material(
        color: active ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _gender = g),
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: active ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                g == 'M' ? t('male') : t('female'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _groupButton(String g) {
    final active = _group == g;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() {
        _group = g;
        _showGroupError = false;
      }),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.blood : AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.blood : AppColors.border,
            width: 1.2,
          ),
        ),
        child: LtrText(
          g,
          bold: true,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: active ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _dateField(TextEditingController c) => TextFormField(
    controller: c,
    textDirection: TextDirection.ltr,
    decoration: InputDecoration(hintText: t('dateHint')),
    onChanged: (_) => setState(() {}),
    validator: _dateValidator,
  );

  String? _phoneValidator(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 ||
        digits.length > 15 ||
        (phone.contains('+') && !phone.startsWith('+')) ||
        '+'.allMatches(phone).length > 1) {
      return t('invalidPhone');
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : t('invalidEmail');
  }

  String? _dateValidator(String? value) {
    final date = value?.trim() ?? '';
    if (date.isEmpty) return null;
    if (!RegExp(
      r'^(?:\d{1,2}[/.-]\d{1,2}[/.-]\d{4}|\d{4}-\d{1,2}-\d{1,2})$',
    ).hasMatch(date)) {
      return t('invalidDate');
    }
    final normalized = normalizeDate(date);
    if (normalized.isEmpty) return t('invalidDate');
    if (normalized.compareTo(isoDate(DateTime.now())) > 0) {
      return t('futureDate');
    }
    return null;
  }

  Widget _photoBox() {
    ImageProvider? provider;
    if (_previewBytes != null) {
      provider = MemoryImage(Uint8List.fromList(_previewBytes!));
    } else if (_photo.isNotEmpty) {
      provider = FileImage(_photos.fileFor(_photo));
    }
    return Container(
      height: 224,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Center(
            child: provider != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: provider,
                      fit: BoxFit.cover,
                      width: 220,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        LucideIcons.user,
                        size: 56,
                        color: AppColors.textSecondary.withValues(alpha: 0.55),
                      ),
                    ),
                  )
                : Icon(
                    LucideIcons.user,
                    size: 56,
                    color: AppColors.textSecondary.withValues(alpha: 0.55),
                  ),
          ),
          PositionedDirectional(
            bottom: 8,
            end: 8,
            child: InkWell(
              onTap: _pickPhoto,
              child: Container(
                padding: const EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eligibilityCard(({String date, String status}) live) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.bloodSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blood.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            t('nextEligible'),
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          LtrText(
            live.date.isEmpty ? '—' : live.date,
            bold: true,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.blood,
            ),
          ),
          const SizedBox(height: 6),
          StatusBadge(
            status: live.status,
            label: tr(lang, 'st_${live.status}'),
          ),
        ],
      ),
    );
  }

  Widget _historyCard() {
    return AppPanel(
      title: t('history'),
      child: StreamBuilder<List<DonationEvent>>(
        stream: widget.state.db.watchEvents(_donorId!),
        builder: (context, snap) {
          final events = snap.data ?? const <DonationEvent>[];
          final dons = events.where((e) => e.eventType == 'donation').length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${t('totalDonations')}: $dons',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: events.isEmpty
                    ? Center(
                        child: Text(
                          t('noHistory'),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, i) {
                          final e = events[i];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              e.eventType == 'donation'
                                  ? LucideIcons.droplet
                                  : LucideIcons.flaskConical,
                              size: 16,
                              color: e.eventType == 'donation'
                                  ? AppColors.blood
                                  : AppColors.primary,
                            ),
                            title: LtrText(
                              displayDate(e.eventDate),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: e.bilan.isEmpty
                                ? null
                                : Text(
                                    e.bilan,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                    ),
                                  ),
                            trailing: IconButton(
                              icon: const Icon(
                                LucideIcons.trash2,
                                size: 15,
                                color: AppColors.destructive,
                              ),
                              onPressed: () =>
                                  widget.state.db.deleteEvent(e.id),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---- Quick event recording (CSW table row) ------------------------------

  // (kept minimal: TA/poids/type/bilan are captured via recordEvent dialog
  // from the Alerts screen "Mark Donated Today" flow)
}
