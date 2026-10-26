// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DonorsTable extends Donors with TableInfo<$DonorsTable, Donor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DonorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _maidenNameMeta = const VerificationMeta(
    'maidenName',
  );
  @override
  late final GeneratedColumn<String> maidenName = GeneratedColumn<String>(
    'maiden_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workAddressMeta = const VerificationMeta(
    'workAddress',
  );
  @override
  late final GeneratedColumn<String> workAddress = GeneratedColumn<String>(
    'work_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workPhoneMeta = const VerificationMeta(
    'workPhone',
  );
  @override
  late final GeneratedColumn<String> workPhone = GeneratedColumn<String>(
    'work_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workEmailMeta = const VerificationMeta(
    'workEmail',
  );
  @override
  late final GeneratedColumn<String> workEmail = GeneratedColumn<String>(
    'work_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phenotypeMeta = const VerificationMeta(
    'phenotype',
  );
  @override
  late final GeneratedColumn<String> phenotype = GeneratedColumn<String>(
    'phenotype',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastDonationMeta = const VerificationMeta(
    'lastDonation',
  );
  @override
  late final GeneratedColumn<String> lastDonation = GeneratedColumn<String>(
    'last_donation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastTestMeta = const VerificationMeta(
    'lastTest',
  );
  @override
  late final GeneratedColumn<String> lastTest = GeneratedColumn<String>(
    'last_test',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoFilenameMeta = const VerificationMeta(
    'photoFilename',
  );
  @override
  late final GeneratedColumn<String> photoFilename = GeneratedColumn<String>(
    'photo_filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _donationCountMeta = const VerificationMeta(
    'donationCount',
  );
  @override
  late final GeneratedColumn<int> donationCount = GeneratedColumn<int>(
    'donation_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    bloodGroup,
    phone,
    maidenName,
    address,
    email,
    workAddress,
    workPhone,
    workEmail,
    phenotype,
    birthDate,
    lastDonation,
    lastTest,
    notes,
    photoFilename,
    donationCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'donors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Donor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_bloodGroupMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('maiden_name')) {
      context.handle(
        _maidenNameMeta,
        maidenName.isAcceptableOrUnknown(data['maiden_name']!, _maidenNameMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('work_address')) {
      context.handle(
        _workAddressMeta,
        workAddress.isAcceptableOrUnknown(
          data['work_address']!,
          _workAddressMeta,
        ),
      );
    }
    if (data.containsKey('work_phone')) {
      context.handle(
        _workPhoneMeta,
        workPhone.isAcceptableOrUnknown(data['work_phone']!, _workPhoneMeta),
      );
    }
    if (data.containsKey('work_email')) {
      context.handle(
        _workEmailMeta,
        workEmail.isAcceptableOrUnknown(data['work_email']!, _workEmailMeta),
      );
    }
    if (data.containsKey('phenotype')) {
      context.handle(
        _phenotypeMeta,
        phenotype.isAcceptableOrUnknown(data['phenotype']!, _phenotypeMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('last_donation')) {
      context.handle(
        _lastDonationMeta,
        lastDonation.isAcceptableOrUnknown(
          data['last_donation']!,
          _lastDonationMeta,
        ),
      );
    }
    if (data.containsKey('last_test')) {
      context.handle(
        _lastTestMeta,
        lastTest.isAcceptableOrUnknown(data['last_test']!, _lastTestMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_filename')) {
      context.handle(
        _photoFilenameMeta,
        photoFilename.isAcceptableOrUnknown(
          data['photo_filename']!,
          _photoFilenameMeta,
        ),
      );
    }
    if (data.containsKey('donation_count')) {
      context.handle(
        _donationCountMeta,
        donationCount.isAcceptableOrUnknown(
          data['donation_count']!,
          _donationCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Donor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Donor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      maidenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maiden_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      workAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_address'],
      )!,
      workPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_phone'],
      )!,
      workEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_email'],
      )!,
      phenotype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phenotype'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      )!,
      lastDonation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_donation'],
      )!,
      lastTest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_test'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      photoFilename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_filename'],
      )!,
      donationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}donation_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DonorsTable createAlias(String alias) {
    return $DonorsTable(attachedDatabase, alias);
  }
}

class Donor extends DataClass implements Insertable<Donor> {
  final String id;
  final String name;
  final String gender;
  final String bloodGroup;
  final String phone;
  final String maidenName;
  final String address;
  final String email;
  final String workAddress;
  final String workPhone;
  final String workEmail;
  final String phenotype;
  final String birthDate;
  final String lastDonation;
  final String lastTest;
  final String notes;
  final String photoFilename;
  final int donationCount;
  final String createdAt;
  final String updatedAt;
  const Donor({
    required this.id,
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
    required this.photoFilename,
    required this.donationCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['gender'] = Variable<String>(gender);
    map['blood_group'] = Variable<String>(bloodGroup);
    map['phone'] = Variable<String>(phone);
    map['maiden_name'] = Variable<String>(maidenName);
    map['address'] = Variable<String>(address);
    map['email'] = Variable<String>(email);
    map['work_address'] = Variable<String>(workAddress);
    map['work_phone'] = Variable<String>(workPhone);
    map['work_email'] = Variable<String>(workEmail);
    map['phenotype'] = Variable<String>(phenotype);
    map['birth_date'] = Variable<String>(birthDate);
    map['last_donation'] = Variable<String>(lastDonation);
    map['last_test'] = Variable<String>(lastTest);
    map['notes'] = Variable<String>(notes);
    map['photo_filename'] = Variable<String>(photoFilename);
    map['donation_count'] = Variable<int>(donationCount);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  DonorsCompanion toCompanion(bool nullToAbsent) {
    return DonorsCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      bloodGroup: Value(bloodGroup),
      phone: Value(phone),
      maidenName: Value(maidenName),
      address: Value(address),
      email: Value(email),
      workAddress: Value(workAddress),
      workPhone: Value(workPhone),
      workEmail: Value(workEmail),
      phenotype: Value(phenotype),
      birthDate: Value(birthDate),
      lastDonation: Value(lastDonation),
      lastTest: Value(lastTest),
      notes: Value(notes),
      photoFilename: Value(photoFilename),
      donationCount: Value(donationCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Donor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Donor(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<String>(json['gender']),
      bloodGroup: serializer.fromJson<String>(json['bloodGroup']),
      phone: serializer.fromJson<String>(json['phone']),
      maidenName: serializer.fromJson<String>(json['maidenName']),
      address: serializer.fromJson<String>(json['address']),
      email: serializer.fromJson<String>(json['email']),
      workAddress: serializer.fromJson<String>(json['workAddress']),
      workPhone: serializer.fromJson<String>(json['workPhone']),
      workEmail: serializer.fromJson<String>(json['workEmail']),
      phenotype: serializer.fromJson<String>(json['phenotype']),
      birthDate: serializer.fromJson<String>(json['birthDate']),
      lastDonation: serializer.fromJson<String>(json['lastDonation']),
      lastTest: serializer.fromJson<String>(json['lastTest']),
      notes: serializer.fromJson<String>(json['notes']),
      photoFilename: serializer.fromJson<String>(json['photoFilename']),
      donationCount: serializer.fromJson<int>(json['donationCount']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<String>(gender),
      'bloodGroup': serializer.toJson<String>(bloodGroup),
      'phone': serializer.toJson<String>(phone),
      'maidenName': serializer.toJson<String>(maidenName),
      'address': serializer.toJson<String>(address),
      'email': serializer.toJson<String>(email),
      'workAddress': serializer.toJson<String>(workAddress),
      'workPhone': serializer.toJson<String>(workPhone),
      'workEmail': serializer.toJson<String>(workEmail),
      'phenotype': serializer.toJson<String>(phenotype),
      'birthDate': serializer.toJson<String>(birthDate),
      'lastDonation': serializer.toJson<String>(lastDonation),
      'lastTest': serializer.toJson<String>(lastTest),
      'notes': serializer.toJson<String>(notes),
      'photoFilename': serializer.toJson<String>(photoFilename),
      'donationCount': serializer.toJson<int>(donationCount),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Donor copyWith({
    String? id,
    String? name,
    String? gender,
    String? bloodGroup,
    String? phone,
    String? maidenName,
    String? address,
    String? email,
    String? workAddress,
    String? workPhone,
    String? workEmail,
    String? phenotype,
    String? birthDate,
    String? lastDonation,
    String? lastTest,
    String? notes,
    String? photoFilename,
    int? donationCount,
    String? createdAt,
    String? updatedAt,
  }) => Donor(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    bloodGroup: bloodGroup ?? this.bloodGroup,
    phone: phone ?? this.phone,
    maidenName: maidenName ?? this.maidenName,
    address: address ?? this.address,
    email: email ?? this.email,
    workAddress: workAddress ?? this.workAddress,
    workPhone: workPhone ?? this.workPhone,
    workEmail: workEmail ?? this.workEmail,
    phenotype: phenotype ?? this.phenotype,
    birthDate: birthDate ?? this.birthDate,
    lastDonation: lastDonation ?? this.lastDonation,
    lastTest: lastTest ?? this.lastTest,
    notes: notes ?? this.notes,
    photoFilename: photoFilename ?? this.photoFilename,
    donationCount: donationCount ?? this.donationCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Donor copyWithCompanion(DonorsCompanion data) {
    return Donor(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      phone: data.phone.present ? data.phone.value : this.phone,
      maidenName: data.maidenName.present
          ? data.maidenName.value
          : this.maidenName,
      address: data.address.present ? data.address.value : this.address,
      email: data.email.present ? data.email.value : this.email,
      workAddress: data.workAddress.present
          ? data.workAddress.value
          : this.workAddress,
      workPhone: data.workPhone.present ? data.workPhone.value : this.workPhone,
      workEmail: data.workEmail.present ? data.workEmail.value : this.workEmail,
      phenotype: data.phenotype.present ? data.phenotype.value : this.phenotype,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      lastDonation: data.lastDonation.present
          ? data.lastDonation.value
          : this.lastDonation,
      lastTest: data.lastTest.present ? data.lastTest.value : this.lastTest,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoFilename: data.photoFilename.present
          ? data.photoFilename.value
          : this.photoFilename,
      donationCount: data.donationCount.present
          ? data.donationCount.value
          : this.donationCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Donor(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('phone: $phone, ')
          ..write('maidenName: $maidenName, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('workAddress: $workAddress, ')
          ..write('workPhone: $workPhone, ')
          ..write('workEmail: $workEmail, ')
          ..write('phenotype: $phenotype, ')
          ..write('birthDate: $birthDate, ')
          ..write('lastDonation: $lastDonation, ')
          ..write('lastTest: $lastTest, ')
          ..write('notes: $notes, ')
          ..write('photoFilename: $photoFilename, ')
          ..write('donationCount: $donationCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gender,
    bloodGroup,
    phone,
    maidenName,
    address,
    email,
    workAddress,
    workPhone,
    workEmail,
    phenotype,
    birthDate,
    lastDonation,
    lastTest,
    notes,
    photoFilename,
    donationCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Donor &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.bloodGroup == this.bloodGroup &&
          other.phone == this.phone &&
          other.maidenName == this.maidenName &&
          other.address == this.address &&
          other.email == this.email &&
          other.workAddress == this.workAddress &&
          other.workPhone == this.workPhone &&
          other.workEmail == this.workEmail &&
          other.phenotype == this.phenotype &&
          other.birthDate == this.birthDate &&
          other.lastDonation == this.lastDonation &&
          other.lastTest == this.lastTest &&
          other.notes == this.notes &&
          other.photoFilename == this.photoFilename &&
          other.donationCount == this.donationCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DonorsCompanion extends UpdateCompanion<Donor> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> gender;
  final Value<String> bloodGroup;
  final Value<String> phone;
  final Value<String> maidenName;
  final Value<String> address;
  final Value<String> email;
  final Value<String> workAddress;
  final Value<String> workPhone;
  final Value<String> workEmail;
  final Value<String> phenotype;
  final Value<String> birthDate;
  final Value<String> lastDonation;
  final Value<String> lastTest;
  final Value<String> notes;
  final Value<String> photoFilename;
  final Value<int> donationCount;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const DonorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.phone = const Value.absent(),
    this.maidenName = const Value.absent(),
    this.address = const Value.absent(),
    this.email = const Value.absent(),
    this.workAddress = const Value.absent(),
    this.workPhone = const Value.absent(),
    this.workEmail = const Value.absent(),
    this.phenotype = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.lastDonation = const Value.absent(),
    this.lastTest = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoFilename = const Value.absent(),
    this.donationCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DonorsCompanion.insert({
    required String id,
    required String name,
    required String gender,
    required String bloodGroup,
    this.phone = const Value.absent(),
    this.maidenName = const Value.absent(),
    this.address = const Value.absent(),
    this.email = const Value.absent(),
    this.workAddress = const Value.absent(),
    this.workPhone = const Value.absent(),
    this.workEmail = const Value.absent(),
    this.phenotype = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.lastDonation = const Value.absent(),
    this.lastTest = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoFilename = const Value.absent(),
    this.donationCount = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       gender = Value(gender),
       bloodGroup = Value(bloodGroup),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Donor> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? gender,
    Expression<String>? bloodGroup,
    Expression<String>? phone,
    Expression<String>? maidenName,
    Expression<String>? address,
    Expression<String>? email,
    Expression<String>? workAddress,
    Expression<String>? workPhone,
    Expression<String>? workEmail,
    Expression<String>? phenotype,
    Expression<String>? birthDate,
    Expression<String>? lastDonation,
    Expression<String>? lastTest,
    Expression<String>? notes,
    Expression<String>? photoFilename,
    Expression<int>? donationCount,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (phone != null) 'phone': phone,
      if (maidenName != null) 'maiden_name': maidenName,
      if (address != null) 'address': address,
      if (email != null) 'email': email,
      if (workAddress != null) 'work_address': workAddress,
      if (workPhone != null) 'work_phone': workPhone,
      if (workEmail != null) 'work_email': workEmail,
      if (phenotype != null) 'phenotype': phenotype,
      if (birthDate != null) 'birth_date': birthDate,
      if (lastDonation != null) 'last_donation': lastDonation,
      if (lastTest != null) 'last_test': lastTest,
      if (notes != null) 'notes': notes,
      if (photoFilename != null) 'photo_filename': photoFilename,
      if (donationCount != null) 'donation_count': donationCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DonorsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? gender,
    Value<String>? bloodGroup,
    Value<String>? phone,
    Value<String>? maidenName,
    Value<String>? address,
    Value<String>? email,
    Value<String>? workAddress,
    Value<String>? workPhone,
    Value<String>? workEmail,
    Value<String>? phenotype,
    Value<String>? birthDate,
    Value<String>? lastDonation,
    Value<String>? lastTest,
    Value<String>? notes,
    Value<String>? photoFilename,
    Value<int>? donationCount,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return DonorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      maidenName: maidenName ?? this.maidenName,
      address: address ?? this.address,
      email: email ?? this.email,
      workAddress: workAddress ?? this.workAddress,
      workPhone: workPhone ?? this.workPhone,
      workEmail: workEmail ?? this.workEmail,
      phenotype: phenotype ?? this.phenotype,
      birthDate: birthDate ?? this.birthDate,
      lastDonation: lastDonation ?? this.lastDonation,
      lastTest: lastTest ?? this.lastTest,
      notes: notes ?? this.notes,
      photoFilename: photoFilename ?? this.photoFilename,
      donationCount: donationCount ?? this.donationCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (maidenName.present) {
      map['maiden_name'] = Variable<String>(maidenName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (workAddress.present) {
      map['work_address'] = Variable<String>(workAddress.value);
    }
    if (workPhone.present) {
      map['work_phone'] = Variable<String>(workPhone.value);
    }
    if (workEmail.present) {
      map['work_email'] = Variable<String>(workEmail.value);
    }
    if (phenotype.present) {
      map['phenotype'] = Variable<String>(phenotype.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (lastDonation.present) {
      map['last_donation'] = Variable<String>(lastDonation.value);
    }
    if (lastTest.present) {
      map['last_test'] = Variable<String>(lastTest.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoFilename.present) {
      map['photo_filename'] = Variable<String>(photoFilename.value);
    }
    if (donationCount.present) {
      map['donation_count'] = Variable<int>(donationCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DonorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('phone: $phone, ')
          ..write('maidenName: $maidenName, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('workAddress: $workAddress, ')
          ..write('workPhone: $workPhone, ')
          ..write('workEmail: $workEmail, ')
          ..write('phenotype: $phenotype, ')
          ..write('birthDate: $birthDate, ')
          ..write('lastDonation: $lastDonation, ')
          ..write('lastTest: $lastTest, ')
          ..write('notes: $notes, ')
          ..write('photoFilename: $photoFilename, ')
          ..write('donationCount: $donationCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DonationEventsTable extends DonationEvents
    with TableInfo<$DonationEventsTable, DonationEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DonationEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _donorIdMeta = const VerificationMeta(
    'donorId',
  );
  @override
  late final GeneratedColumn<String> donorId = GeneratedColumn<String>(
    'donor_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<String> eventDate = GeneratedColumn<String>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taMeta = const VerificationMeta('ta');
  @override
  late final GeneratedColumn<String> ta = GeneratedColumn<String>(
    'ta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<String> weight = GeneratedColumn<String>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _donationTypeMeta = const VerificationMeta(
    'donationType',
  );
  @override
  late final GeneratedColumn<String> donationType = GeneratedColumn<String>(
    'donation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bilanMeta = const VerificationMeta('bilan');
  @override
  late final GeneratedColumn<String> bilan = GeneratedColumn<String>(
    'bilan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    donorId,
    eventType,
    eventDate,
    ta,
    weight,
    donationType,
    bilan,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'donation_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<DonationEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('donor_id')) {
      context.handle(
        _donorIdMeta,
        donorId.isAcceptableOrUnknown(data['donor_id']!, _donorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_donorIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('ta')) {
      context.handle(_taMeta, ta.isAcceptableOrUnknown(data['ta']!, _taMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('donation_type')) {
      context.handle(
        _donationTypeMeta,
        donationType.isAcceptableOrUnknown(
          data['donation_type']!,
          _donationTypeMeta,
        ),
      );
    }
    if (data.containsKey('bilan')) {
      context.handle(
        _bilanMeta,
        bilan.isAcceptableOrUnknown(data['bilan']!, _bilanMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DonationEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DonationEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      donorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}donor_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_date'],
      )!,
      ta: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ta'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight'],
      )!,
      donationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}donation_type'],
      )!,
      bilan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bilan'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DonationEventsTable createAlias(String alias) {
    return $DonationEventsTable(attachedDatabase, alias);
  }
}

class DonationEvent extends DataClass implements Insertable<DonationEvent> {
  final String id;
  final String donorId;
  final String eventType;
  final String eventDate;
  final String ta;
  final String weight;
  final String donationType;
  final String bilan;
  final String notes;
  final String createdAt;
  const DonationEvent({
    required this.id,
    required this.donorId,
    required this.eventType,
    required this.eventDate,
    required this.ta,
    required this.weight,
    required this.donationType,
    required this.bilan,
    required this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['donor_id'] = Variable<String>(donorId);
    map['event_type'] = Variable<String>(eventType);
    map['event_date'] = Variable<String>(eventDate);
    map['ta'] = Variable<String>(ta);
    map['weight'] = Variable<String>(weight);
    map['donation_type'] = Variable<String>(donationType);
    map['bilan'] = Variable<String>(bilan);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DonationEventsCompanion toCompanion(bool nullToAbsent) {
    return DonationEventsCompanion(
      id: Value(id),
      donorId: Value(donorId),
      eventType: Value(eventType),
      eventDate: Value(eventDate),
      ta: Value(ta),
      weight: Value(weight),
      donationType: Value(donationType),
      bilan: Value(bilan),
      notes: Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory DonationEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DonationEvent(
      id: serializer.fromJson<String>(json['id']),
      donorId: serializer.fromJson<String>(json['donorId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      eventDate: serializer.fromJson<String>(json['eventDate']),
      ta: serializer.fromJson<String>(json['ta']),
      weight: serializer.fromJson<String>(json['weight']),
      donationType: serializer.fromJson<String>(json['donationType']),
      bilan: serializer.fromJson<String>(json['bilan']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'donorId': serializer.toJson<String>(donorId),
      'eventType': serializer.toJson<String>(eventType),
      'eventDate': serializer.toJson<String>(eventDate),
      'ta': serializer.toJson<String>(ta),
      'weight': serializer.toJson<String>(weight),
      'donationType': serializer.toJson<String>(donationType),
      'bilan': serializer.toJson<String>(bilan),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DonationEvent copyWith({
    String? id,
    String? donorId,
    String? eventType,
    String? eventDate,
    String? ta,
    String? weight,
    String? donationType,
    String? bilan,
    String? notes,
    String? createdAt,
  }) => DonationEvent(
    id: id ?? this.id,
    donorId: donorId ?? this.donorId,
    eventType: eventType ?? this.eventType,
    eventDate: eventDate ?? this.eventDate,
    ta: ta ?? this.ta,
    weight: weight ?? this.weight,
    donationType: donationType ?? this.donationType,
    bilan: bilan ?? this.bilan,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  DonationEvent copyWithCompanion(DonationEventsCompanion data) {
    return DonationEvent(
      id: data.id.present ? data.id.value : this.id,
      donorId: data.donorId.present ? data.donorId.value : this.donorId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      ta: data.ta.present ? data.ta.value : this.ta,
      weight: data.weight.present ? data.weight.value : this.weight,
      donationType: data.donationType.present
          ? data.donationType.value
          : this.donationType,
      bilan: data.bilan.present ? data.bilan.value : this.bilan,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DonationEvent(')
          ..write('id: $id, ')
          ..write('donorId: $donorId, ')
          ..write('eventType: $eventType, ')
          ..write('eventDate: $eventDate, ')
          ..write('ta: $ta, ')
          ..write('weight: $weight, ')
          ..write('donationType: $donationType, ')
          ..write('bilan: $bilan, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    donorId,
    eventType,
    eventDate,
    ta,
    weight,
    donationType,
    bilan,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DonationEvent &&
          other.id == this.id &&
          other.donorId == this.donorId &&
          other.eventType == this.eventType &&
          other.eventDate == this.eventDate &&
          other.ta == this.ta &&
          other.weight == this.weight &&
          other.donationType == this.donationType &&
          other.bilan == this.bilan &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class DonationEventsCompanion extends UpdateCompanion<DonationEvent> {
  final Value<String> id;
  final Value<String> donorId;
  final Value<String> eventType;
  final Value<String> eventDate;
  final Value<String> ta;
  final Value<String> weight;
  final Value<String> donationType;
  final Value<String> bilan;
  final Value<String> notes;
  final Value<String> createdAt;
  final Value<int> rowid;
  const DonationEventsCompanion({
    this.id = const Value.absent(),
    this.donorId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.ta = const Value.absent(),
    this.weight = const Value.absent(),
    this.donationType = const Value.absent(),
    this.bilan = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DonationEventsCompanion.insert({
    required String id,
    required String donorId,
    required String eventType,
    required String eventDate,
    this.ta = const Value.absent(),
    this.weight = const Value.absent(),
    this.donationType = const Value.absent(),
    this.bilan = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       donorId = Value(donorId),
       eventType = Value(eventType),
       eventDate = Value(eventDate),
       createdAt = Value(createdAt);
  static Insertable<DonationEvent> custom({
    Expression<String>? id,
    Expression<String>? donorId,
    Expression<String>? eventType,
    Expression<String>? eventDate,
    Expression<String>? ta,
    Expression<String>? weight,
    Expression<String>? donationType,
    Expression<String>? bilan,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (donorId != null) 'donor_id': donorId,
      if (eventType != null) 'event_type': eventType,
      if (eventDate != null) 'event_date': eventDate,
      if (ta != null) 'ta': ta,
      if (weight != null) 'weight': weight,
      if (donationType != null) 'donation_type': donationType,
      if (bilan != null) 'bilan': bilan,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DonationEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? donorId,
    Value<String>? eventType,
    Value<String>? eventDate,
    Value<String>? ta,
    Value<String>? weight,
    Value<String>? donationType,
    Value<String>? bilan,
    Value<String>? notes,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return DonationEventsCompanion(
      id: id ?? this.id,
      donorId: donorId ?? this.donorId,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      ta: ta ?? this.ta,
      weight: weight ?? this.weight,
      donationType: donationType ?? this.donationType,
      bilan: bilan ?? this.bilan,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (donorId.present) {
      map['donor_id'] = Variable<String>(donorId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<String>(eventDate.value);
    }
    if (ta.present) {
      map['ta'] = Variable<String>(ta.value);
    }
    if (weight.present) {
      map['weight'] = Variable<String>(weight.value);
    }
    if (donationType.present) {
      map['donation_type'] = Variable<String>(donationType.value);
    }
    if (bilan.present) {
      map['bilan'] = Variable<String>(bilan.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DonationEventsCompanion(')
          ..write('id: $id, ')
          ..write('donorId: $donorId, ')
          ..write('eventType: $eventType, ')
          ..write('eventDate: $eventDate, ')
          ..write('ta: $ta, ')
          ..write('weight: $weight, ')
          ..write('donationType: $donationType, ')
          ..write('bilan: $bilan, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('admin'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isDefaultPasswordMeta = const VerificationMeta(
    'isDefaultPassword',
  );
  @override
  late final GeneratedColumn<bool> isDefaultPassword = GeneratedColumn<bool>(
    'is_default_password',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default_password" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifiedJsonMeta = const VerificationMeta(
    'notifiedJson',
  );
  @override
  late final GeneratedColumn<String> notifiedJson = GeneratedColumn<String>(
    'notified_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    isDefaultPassword,
    language,
    notificationsEnabled,
    notifiedJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('is_default_password')) {
      context.handle(
        _isDefaultPasswordMeta,
        isDefaultPassword.isAcceptableOrUnknown(
          data['is_default_password']!,
          _isDefaultPasswordMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('notified_json')) {
      context.handle(
        _notifiedJsonMeta,
        notifiedJson.isAcceptableOrUnknown(
          data['notified_json']!,
          _notifiedJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      isDefaultPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default_password'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      notifiedJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notified_json'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String username;
  final String passwordHash;
  final bool isDefaultPassword;
  final String language;
  final bool notificationsEnabled;
  final String notifiedJson;
  const AppSetting({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.isDefaultPassword,
    required this.language,
    required this.notificationsEnabled,
    required this.notifiedJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['is_default_password'] = Variable<bool>(isDefaultPassword);
    map['language'] = Variable<String>(language);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['notified_json'] = Variable<String>(notifiedJson);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      isDefaultPassword: Value(isDefaultPassword),
      language: Value(language),
      notificationsEnabled: Value(notificationsEnabled),
      notifiedJson: Value(notifiedJson),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      isDefaultPassword: serializer.fromJson<bool>(json['isDefaultPassword']),
      language: serializer.fromJson<String>(json['language']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      notifiedJson: serializer.fromJson<String>(json['notifiedJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'isDefaultPassword': serializer.toJson<bool>(isDefaultPassword),
      'language': serializer.toJson<String>(language),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'notifiedJson': serializer.toJson<String>(notifiedJson),
    };
  }

  AppSetting copyWith({
    int? id,
    String? username,
    String? passwordHash,
    bool? isDefaultPassword,
    String? language,
    bool? notificationsEnabled,
    String? notifiedJson,
  }) => AppSetting(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    isDefaultPassword: isDefaultPassword ?? this.isDefaultPassword,
    language: language ?? this.language,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    notifiedJson: notifiedJson ?? this.notifiedJson,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      isDefaultPassword: data.isDefaultPassword.present
          ? data.isDefaultPassword.value
          : this.isDefaultPassword,
      language: data.language.present ? data.language.value : this.language,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      notifiedJson: data.notifiedJson.present
          ? data.notifiedJson.value
          : this.notifiedJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isDefaultPassword: $isDefaultPassword, ')
          ..write('language: $language, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('notifiedJson: $notifiedJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    passwordHash,
    isDefaultPassword,
    language,
    notificationsEnabled,
    notifiedJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.isDefaultPassword == this.isDefaultPassword &&
          other.language == this.language &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.notifiedJson == this.notifiedJson);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<bool> isDefaultPassword;
  final Value<String> language;
  final Value<bool> notificationsEnabled;
  final Value<String> notifiedJson;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.isDefaultPassword = const Value.absent(),
    this.language = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.notifiedJson = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.isDefaultPassword = const Value.absent(),
    this.language = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.notifiedJson = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<bool>? isDefaultPassword,
    Expression<String>? language,
    Expression<bool>? notificationsEnabled,
    Expression<String>? notifiedJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (isDefaultPassword != null) 'is_default_password': isDefaultPassword,
      if (language != null) 'language': language,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (notifiedJson != null) 'notified_json': notifiedJson,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<bool>? isDefaultPassword,
    Value<String>? language,
    Value<bool>? notificationsEnabled,
    Value<String>? notifiedJson,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      isDefaultPassword: isDefaultPassword ?? this.isDefaultPassword,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notifiedJson: notifiedJson ?? this.notifiedJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (isDefaultPassword.present) {
      map['is_default_password'] = Variable<bool>(isDefaultPassword.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (notifiedJson.present) {
      map['notified_json'] = Variable<String>(notifiedJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isDefaultPassword: $isDefaultPassword, ')
          ..write('language: $language, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('notifiedJson: $notifiedJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DonorsTable donors = $DonorsTable(this);
  late final $DonationEventsTable donationEvents = $DonationEventsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    donors,
    donationEvents,
    appSettings,
  ];
}

typedef $$DonorsTableCreateCompanionBuilder =
    DonorsCompanion Function({
      required String id,
      required String name,
      required String gender,
      required String bloodGroup,
      Value<String> phone,
      Value<String> maidenName,
      Value<String> address,
      Value<String> email,
      Value<String> workAddress,
      Value<String> workPhone,
      Value<String> workEmail,
      Value<String> phenotype,
      Value<String> birthDate,
      Value<String> lastDonation,
      Value<String> lastTest,
      Value<String> notes,
      Value<String> photoFilename,
      Value<int> donationCount,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$DonorsTableUpdateCompanionBuilder =
    DonorsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> gender,
      Value<String> bloodGroup,
      Value<String> phone,
      Value<String> maidenName,
      Value<String> address,
      Value<String> email,
      Value<String> workAddress,
      Value<String> workPhone,
      Value<String> workEmail,
      Value<String> phenotype,
      Value<String> birthDate,
      Value<String> lastDonation,
      Value<String> lastTest,
      Value<String> notes,
      Value<String> photoFilename,
      Value<int> donationCount,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$DonorsTableFilterComposer
    extends Composer<_$AppDatabase, $DonorsTable> {
  $$DonorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maidenName => $composableBuilder(
    column: $table.maidenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workAddress => $composableBuilder(
    column: $table.workAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workPhone => $composableBuilder(
    column: $table.workPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workEmail => $composableBuilder(
    column: $table.workEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phenotype => $composableBuilder(
    column: $table.phenotype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDonation => $composableBuilder(
    column: $table.lastDonation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastTest => $composableBuilder(
    column: $table.lastTest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoFilename => $composableBuilder(
    column: $table.photoFilename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get donationCount => $composableBuilder(
    column: $table.donationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DonorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DonorsTable> {
  $$DonorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maidenName => $composableBuilder(
    column: $table.maidenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workAddress => $composableBuilder(
    column: $table.workAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workPhone => $composableBuilder(
    column: $table.workPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workEmail => $composableBuilder(
    column: $table.workEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phenotype => $composableBuilder(
    column: $table.phenotype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDonation => $composableBuilder(
    column: $table.lastDonation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastTest => $composableBuilder(
    column: $table.lastTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoFilename => $composableBuilder(
    column: $table.photoFilename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get donationCount => $composableBuilder(
    column: $table.donationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DonorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DonorsTable> {
  $$DonorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get maidenName => $composableBuilder(
    column: $table.maidenName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get workAddress => $composableBuilder(
    column: $table.workAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workPhone =>
      $composableBuilder(column: $table.workPhone, builder: (column) => column);

  GeneratedColumn<String> get workEmail =>
      $composableBuilder(column: $table.workEmail, builder: (column) => column);

  GeneratedColumn<String> get phenotype =>
      $composableBuilder(column: $table.phenotype, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get lastDonation => $composableBuilder(
    column: $table.lastDonation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastTest =>
      $composableBuilder(column: $table.lastTest, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoFilename => $composableBuilder(
    column: $table.photoFilename,
    builder: (column) => column,
  );

  GeneratedColumn<int> get donationCount => $composableBuilder(
    column: $table.donationCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DonorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DonorsTable,
          Donor,
          $$DonorsTableFilterComposer,
          $$DonorsTableOrderingComposer,
          $$DonorsTableAnnotationComposer,
          $$DonorsTableCreateCompanionBuilder,
          $$DonorsTableUpdateCompanionBuilder,
          (Donor, BaseReferences<_$AppDatabase, $DonorsTable, Donor>),
          Donor,
          PrefetchHooks Function()
        > {
  $$DonorsTableTableManager(_$AppDatabase db, $DonorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DonorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DonorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DonorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<String> bloodGroup = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> maidenName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> workAddress = const Value.absent(),
                Value<String> workPhone = const Value.absent(),
                Value<String> workEmail = const Value.absent(),
                Value<String> phenotype = const Value.absent(),
                Value<String> birthDate = const Value.absent(),
                Value<String> lastDonation = const Value.absent(),
                Value<String> lastTest = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> photoFilename = const Value.absent(),
                Value<int> donationCount = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DonorsCompanion(
                id: id,
                name: name,
                gender: gender,
                bloodGroup: bloodGroup,
                phone: phone,
                maidenName: maidenName,
                address: address,
                email: email,
                workAddress: workAddress,
                workPhone: workPhone,
                workEmail: workEmail,
                phenotype: phenotype,
                birthDate: birthDate,
                lastDonation: lastDonation,
                lastTest: lastTest,
                notes: notes,
                photoFilename: photoFilename,
                donationCount: donationCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String gender,
                required String bloodGroup,
                Value<String> phone = const Value.absent(),
                Value<String> maidenName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> workAddress = const Value.absent(),
                Value<String> workPhone = const Value.absent(),
                Value<String> workEmail = const Value.absent(),
                Value<String> phenotype = const Value.absent(),
                Value<String> birthDate = const Value.absent(),
                Value<String> lastDonation = const Value.absent(),
                Value<String> lastTest = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> photoFilename = const Value.absent(),
                Value<int> donationCount = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DonorsCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                bloodGroup: bloodGroup,
                phone: phone,
                maidenName: maidenName,
                address: address,
                email: email,
                workAddress: workAddress,
                workPhone: workPhone,
                workEmail: workEmail,
                phenotype: phenotype,
                birthDate: birthDate,
                lastDonation: lastDonation,
                lastTest: lastTest,
                notes: notes,
                photoFilename: photoFilename,
                donationCount: donationCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DonorsTable, Donor>(table),
                  BaseReferences<_$AppDatabase, $DonorsTable, Donor>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DonorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DonorsTable,
      Donor,
      $$DonorsTableFilterComposer,
      $$DonorsTableOrderingComposer,
      $$DonorsTableAnnotationComposer,
      $$DonorsTableCreateCompanionBuilder,
      $$DonorsTableUpdateCompanionBuilder,
      (Donor, BaseReferences<_$AppDatabase, $DonorsTable, Donor>),
      Donor,
      PrefetchHooks Function()
    >;
typedef $$DonationEventsTableCreateCompanionBuilder =
    DonationEventsCompanion Function({
      required String id,
      required String donorId,
      required String eventType,
      required String eventDate,
      Value<String> ta,
      Value<String> weight,
      Value<String> donationType,
      Value<String> bilan,
      Value<String> notes,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$DonationEventsTableUpdateCompanionBuilder =
    DonationEventsCompanion Function({
      Value<String> id,
      Value<String> donorId,
      Value<String> eventType,
      Value<String> eventDate,
      Value<String> ta,
      Value<String> weight,
      Value<String> donationType,
      Value<String> bilan,
      Value<String> notes,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$DonationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DonationEventsTable> {
  $$DonationEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get donorId => $composableBuilder(
    column: $table.donorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ta => $composableBuilder(
    column: $table.ta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get donationType => $composableBuilder(
    column: $table.donationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bilan => $composableBuilder(
    column: $table.bilan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DonationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DonationEventsTable> {
  $$DonationEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get donorId => $composableBuilder(
    column: $table.donorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ta => $composableBuilder(
    column: $table.ta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get donationType => $composableBuilder(
    column: $table.donationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bilan => $composableBuilder(
    column: $table.bilan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DonationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DonationEventsTable> {
  $$DonationEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get donorId =>
      $composableBuilder(column: $table.donorId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get ta =>
      $composableBuilder(column: $table.ta, builder: (column) => column);

  GeneratedColumn<String> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get donationType => $composableBuilder(
    column: $table.donationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bilan =>
      $composableBuilder(column: $table.bilan, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DonationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DonationEventsTable,
          DonationEvent,
          $$DonationEventsTableFilterComposer,
          $$DonationEventsTableOrderingComposer,
          $$DonationEventsTableAnnotationComposer,
          $$DonationEventsTableCreateCompanionBuilder,
          $$DonationEventsTableUpdateCompanionBuilder,
          (
            DonationEvent,
            BaseReferences<_$AppDatabase, $DonationEventsTable, DonationEvent>,
          ),
          DonationEvent,
          PrefetchHooks Function()
        > {
  $$DonationEventsTableTableManager(
    _$AppDatabase db,
    $DonationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DonationEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DonationEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DonationEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> donorId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> eventDate = const Value.absent(),
                Value<String> ta = const Value.absent(),
                Value<String> weight = const Value.absent(),
                Value<String> donationType = const Value.absent(),
                Value<String> bilan = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DonationEventsCompanion(
                id: id,
                donorId: donorId,
                eventType: eventType,
                eventDate: eventDate,
                ta: ta,
                weight: weight,
                donationType: donationType,
                bilan: bilan,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String donorId,
                required String eventType,
                required String eventDate,
                Value<String> ta = const Value.absent(),
                Value<String> weight = const Value.absent(),
                Value<String> donationType = const Value.absent(),
                Value<String> bilan = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DonationEventsCompanion.insert(
                id: id,
                donorId: donorId,
                eventType: eventType,
                eventDate: eventDate,
                ta: ta,
                weight: weight,
                donationType: donationType,
                bilan: bilan,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DonationEventsTable, DonationEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DonationEventsTable,
                    DonationEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DonationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DonationEventsTable,
      DonationEvent,
      $$DonationEventsTableFilterComposer,
      $$DonationEventsTableOrderingComposer,
      $$DonationEventsTableAnnotationComposer,
      $$DonationEventsTableCreateCompanionBuilder,
      $$DonationEventsTableUpdateCompanionBuilder,
      (
        DonationEvent,
        BaseReferences<_$AppDatabase, $DonationEventsTable, DonationEvent>,
      ),
      DonationEvent,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<bool> isDefaultPassword,
      Value<String> language,
      Value<bool> notificationsEnabled,
      Value<String> notifiedJson,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<bool> isDefaultPassword,
      Value<String> language,
      Value<bool> notificationsEnabled,
      Value<String> notifiedJson,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefaultPassword => $composableBuilder(
    column: $table.isDefaultPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notifiedJson => $composableBuilder(
    column: $table.notifiedJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefaultPassword => $composableBuilder(
    column: $table.isDefaultPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notifiedJson => $composableBuilder(
    column: $table.notifiedJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefaultPassword => $composableBuilder(
    column: $table.isDefaultPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notifiedJson => $composableBuilder(
    column: $table.notifiedJson,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<bool> isDefaultPassword = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String> notifiedJson = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                isDefaultPassword: isDefaultPassword,
                language: language,
                notificationsEnabled: notificationsEnabled,
                notifiedJson: notifiedJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<bool> isDefaultPassword = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String> notifiedJson = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                isDefaultPassword: isDefaultPassword,
                language: language,
                notificationsEnabled: notificationsEnabled,
                notifiedJson: notifiedJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DonorsTableTableManager get donors =>
      $$DonorsTableTableManager(_db, _db.donors);
  $$DonationEventsTableTableManager get donationEvents =>
      $$DonationEventsTableTableManager(_db, _db.donationEvents);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
