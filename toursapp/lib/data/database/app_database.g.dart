// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProvincesTable extends Provinces
    with TableInfo<$ProvincesTable, Province> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvincesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameKoMeta = const VerificationMeta('nameKo');
  @override
  late final GeneratedColumn<String> nameKo = GeneratedColumn<String>(
    'name_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    lat,
    lng,
    imageUrl,
    isActive,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provinces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Province> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_ko')) {
      context.handle(
        _nameKoMeta,
        nameKo.isAcceptableOrUnknown(data['name_ko']!, _nameKoMeta),
      );
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Province map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Province(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ko'],
      ),
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $ProvincesTable createAlias(String alias) {
    return $ProvincesTable(attachedDatabase, alias);
  }
}

class Province extends DataClass implements Insertable<Province> {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameKo;
  final String? nameZh;
  final String? description;
  final double lat;
  final double lng;
  final String? imageUrl;
  final bool isActive;
  final DateTime? lastSyncedAt;
  const Province({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameKo,
    this.nameZh,
    this.description,
    required this.lat,
    required this.lng,
    this.imageUrl,
    required this.isActive,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameKo != null) {
      map['name_ko'] = Variable<String>(nameKo);
    }
    if (!nullToAbsent || nameZh != null) {
      map['name_zh'] = Variable<String>(nameZh);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  ProvincesCompanion toCompanion(bool nullToAbsent) {
    return ProvincesCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameKo: nameKo == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKo),
      nameZh: nameZh == null && nullToAbsent
          ? const Value.absent()
          : Value(nameZh),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      lat: Value(lat),
      lng: Value(lng),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isActive: Value(isActive),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Province.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Province(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameKo: serializer.fromJson<String?>(json['nameKo']),
      nameZh: serializer.fromJson<String?>(json['nameZh']),
      description: serializer.fromJson<String?>(json['description']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameKo': serializer.toJson<String?>(nameKo),
      'nameZh': serializer.toJson<String?>(nameZh),
      'description': serializer.toJson<String?>(description),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isActive': serializer.toJson<bool>(isActive),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Province copyWith({
    int? id,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameKo = const Value.absent(),
    Value<String?> nameZh = const Value.absent(),
    Value<String?> description = const Value.absent(),
    double? lat,
    double? lng,
    Value<String?> imageUrl = const Value.absent(),
    bool? isActive,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Province(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameKo: nameKo.present ? nameKo.value : this.nameKo,
    nameZh: nameZh.present ? nameZh.value : this.nameZh,
    description: description.present ? description.value : this.description,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isActive: isActive ?? this.isActive,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Province copyWithCompanion(ProvincesCompanion data) {
    return Province(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameKo: data.nameKo.present ? data.nameKo.value : this.nameKo,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      description: data.description.present
          ? data.description.value
          : this.description,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Province(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    lat,
    lng,
    imageUrl,
    isActive,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Province &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameKo == this.nameKo &&
          other.nameZh == this.nameZh &&
          other.description == this.description &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.imageUrl == this.imageUrl &&
          other.isActive == this.isActive &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ProvincesCompanion extends UpdateCompanion<Province> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> nameKo;
  final Value<String?> nameZh;
  final Value<String?> description;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String?> imageUrl;
  final Value<bool> isActive;
  final Value<DateTime?> lastSyncedAt;
  const ProvincesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  ProvincesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    required double lat,
    required double lng,
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : name = Value(name),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<Province> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameKo,
    Expression<String>? nameZh,
    Expression<String>? description,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? imageUrl,
    Expression<bool>? isActive,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameKo != null) 'name_ko': nameKo,
      if (nameZh != null) 'name_zh': nameZh,
      if (description != null) 'description': description,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isActive != null) 'is_active': isActive,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  ProvincesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? nameKo,
    Value<String?>? nameZh,
    Value<String?>? description,
    Value<double>? lat,
    Value<double>? lng,
    Value<String?>? imageUrl,
    Value<bool>? isActive,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return ProvincesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameKo: nameKo ?? this.nameKo,
      nameZh: nameZh ?? this.nameZh,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameKo.present) {
      map['name_ko'] = Variable<String>(nameKo.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvincesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _provinceIdMeta = const VerificationMeta(
    'provinceId',
  );
  @override
  late final GeneratedColumn<int> provinceId = GeneratedColumn<int>(
    'province_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES provinces (id)',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameKoMeta = const VerificationMeta('nameKo');
  @override
  late final GeneratedColumn<String> nameKo = GeneratedColumn<String>(
    'name_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderNumMeta = const VerificationMeta(
    'orderNum',
  );
  @override
  late final GeneratedColumn<int> orderNum = GeneratedColumn<int>(
    'order_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provinceId,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    orderNum,
    imageUrl,
    lat,
    lng,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Location> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('province_id')) {
      context.handle(
        _provinceIdMeta,
        provinceId.isAcceptableOrUnknown(data['province_id']!, _provinceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_provinceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_ko')) {
      context.handle(
        _nameKoMeta,
        nameKo.isAcceptableOrUnknown(data['name_ko']!, _nameKoMeta),
      );
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('order_num')) {
      context.handle(
        _orderNumMeta,
        orderNum.isAcceptableOrUnknown(data['order_num']!, _orderNumMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      provinceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}province_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ko'],
      ),
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      orderNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_num'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final int id;
  final int provinceId;
  final String name;
  final String? nameEn;
  final String? nameKo;
  final String? nameZh;
  final String? description;
  final int orderNum;
  final String? imageUrl;
  final double lat;
  final double lng;
  final DateTime? lastSyncedAt;
  const Location({
    required this.id,
    required this.provinceId,
    required this.name,
    this.nameEn,
    this.nameKo,
    this.nameZh,
    this.description,
    required this.orderNum,
    this.imageUrl,
    required this.lat,
    required this.lng,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['province_id'] = Variable<int>(provinceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameKo != null) {
      map['name_ko'] = Variable<String>(nameKo);
    }
    if (!nullToAbsent || nameZh != null) {
      map['name_zh'] = Variable<String>(nameZh);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['order_num'] = Variable<int>(orderNum);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      provinceId: Value(provinceId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameKo: nameKo == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKo),
      nameZh: nameZh == null && nullToAbsent
          ? const Value.absent()
          : Value(nameZh),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      orderNum: Value(orderNum),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      lat: Value(lat),
      lng: Value(lng),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Location.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int>(json['id']),
      provinceId: serializer.fromJson<int>(json['provinceId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameKo: serializer.fromJson<String?>(json['nameKo']),
      nameZh: serializer.fromJson<String?>(json['nameZh']),
      description: serializer.fromJson<String?>(json['description']),
      orderNum: serializer.fromJson<int>(json['orderNum']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'provinceId': serializer.toJson<int>(provinceId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameKo': serializer.toJson<String?>(nameKo),
      'nameZh': serializer.toJson<String?>(nameZh),
      'description': serializer.toJson<String?>(description),
      'orderNum': serializer.toJson<int>(orderNum),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Location copyWith({
    int? id,
    int? provinceId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameKo = const Value.absent(),
    Value<String?> nameZh = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? orderNum,
    Value<String?> imageUrl = const Value.absent(),
    double? lat,
    double? lng,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Location(
    id: id ?? this.id,
    provinceId: provinceId ?? this.provinceId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameKo: nameKo.present ? nameKo.value : this.nameKo,
    nameZh: nameZh.present ? nameZh.value : this.nameZh,
    description: description.present ? description.value : this.description,
    orderNum: orderNum ?? this.orderNum,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      provinceId: data.provinceId.present
          ? data.provinceId.value
          : this.provinceId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameKo: data.nameKo.present ? data.nameKo.value : this.nameKo,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      description: data.description.present
          ? data.description.value
          : this.description,
      orderNum: data.orderNum.present ? data.orderNum.value : this.orderNum,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('provinceId: $provinceId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('orderNum: $orderNum, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    provinceId,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    orderNum,
    imageUrl,
    lat,
    lng,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.provinceId == this.provinceId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameKo == this.nameKo &&
          other.nameZh == this.nameZh &&
          other.description == this.description &&
          other.orderNum == this.orderNum &&
          other.imageUrl == this.imageUrl &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> id;
  final Value<int> provinceId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> nameKo;
  final Value<String?> nameZh;
  final Value<String?> description;
  final Value<int> orderNum;
  final Value<String?> imageUrl;
  final Value<double> lat;
  final Value<double> lng;
  final Value<DateTime?> lastSyncedAt;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.provinceId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    this.orderNum = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    required int provinceId,
    required String name,
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    this.orderNum = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required double lat,
    required double lng,
    this.lastSyncedAt = const Value.absent(),
  }) : provinceId = Value(provinceId),
       name = Value(name),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<Location> custom({
    Expression<int>? id,
    Expression<int>? provinceId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameKo,
    Expression<String>? nameZh,
    Expression<String>? description,
    Expression<int>? orderNum,
    Expression<String>? imageUrl,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provinceId != null) 'province_id': provinceId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameKo != null) 'name_ko': nameKo,
      if (nameZh != null) 'name_zh': nameZh,
      if (description != null) 'description': description,
      if (orderNum != null) 'order_num': orderNum,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  LocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? provinceId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? nameKo,
    Value<String?>? nameZh,
    Value<String?>? description,
    Value<int>? orderNum,
    Value<String?>? imageUrl,
    Value<double>? lat,
    Value<double>? lng,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return LocationsCompanion(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameKo: nameKo ?? this.nameKo,
      nameZh: nameZh ?? this.nameZh,
      description: description ?? this.description,
      orderNum: orderNum ?? this.orderNum,
      imageUrl: imageUrl ?? this.imageUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (provinceId.present) {
      map['province_id'] = Variable<int>(provinceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameKo.present) {
      map['name_ko'] = Variable<String>(nameKo.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (orderNum.present) {
      map['order_num'] = Variable<int>(orderNum.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('provinceId: $provinceId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('orderNum: $orderNum, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameKoMeta = const VerificationMeta('nameKo');
  @override
  late final GeneratedColumn<String> nameKo = GeneratedColumn<String>(
    'name_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlViMeta = const VerificationMeta(
    'audioUrlVi',
  );
  @override
  late final GeneratedColumn<String> audioUrlVi = GeneratedColumn<String>(
    'audio_url_vi',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlEnMeta = const VerificationMeta(
    'audioUrlEn',
  );
  @override
  late final GeneratedColumn<String> audioUrlEn = GeneratedColumn<String>(
    'audio_url_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlKoMeta = const VerificationMeta(
    'audioUrlKo',
  );
  @override
  late final GeneratedColumn<String> audioUrlKo = GeneratedColumn<String>(
    'audio_url_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioUrlZhMeta = const VerificationMeta(
    'audioUrlZh',
  );
  @override
  late final GeneratedColumn<String> audioUrlZh = GeneratedColumn<String>(
    'audio_url_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioDurationMeta = const VerificationMeta(
    'audioDuration',
  );
  @override
  late final GeneratedColumn<int> audioDuration = GeneratedColumn<int>(
    'audio_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flowerCostMeta = const VerificationMeta(
    'flowerCost',
  );
  @override
  late final GeneratedColumn<int> flowerCost = GeneratedColumn<int>(
    'flower_cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locationId,
    name,
    nameEn,
    nameKo,
    nameZh,
    slug,
    description,
    descriptionEn,
    lat,
    lng,
    imageUrl,
    audioUrlVi,
    audioUrlEn,
    audioUrlKo,
    audioUrlZh,
    audioDuration,
    category,
    difficulty,
    flowerCost,
    qrCode,
    status,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<Place> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_ko')) {
      context.handle(
        _nameKoMeta,
        nameKo.isAcceptableOrUnknown(data['name_ko']!, _nameKoMeta),
      );
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('audio_url_vi')) {
      context.handle(
        _audioUrlViMeta,
        audioUrlVi.isAcceptableOrUnknown(
          data['audio_url_vi']!,
          _audioUrlViMeta,
        ),
      );
    }
    if (data.containsKey('audio_url_en')) {
      context.handle(
        _audioUrlEnMeta,
        audioUrlEn.isAcceptableOrUnknown(
          data['audio_url_en']!,
          _audioUrlEnMeta,
        ),
      );
    }
    if (data.containsKey('audio_url_ko')) {
      context.handle(
        _audioUrlKoMeta,
        audioUrlKo.isAcceptableOrUnknown(
          data['audio_url_ko']!,
          _audioUrlKoMeta,
        ),
      );
    }
    if (data.containsKey('audio_url_zh')) {
      context.handle(
        _audioUrlZhMeta,
        audioUrlZh.isAcceptableOrUnknown(
          data['audio_url_zh']!,
          _audioUrlZhMeta,
        ),
      );
    }
    if (data.containsKey('audio_duration')) {
      context.handle(
        _audioDurationMeta,
        audioDuration.isAcceptableOrUnknown(
          data['audio_duration']!,
          _audioDurationMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('flower_cost')) {
      context.handle(
        _flowerCostMeta,
        flowerCost.isAcceptableOrUnknown(data['flower_cost']!, _flowerCostMeta),
      );
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ko'],
      ),
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      ),
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      audioUrlVi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url_vi'],
      ),
      audioUrlEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url_en'],
      ),
      audioUrlKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url_ko'],
      ),
      audioUrlZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url_zh'],
      ),
      audioDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}audio_duration'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      ),
      flowerCost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flower_cost'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class Place extends DataClass implements Insertable<Place> {
  final int id;
  final int locationId;
  final String name;
  final String? nameEn;
  final String? nameKo;
  final String? nameZh;
  final String slug;
  final String? description;
  final String? descriptionEn;
  final double lat;
  final double lng;
  final String? imageUrl;
  final String? audioUrlVi;
  final String? audioUrlEn;
  final String? audioUrlKo;
  final String? audioUrlZh;
  final int audioDuration;
  final String? category;
  final String? difficulty;
  final int flowerCost;
  final String? qrCode;
  final String? status;
  final DateTime? lastSyncedAt;
  const Place({
    required this.id,
    required this.locationId,
    required this.name,
    this.nameEn,
    this.nameKo,
    this.nameZh,
    required this.slug,
    this.description,
    this.descriptionEn,
    required this.lat,
    required this.lng,
    this.imageUrl,
    this.audioUrlVi,
    this.audioUrlEn,
    this.audioUrlKo,
    this.audioUrlZh,
    required this.audioDuration,
    this.category,
    this.difficulty,
    required this.flowerCost,
    this.qrCode,
    this.status,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_id'] = Variable<int>(locationId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameKo != null) {
      map['name_ko'] = Variable<String>(nameKo);
    }
    if (!nullToAbsent || nameZh != null) {
      map['name_zh'] = Variable<String>(nameZh);
    }
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || descriptionEn != null) {
      map['description_en'] = Variable<String>(descriptionEn);
    }
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || audioUrlVi != null) {
      map['audio_url_vi'] = Variable<String>(audioUrlVi);
    }
    if (!nullToAbsent || audioUrlEn != null) {
      map['audio_url_en'] = Variable<String>(audioUrlEn);
    }
    if (!nullToAbsent || audioUrlKo != null) {
      map['audio_url_ko'] = Variable<String>(audioUrlKo);
    }
    if (!nullToAbsent || audioUrlZh != null) {
      map['audio_url_zh'] = Variable<String>(audioUrlZh);
    }
    map['audio_duration'] = Variable<int>(audioDuration);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['flower_cost'] = Variable<int>(flowerCost);
    if (!nullToAbsent || qrCode != null) {
      map['qr_code'] = Variable<String>(qrCode);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      locationId: Value(locationId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameKo: nameKo == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKo),
      nameZh: nameZh == null && nullToAbsent
          ? const Value.absent()
          : Value(nameZh),
      slug: Value(slug),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      descriptionEn: descriptionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionEn),
      lat: Value(lat),
      lng: Value(lng),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      audioUrlVi: audioUrlVi == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrlVi),
      audioUrlEn: audioUrlEn == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrlEn),
      audioUrlKo: audioUrlKo == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrlKo),
      audioUrlZh: audioUrlZh == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrlZh),
      audioDuration: Value(audioDuration),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      flowerCost: Value(flowerCost),
      qrCode: qrCode == null && nullToAbsent
          ? const Value.absent()
          : Value(qrCode),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Place.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<int>(json['id']),
      locationId: serializer.fromJson<int>(json['locationId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameKo: serializer.fromJson<String?>(json['nameKo']),
      nameZh: serializer.fromJson<String?>(json['nameZh']),
      slug: serializer.fromJson<String>(json['slug']),
      description: serializer.fromJson<String?>(json['description']),
      descriptionEn: serializer.fromJson<String?>(json['descriptionEn']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      audioUrlVi: serializer.fromJson<String?>(json['audioUrlVi']),
      audioUrlEn: serializer.fromJson<String?>(json['audioUrlEn']),
      audioUrlKo: serializer.fromJson<String?>(json['audioUrlKo']),
      audioUrlZh: serializer.fromJson<String?>(json['audioUrlZh']),
      audioDuration: serializer.fromJson<int>(json['audioDuration']),
      category: serializer.fromJson<String?>(json['category']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      flowerCost: serializer.fromJson<int>(json['flowerCost']),
      qrCode: serializer.fromJson<String?>(json['qrCode']),
      status: serializer.fromJson<String?>(json['status']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationId': serializer.toJson<int>(locationId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameKo': serializer.toJson<String?>(nameKo),
      'nameZh': serializer.toJson<String?>(nameZh),
      'slug': serializer.toJson<String>(slug),
      'description': serializer.toJson<String?>(description),
      'descriptionEn': serializer.toJson<String?>(descriptionEn),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'audioUrlVi': serializer.toJson<String?>(audioUrlVi),
      'audioUrlEn': serializer.toJson<String?>(audioUrlEn),
      'audioUrlKo': serializer.toJson<String?>(audioUrlKo),
      'audioUrlZh': serializer.toJson<String?>(audioUrlZh),
      'audioDuration': serializer.toJson<int>(audioDuration),
      'category': serializer.toJson<String?>(category),
      'difficulty': serializer.toJson<String?>(difficulty),
      'flowerCost': serializer.toJson<int>(flowerCost),
      'qrCode': serializer.toJson<String?>(qrCode),
      'status': serializer.toJson<String?>(status),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Place copyWith({
    int? id,
    int? locationId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameKo = const Value.absent(),
    Value<String?> nameZh = const Value.absent(),
    String? slug,
    Value<String?> description = const Value.absent(),
    Value<String?> descriptionEn = const Value.absent(),
    double? lat,
    double? lng,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> audioUrlVi = const Value.absent(),
    Value<String?> audioUrlEn = const Value.absent(),
    Value<String?> audioUrlKo = const Value.absent(),
    Value<String?> audioUrlZh = const Value.absent(),
    int? audioDuration,
    Value<String?> category = const Value.absent(),
    Value<String?> difficulty = const Value.absent(),
    int? flowerCost,
    Value<String?> qrCode = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Place(
    id: id ?? this.id,
    locationId: locationId ?? this.locationId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameKo: nameKo.present ? nameKo.value : this.nameKo,
    nameZh: nameZh.present ? nameZh.value : this.nameZh,
    slug: slug ?? this.slug,
    description: description.present ? description.value : this.description,
    descriptionEn: descriptionEn.present
        ? descriptionEn.value
        : this.descriptionEn,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    audioUrlVi: audioUrlVi.present ? audioUrlVi.value : this.audioUrlVi,
    audioUrlEn: audioUrlEn.present ? audioUrlEn.value : this.audioUrlEn,
    audioUrlKo: audioUrlKo.present ? audioUrlKo.value : this.audioUrlKo,
    audioUrlZh: audioUrlZh.present ? audioUrlZh.value : this.audioUrlZh,
    audioDuration: audioDuration ?? this.audioDuration,
    category: category.present ? category.value : this.category,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    flowerCost: flowerCost ?? this.flowerCost,
    qrCode: qrCode.present ? qrCode.value : this.qrCode,
    status: status.present ? status.value : this.status,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameKo: data.nameKo.present ? data.nameKo.value : this.nameKo,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      slug: data.slug.present ? data.slug.value : this.slug,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      audioUrlVi: data.audioUrlVi.present
          ? data.audioUrlVi.value
          : this.audioUrlVi,
      audioUrlEn: data.audioUrlEn.present
          ? data.audioUrlEn.value
          : this.audioUrlEn,
      audioUrlKo: data.audioUrlKo.present
          ? data.audioUrlKo.value
          : this.audioUrlKo,
      audioUrlZh: data.audioUrlZh.present
          ? data.audioUrlZh.value
          : this.audioUrlZh,
      audioDuration: data.audioDuration.present
          ? data.audioDuration.value
          : this.audioDuration,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      flowerCost: data.flowerCost.present
          ? data.flowerCost.value
          : this.flowerCost,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      status: data.status.present ? data.status.value : this.status,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('audioUrlVi: $audioUrlVi, ')
          ..write('audioUrlEn: $audioUrlEn, ')
          ..write('audioUrlKo: $audioUrlKo, ')
          ..write('audioUrlZh: $audioUrlZh, ')
          ..write('audioDuration: $audioDuration, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('flowerCost: $flowerCost, ')
          ..write('qrCode: $qrCode, ')
          ..write('status: $status, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    locationId,
    name,
    nameEn,
    nameKo,
    nameZh,
    slug,
    description,
    descriptionEn,
    lat,
    lng,
    imageUrl,
    audioUrlVi,
    audioUrlEn,
    audioUrlKo,
    audioUrlZh,
    audioDuration,
    category,
    difficulty,
    flowerCost,
    qrCode,
    status,
    lastSyncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameKo == this.nameKo &&
          other.nameZh == this.nameZh &&
          other.slug == this.slug &&
          other.description == this.description &&
          other.descriptionEn == this.descriptionEn &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.imageUrl == this.imageUrl &&
          other.audioUrlVi == this.audioUrlVi &&
          other.audioUrlEn == this.audioUrlEn &&
          other.audioUrlKo == this.audioUrlKo &&
          other.audioUrlZh == this.audioUrlZh &&
          other.audioDuration == this.audioDuration &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.flowerCost == this.flowerCost &&
          other.qrCode == this.qrCode &&
          other.status == this.status &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<int> id;
  final Value<int> locationId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> nameKo;
  final Value<String?> nameZh;
  final Value<String> slug;
  final Value<String?> description;
  final Value<String?> descriptionEn;
  final Value<double> lat;
  final Value<double> lng;
  final Value<String?> imageUrl;
  final Value<String?> audioUrlVi;
  final Value<String?> audioUrlEn;
  final Value<String?> audioUrlKo;
  final Value<String?> audioUrlZh;
  final Value<int> audioDuration;
  final Value<String?> category;
  final Value<String?> difficulty;
  final Value<int> flowerCost;
  final Value<String?> qrCode;
  final Value<String?> status;
  final Value<DateTime?> lastSyncedAt;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.slug = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.audioUrlVi = const Value.absent(),
    this.audioUrlEn = const Value.absent(),
    this.audioUrlKo = const Value.absent(),
    this.audioUrlZh = const Value.absent(),
    this.audioDuration = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.flowerCost = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.status = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  PlacesCompanion.insert({
    this.id = const Value.absent(),
    required int locationId,
    required String name,
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    required String slug,
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    required double lat,
    required double lng,
    this.imageUrl = const Value.absent(),
    this.audioUrlVi = const Value.absent(),
    this.audioUrlEn = const Value.absent(),
    this.audioUrlKo = const Value.absent(),
    this.audioUrlZh = const Value.absent(),
    this.audioDuration = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.flowerCost = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.status = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : locationId = Value(locationId),
       name = Value(name),
       slug = Value(slug),
       lat = Value(lat),
       lng = Value(lng);
  static Insertable<Place> custom({
    Expression<int>? id,
    Expression<int>? locationId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameKo,
    Expression<String>? nameZh,
    Expression<String>? slug,
    Expression<String>? description,
    Expression<String>? descriptionEn,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? imageUrl,
    Expression<String>? audioUrlVi,
    Expression<String>? audioUrlEn,
    Expression<String>? audioUrlKo,
    Expression<String>? audioUrlZh,
    Expression<int>? audioDuration,
    Expression<String>? category,
    Expression<String>? difficulty,
    Expression<int>? flowerCost,
    Expression<String>? qrCode,
    Expression<String>? status,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameKo != null) 'name_ko': nameKo,
      if (nameZh != null) 'name_zh': nameZh,
      if (slug != null) 'slug': slug,
      if (description != null) 'description': description,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrlVi != null) 'audio_url_vi': audioUrlVi,
      if (audioUrlEn != null) 'audio_url_en': audioUrlEn,
      if (audioUrlKo != null) 'audio_url_ko': audioUrlKo,
      if (audioUrlZh != null) 'audio_url_zh': audioUrlZh,
      if (audioDuration != null) 'audio_duration': audioDuration,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (flowerCost != null) 'flower_cost': flowerCost,
      if (qrCode != null) 'qr_code': qrCode,
      if (status != null) 'status': status,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  PlacesCompanion copyWith({
    Value<int>? id,
    Value<int>? locationId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? nameKo,
    Value<String?>? nameZh,
    Value<String>? slug,
    Value<String?>? description,
    Value<String?>? descriptionEn,
    Value<double>? lat,
    Value<double>? lng,
    Value<String?>? imageUrl,
    Value<String?>? audioUrlVi,
    Value<String?>? audioUrlEn,
    Value<String?>? audioUrlKo,
    Value<String?>? audioUrlZh,
    Value<int>? audioDuration,
    Value<String?>? category,
    Value<String?>? difficulty,
    Value<int>? flowerCost,
    Value<String?>? qrCode,
    Value<String?>? status,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return PlacesCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameKo: nameKo ?? this.nameKo,
      nameZh: nameZh ?? this.nameZh,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrlVi: audioUrlVi ?? this.audioUrlVi,
      audioUrlEn: audioUrlEn ?? this.audioUrlEn,
      audioUrlKo: audioUrlKo ?? this.audioUrlKo,
      audioUrlZh: audioUrlZh ?? this.audioUrlZh,
      audioDuration: audioDuration ?? this.audioDuration,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      flowerCost: flowerCost ?? this.flowerCost,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameKo.present) {
      map['name_ko'] = Variable<String>(nameKo.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (audioUrlVi.present) {
      map['audio_url_vi'] = Variable<String>(audioUrlVi.value);
    }
    if (audioUrlEn.present) {
      map['audio_url_en'] = Variable<String>(audioUrlEn.value);
    }
    if (audioUrlKo.present) {
      map['audio_url_ko'] = Variable<String>(audioUrlKo.value);
    }
    if (audioUrlZh.present) {
      map['audio_url_zh'] = Variable<String>(audioUrlZh.value);
    }
    if (audioDuration.present) {
      map['audio_duration'] = Variable<int>(audioDuration.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (flowerCost.present) {
      map['flower_cost'] = Variable<int>(flowerCost.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('slug: $slug, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('audioUrlVi: $audioUrlVi, ')
          ..write('audioUrlEn: $audioUrlEn, ')
          ..write('audioUrlKo: $audioUrlKo, ')
          ..write('audioUrlZh: $audioUrlZh, ')
          ..write('audioDuration: $audioDuration, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('flowerCost: $flowerCost, ')
          ..write('qrCode: $qrCode, ')
          ..write('status: $status, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $SubPlacesTable extends SubPlaces
    with TableInfo<$SubPlacesTable, SubPlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubPlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentEnMeta = const VerificationMeta(
    'contentEn',
  );
  @override
  late final GeneratedColumn<String> contentEn = GeneratedColumn<String>(
    'content_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderNumMeta = const VerificationMeta(
    'orderNum',
  );
  @override
  late final GeneratedColumn<int> orderNum = GeneratedColumn<int>(
    'order_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeId,
    name,
    nameEn,
    content,
    contentEn,
    imageUrl,
    orderNum,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sub_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubPlace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('content_en')) {
      context.handle(
        _contentEnMeta,
        contentEn.isAcceptableOrUnknown(data['content_en']!, _contentEnMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('order_num')) {
      context.handle(
        _orderNumMeta,
        orderNum.isAcceptableOrUnknown(data['order_num']!, _orderNumMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubPlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubPlace(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      contentEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_en'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      orderNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_num'],
      )!,
    );
  }

  @override
  $SubPlacesTable createAlias(String alias) {
    return $SubPlacesTable(attachedDatabase, alias);
  }
}

class SubPlace extends DataClass implements Insertable<SubPlace> {
  final int id;
  final int placeId;
  final String name;
  final String? nameEn;
  final String? content;
  final String? contentEn;
  final String? imageUrl;
  final int orderNum;
  const SubPlace({
    required this.id,
    required this.placeId,
    required this.name,
    this.nameEn,
    this.content,
    this.contentEn,
    this.imageUrl,
    required this.orderNum,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['place_id'] = Variable<int>(placeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || contentEn != null) {
      map['content_en'] = Variable<String>(contentEn);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['order_num'] = Variable<int>(orderNum);
    return map;
  }

  SubPlacesCompanion toCompanion(bool nullToAbsent) {
    return SubPlacesCompanion(
      id: Value(id),
      placeId: Value(placeId),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      contentEn: contentEn == null && nullToAbsent
          ? const Value.absent()
          : Value(contentEn),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      orderNum: Value(orderNum),
    );
  }

  factory SubPlace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubPlace(
      id: serializer.fromJson<int>(json['id']),
      placeId: serializer.fromJson<int>(json['placeId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      content: serializer.fromJson<String?>(json['content']),
      contentEn: serializer.fromJson<String?>(json['contentEn']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      orderNum: serializer.fromJson<int>(json['orderNum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'placeId': serializer.toJson<int>(placeId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'content': serializer.toJson<String?>(content),
      'contentEn': serializer.toJson<String?>(contentEn),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'orderNum': serializer.toJson<int>(orderNum),
    };
  }

  SubPlace copyWith({
    int? id,
    int? placeId,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> contentEn = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    int? orderNum,
  }) => SubPlace(
    id: id ?? this.id,
    placeId: placeId ?? this.placeId,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    content: content.present ? content.value : this.content,
    contentEn: contentEn.present ? contentEn.value : this.contentEn,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    orderNum: orderNum ?? this.orderNum,
  );
  SubPlace copyWithCompanion(SubPlacesCompanion data) {
    return SubPlace(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      content: data.content.present ? data.content.value : this.content,
      contentEn: data.contentEn.present ? data.contentEn.value : this.contentEn,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      orderNum: data.orderNum.present ? data.orderNum.value : this.orderNum,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubPlace(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('orderNum: $orderNum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    placeId,
    name,
    nameEn,
    content,
    contentEn,
    imageUrl,
    orderNum,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubPlace &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.content == this.content &&
          other.contentEn == this.contentEn &&
          other.imageUrl == this.imageUrl &&
          other.orderNum == this.orderNum);
}

class SubPlacesCompanion extends UpdateCompanion<SubPlace> {
  final Value<int> id;
  final Value<int> placeId;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> content;
  final Value<String?> contentEn;
  final Value<String?> imageUrl;
  final Value<int> orderNum;
  const SubPlacesCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.orderNum = const Value.absent(),
  });
  SubPlacesCompanion.insert({
    this.id = const Value.absent(),
    required int placeId,
    required String name,
    this.nameEn = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.orderNum = const Value.absent(),
  }) : placeId = Value(placeId),
       name = Value(name);
  static Insertable<SubPlace> custom({
    Expression<int>? id,
    Expression<int>? placeId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? content,
    Expression<String>? contentEn,
    Expression<String>? imageUrl,
    Expression<int>? orderNum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (content != null) 'content': content,
      if (contentEn != null) 'content_en': contentEn,
      if (imageUrl != null) 'image_url': imageUrl,
      if (orderNum != null) 'order_num': orderNum,
    });
  }

  SubPlacesCompanion copyWith({
    Value<int>? id,
    Value<int>? placeId,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? content,
    Value<String?>? contentEn,
    Value<String?>? imageUrl,
    Value<int>? orderNum,
  }) {
    return SubPlacesCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      content: content ?? this.content,
      contentEn: contentEn ?? this.contentEn,
      imageUrl: imageUrl ?? this.imageUrl,
      orderNum: orderNum ?? this.orderNum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contentEn.present) {
      map['content_en'] = Variable<String>(contentEn.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (orderNum.present) {
      map['order_num'] = Variable<int>(orderNum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubPlacesCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('orderNum: $orderNum')
          ..write(')'))
        .toString();
  }
}

class $JourneysTable extends Journeys with TableInfo<$JourneysTable, Journey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameKoMeta = const VerificationMeta('nameKo');
  @override
  late final GeneratedColumn<String> nameKo = GeneratedColumn<String>(
    'name_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameZhMeta = const VerificationMeta('nameZh');
  @override
  late final GeneratedColumn<String> nameZh = GeneratedColumn<String>(
    'name_zh',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDistanceMeta = const VerificationMeta(
    'totalDistance',
  );
  @override
  late final GeneratedColumn<String> totalDistance = GeneratedColumn<String>(
    'total_distance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedDaysMeta = const VerificationMeta(
    'estimatedDays',
  );
  @override
  late final GeneratedColumn<String> estimatedDays = GeneratedColumn<String>(
    'estimated_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPopularMeta = const VerificationMeta(
    'isPopular',
  );
  @override
  late final GeneratedColumn<bool> isPopular = GeneratedColumn<bool>(
    'is_popular',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_popular" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    descriptionEn,
    imageUrl,
    totalDistance,
    estimatedDays,
    difficulty,
    isPopular,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journeys';
  @override
  VerificationContext validateIntegrity(
    Insertable<Journey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('name_ko')) {
      context.handle(
        _nameKoMeta,
        nameKo.isAcceptableOrUnknown(data['name_ko']!, _nameKoMeta),
      );
    }
    if (data.containsKey('name_zh')) {
      context.handle(
        _nameZhMeta,
        nameZh.isAcceptableOrUnknown(data['name_zh']!, _nameZhMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('total_distance')) {
      context.handle(
        _totalDistanceMeta,
        totalDistance.isAcceptableOrUnknown(
          data['total_distance']!,
          _totalDistanceMeta,
        ),
      );
    }
    if (data.containsKey('estimated_days')) {
      context.handle(
        _estimatedDaysMeta,
        estimatedDays.isAcceptableOrUnknown(
          data['estimated_days']!,
          _estimatedDaysMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('is_popular')) {
      context.handle(
        _isPopularMeta,
        isPopular.isAcceptableOrUnknown(data['is_popular']!, _isPopularMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Journey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      nameKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ko'],
      ),
      nameZh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_zh'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      totalDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_distance'],
      ),
      estimatedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estimated_days'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      ),
      isPopular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_popular'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $JourneysTable createAlias(String alias) {
    return $JourneysTable(attachedDatabase, alias);
  }
}

class Journey extends DataClass implements Insertable<Journey> {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameKo;
  final String? nameZh;
  final String? description;
  final String? descriptionEn;
  final String? imageUrl;
  final String? totalDistance;
  final String? estimatedDays;
  final String? difficulty;
  final bool isPopular;
  final DateTime? lastSyncedAt;
  const Journey({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameKo,
    this.nameZh,
    this.description,
    this.descriptionEn,
    this.imageUrl,
    this.totalDistance,
    this.estimatedDays,
    this.difficulty,
    required this.isPopular,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || nameKo != null) {
      map['name_ko'] = Variable<String>(nameKo);
    }
    if (!nullToAbsent || nameZh != null) {
      map['name_zh'] = Variable<String>(nameZh);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || descriptionEn != null) {
      map['description_en'] = Variable<String>(descriptionEn);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || totalDistance != null) {
      map['total_distance'] = Variable<String>(totalDistance);
    }
    if (!nullToAbsent || estimatedDays != null) {
      map['estimated_days'] = Variable<String>(estimatedDays);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    map['is_popular'] = Variable<bool>(isPopular);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  JourneysCompanion toCompanion(bool nullToAbsent) {
    return JourneysCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      nameKo: nameKo == null && nullToAbsent
          ? const Value.absent()
          : Value(nameKo),
      nameZh: nameZh == null && nullToAbsent
          ? const Value.absent()
          : Value(nameZh),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      descriptionEn: descriptionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionEn),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      totalDistance: totalDistance == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDistance),
      estimatedDays: estimatedDays == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedDays),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      isPopular: Value(isPopular),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Journey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Journey(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      nameKo: serializer.fromJson<String?>(json['nameKo']),
      nameZh: serializer.fromJson<String?>(json['nameZh']),
      description: serializer.fromJson<String?>(json['description']),
      descriptionEn: serializer.fromJson<String?>(json['descriptionEn']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      totalDistance: serializer.fromJson<String?>(json['totalDistance']),
      estimatedDays: serializer.fromJson<String?>(json['estimatedDays']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      isPopular: serializer.fromJson<bool>(json['isPopular']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'nameKo': serializer.toJson<String?>(nameKo),
      'nameZh': serializer.toJson<String?>(nameZh),
      'description': serializer.toJson<String?>(description),
      'descriptionEn': serializer.toJson<String?>(descriptionEn),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'totalDistance': serializer.toJson<String?>(totalDistance),
      'estimatedDays': serializer.toJson<String?>(estimatedDays),
      'difficulty': serializer.toJson<String?>(difficulty),
      'isPopular': serializer.toJson<bool>(isPopular),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Journey copyWith({
    int? id,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> nameKo = const Value.absent(),
    Value<String?> nameZh = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> descriptionEn = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> totalDistance = const Value.absent(),
    Value<String?> estimatedDays = const Value.absent(),
    Value<String?> difficulty = const Value.absent(),
    bool? isPopular,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Journey(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    nameKo: nameKo.present ? nameKo.value : this.nameKo,
    nameZh: nameZh.present ? nameZh.value : this.nameZh,
    description: description.present ? description.value : this.description,
    descriptionEn: descriptionEn.present
        ? descriptionEn.value
        : this.descriptionEn,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    totalDistance: totalDistance.present
        ? totalDistance.value
        : this.totalDistance,
    estimatedDays: estimatedDays.present
        ? estimatedDays.value
        : this.estimatedDays,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    isPopular: isPopular ?? this.isPopular,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Journey copyWithCompanion(JourneysCompanion data) {
    return Journey(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameKo: data.nameKo.present ? data.nameKo.value : this.nameKo,
      nameZh: data.nameZh.present ? data.nameZh.value : this.nameZh,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      totalDistance: data.totalDistance.present
          ? data.totalDistance.value
          : this.totalDistance,
      estimatedDays: data.estimatedDays.present
          ? data.estimatedDays.value
          : this.estimatedDays,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      isPopular: data.isPopular.present ? data.isPopular.value : this.isPopular,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Journey(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('estimatedDays: $estimatedDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('isPopular: $isPopular, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    nameKo,
    nameZh,
    description,
    descriptionEn,
    imageUrl,
    totalDistance,
    estimatedDays,
    difficulty,
    isPopular,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Journey &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameKo == this.nameKo &&
          other.nameZh == this.nameZh &&
          other.description == this.description &&
          other.descriptionEn == this.descriptionEn &&
          other.imageUrl == this.imageUrl &&
          other.totalDistance == this.totalDistance &&
          other.estimatedDays == this.estimatedDays &&
          other.difficulty == this.difficulty &&
          other.isPopular == this.isPopular &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class JourneysCompanion extends UpdateCompanion<Journey> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> nameKo;
  final Value<String?> nameZh;
  final Value<String?> description;
  final Value<String?> descriptionEn;
  final Value<String?> imageUrl;
  final Value<String?> totalDistance;
  final Value<String?> estimatedDays;
  final Value<String?> difficulty;
  final Value<bool> isPopular;
  final Value<DateTime?> lastSyncedAt;
  const JourneysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.totalDistance = const Value.absent(),
    this.estimatedDays = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isPopular = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  JourneysCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
    this.nameKo = const Value.absent(),
    this.nameZh = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.totalDistance = const Value.absent(),
    this.estimatedDays = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.isPopular = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Journey> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameKo,
    Expression<String>? nameZh,
    Expression<String>? description,
    Expression<String>? descriptionEn,
    Expression<String>? imageUrl,
    Expression<String>? totalDistance,
    Expression<String>? estimatedDays,
    Expression<String>? difficulty,
    Expression<bool>? isPopular,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameKo != null) 'name_ko': nameKo,
      if (nameZh != null) 'name_zh': nameZh,
      if (description != null) 'description': description,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (imageUrl != null) 'image_url': imageUrl,
      if (totalDistance != null) 'total_distance': totalDistance,
      if (estimatedDays != null) 'estimated_days': estimatedDays,
      if (difficulty != null) 'difficulty': difficulty,
      if (isPopular != null) 'is_popular': isPopular,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  JourneysCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? nameKo,
    Value<String?>? nameZh,
    Value<String?>? description,
    Value<String?>? descriptionEn,
    Value<String?>? imageUrl,
    Value<String?>? totalDistance,
    Value<String?>? estimatedDays,
    Value<String?>? difficulty,
    Value<bool>? isPopular,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return JourneysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameKo: nameKo ?? this.nameKo,
      nameZh: nameZh ?? this.nameZh,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      imageUrl: imageUrl ?? this.imageUrl,
      totalDistance: totalDistance ?? this.totalDistance,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      difficulty: difficulty ?? this.difficulty,
      isPopular: isPopular ?? this.isPopular,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameKo.present) {
      map['name_ko'] = Variable<String>(nameKo.value);
    }
    if (nameZh.present) {
      map['name_zh'] = Variable<String>(nameZh.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (totalDistance.present) {
      map['total_distance'] = Variable<String>(totalDistance.value);
    }
    if (estimatedDays.present) {
      map['estimated_days'] = Variable<String>(estimatedDays.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (isPopular.present) {
      map['is_popular'] = Variable<bool>(isPopular.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameKo: $nameKo, ')
          ..write('nameZh: $nameZh, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('totalDistance: $totalDistance, ')
          ..write('estimatedDays: $estimatedDays, ')
          ..write('difficulty: $difficulty, ')
          ..write('isPopular: $isPopular, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $JourneyStopsTable extends JourneyStops
    with TableInfo<$JourneyStopsTable, JourneyStop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _journeyIdMeta = const VerificationMeta(
    'journeyId',
  );
  @override
  late final GeneratedColumn<int> journeyId = GeneratedColumn<int>(
    'journey_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journeys (id)',
    ),
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  static const VerificationMeta _orderNumMeta = const VerificationMeta(
    'orderNum',
  );
  @override
  late final GeneratedColumn<int> orderNum = GeneratedColumn<int>(
    'order_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeImageUrlMeta = const VerificationMeta(
    'placeImageUrl',
  );
  @override
  late final GeneratedColumn<String> placeImageUrl = GeneratedColumn<String>(
    'place_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceFromPrevMeta = const VerificationMeta(
    'distanceFromPrev',
  );
  @override
  late final GeneratedColumn<String> distanceFromPrev = GeneratedColumn<String>(
    'distance_from_prev',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journeyId,
    placeId,
    orderNum,
    placeName,
    placeImageUrl,
    lat,
    lng,
    distanceFromPrev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<JourneyStop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('journey_id')) {
      context.handle(
        _journeyIdMeta,
        journeyId.isAcceptableOrUnknown(data['journey_id']!, _journeyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journeyIdMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('order_num')) {
      context.handle(
        _orderNumMeta,
        orderNum.isAcceptableOrUnknown(data['order_num']!, _orderNumMeta),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    }
    if (data.containsKey('place_image_url')) {
      context.handle(
        _placeImageUrlMeta,
        placeImageUrl.isAcceptableOrUnknown(
          data['place_image_url']!,
          _placeImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('distance_from_prev')) {
      context.handle(
        _distanceFromPrevMeta,
        distanceFromPrev.isAcceptableOrUnknown(
          data['distance_from_prev']!,
          _distanceFromPrevMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JourneyStop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyStop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      journeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journey_id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      )!,
      orderNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_num'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      ),
      placeImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_image_url'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      distanceFromPrev: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distance_from_prev'],
      ),
    );
  }

  @override
  $JourneyStopsTable createAlias(String alias) {
    return $JourneyStopsTable(attachedDatabase, alias);
  }
}

class JourneyStop extends DataClass implements Insertable<JourneyStop> {
  final int id;
  final int journeyId;
  final int placeId;
  final int orderNum;
  final String? placeName;
  final String? placeImageUrl;
  final double? lat;
  final double? lng;
  final String? distanceFromPrev;
  const JourneyStop({
    required this.id,
    required this.journeyId,
    required this.placeId,
    required this.orderNum,
    this.placeName,
    this.placeImageUrl,
    this.lat,
    this.lng,
    this.distanceFromPrev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['journey_id'] = Variable<int>(journeyId);
    map['place_id'] = Variable<int>(placeId);
    map['order_num'] = Variable<int>(orderNum);
    if (!nullToAbsent || placeName != null) {
      map['place_name'] = Variable<String>(placeName);
    }
    if (!nullToAbsent || placeImageUrl != null) {
      map['place_image_url'] = Variable<String>(placeImageUrl);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || distanceFromPrev != null) {
      map['distance_from_prev'] = Variable<String>(distanceFromPrev);
    }
    return map;
  }

  JourneyStopsCompanion toCompanion(bool nullToAbsent) {
    return JourneyStopsCompanion(
      id: Value(id),
      journeyId: Value(journeyId),
      placeId: Value(placeId),
      orderNum: Value(orderNum),
      placeName: placeName == null && nullToAbsent
          ? const Value.absent()
          : Value(placeName),
      placeImageUrl: placeImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(placeImageUrl),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      distanceFromPrev: distanceFromPrev == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceFromPrev),
    );
  }

  factory JourneyStop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JourneyStop(
      id: serializer.fromJson<int>(json['id']),
      journeyId: serializer.fromJson<int>(json['journeyId']),
      placeId: serializer.fromJson<int>(json['placeId']),
      orderNum: serializer.fromJson<int>(json['orderNum']),
      placeName: serializer.fromJson<String?>(json['placeName']),
      placeImageUrl: serializer.fromJson<String?>(json['placeImageUrl']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      distanceFromPrev: serializer.fromJson<String?>(json['distanceFromPrev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'journeyId': serializer.toJson<int>(journeyId),
      'placeId': serializer.toJson<int>(placeId),
      'orderNum': serializer.toJson<int>(orderNum),
      'placeName': serializer.toJson<String?>(placeName),
      'placeImageUrl': serializer.toJson<String?>(placeImageUrl),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'distanceFromPrev': serializer.toJson<String?>(distanceFromPrev),
    };
  }

  JourneyStop copyWith({
    int? id,
    int? journeyId,
    int? placeId,
    int? orderNum,
    Value<String?> placeName = const Value.absent(),
    Value<String?> placeImageUrl = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<String?> distanceFromPrev = const Value.absent(),
  }) => JourneyStop(
    id: id ?? this.id,
    journeyId: journeyId ?? this.journeyId,
    placeId: placeId ?? this.placeId,
    orderNum: orderNum ?? this.orderNum,
    placeName: placeName.present ? placeName.value : this.placeName,
    placeImageUrl: placeImageUrl.present
        ? placeImageUrl.value
        : this.placeImageUrl,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    distanceFromPrev: distanceFromPrev.present
        ? distanceFromPrev.value
        : this.distanceFromPrev,
  );
  JourneyStop copyWithCompanion(JourneyStopsCompanion data) {
    return JourneyStop(
      id: data.id.present ? data.id.value : this.id,
      journeyId: data.journeyId.present ? data.journeyId.value : this.journeyId,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      orderNum: data.orderNum.present ? data.orderNum.value : this.orderNum,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      placeImageUrl: data.placeImageUrl.present
          ? data.placeImageUrl.value
          : this.placeImageUrl,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      distanceFromPrev: data.distanceFromPrev.present
          ? data.distanceFromPrev.value
          : this.distanceFromPrev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JourneyStop(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('placeId: $placeId, ')
          ..write('orderNum: $orderNum, ')
          ..write('placeName: $placeName, ')
          ..write('placeImageUrl: $placeImageUrl, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('distanceFromPrev: $distanceFromPrev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journeyId,
    placeId,
    orderNum,
    placeName,
    placeImageUrl,
    lat,
    lng,
    distanceFromPrev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JourneyStop &&
          other.id == this.id &&
          other.journeyId == this.journeyId &&
          other.placeId == this.placeId &&
          other.orderNum == this.orderNum &&
          other.placeName == this.placeName &&
          other.placeImageUrl == this.placeImageUrl &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.distanceFromPrev == this.distanceFromPrev);
}

class JourneyStopsCompanion extends UpdateCompanion<JourneyStop> {
  final Value<int> id;
  final Value<int> journeyId;
  final Value<int> placeId;
  final Value<int> orderNum;
  final Value<String?> placeName;
  final Value<String?> placeImageUrl;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> distanceFromPrev;
  const JourneyStopsCompanion({
    this.id = const Value.absent(),
    this.journeyId = const Value.absent(),
    this.placeId = const Value.absent(),
    this.orderNum = const Value.absent(),
    this.placeName = const Value.absent(),
    this.placeImageUrl = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.distanceFromPrev = const Value.absent(),
  });
  JourneyStopsCompanion.insert({
    this.id = const Value.absent(),
    required int journeyId,
    required int placeId,
    this.orderNum = const Value.absent(),
    this.placeName = const Value.absent(),
    this.placeImageUrl = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.distanceFromPrev = const Value.absent(),
  }) : journeyId = Value(journeyId),
       placeId = Value(placeId);
  static Insertable<JourneyStop> custom({
    Expression<int>? id,
    Expression<int>? journeyId,
    Expression<int>? placeId,
    Expression<int>? orderNum,
    Expression<String>? placeName,
    Expression<String>? placeImageUrl,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? distanceFromPrev,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journeyId != null) 'journey_id': journeyId,
      if (placeId != null) 'place_id': placeId,
      if (orderNum != null) 'order_num': orderNum,
      if (placeName != null) 'place_name': placeName,
      if (placeImageUrl != null) 'place_image_url': placeImageUrl,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (distanceFromPrev != null) 'distance_from_prev': distanceFromPrev,
    });
  }

  JourneyStopsCompanion copyWith({
    Value<int>? id,
    Value<int>? journeyId,
    Value<int>? placeId,
    Value<int>? orderNum,
    Value<String?>? placeName,
    Value<String?>? placeImageUrl,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String?>? distanceFromPrev,
  }) {
    return JourneyStopsCompanion(
      id: id ?? this.id,
      journeyId: journeyId ?? this.journeyId,
      placeId: placeId ?? this.placeId,
      orderNum: orderNum ?? this.orderNum,
      placeName: placeName ?? this.placeName,
      placeImageUrl: placeImageUrl ?? this.placeImageUrl,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distanceFromPrev: distanceFromPrev ?? this.distanceFromPrev,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (journeyId.present) {
      map['journey_id'] = Variable<int>(journeyId.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (orderNum.present) {
      map['order_num'] = Variable<int>(orderNum.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (placeImageUrl.present) {
      map['place_image_url'] = Variable<String>(placeImageUrl.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (distanceFromPrev.present) {
      map['distance_from_prev'] = Variable<String>(distanceFromPrev.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JourneyStopsCompanion(')
          ..write('id: $id, ')
          ..write('journeyId: $journeyId, ')
          ..write('placeId: $placeId, ')
          ..write('orderNum: $orderNum, ')
          ..write('placeName: $placeName, ')
          ..write('placeImageUrl: $placeImageUrl, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('distanceFromPrev: $distanceFromPrev')
          ..write(')'))
        .toString();
  }
}

class $StoriesTable extends Stories with TableInfo<$StoriesTable, Story> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleKoMeta = const VerificationMeta(
    'titleKo',
  );
  @override
  late final GeneratedColumn<String> titleKo = GeneratedColumn<String>(
    'title_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentEnMeta = const VerificationMeta(
    'contentEn',
  );
  @override
  late final GeneratedColumn<String> contentEn = GeneratedColumn<String>(
    'content_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readTimeMinutesMeta = const VerificationMeta(
    'readTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> readTimeMinutes = GeneratedColumn<int>(
    'read_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleEn,
    titleKo,
    content,
    contentEn,
    imageUrl,
    readTimeMinutes,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Story> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('title_ko')) {
      context.handle(
        _titleKoMeta,
        titleKo.isAcceptableOrUnknown(data['title_ko']!, _titleKoMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('content_en')) {
      context.handle(
        _contentEnMeta,
        contentEn.isAcceptableOrUnknown(data['content_en']!, _contentEnMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('read_time_minutes')) {
      context.handle(
        _readTimeMinutesMeta,
        readTimeMinutes.isAcceptableOrUnknown(
          data['read_time_minutes']!,
          _readTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Story map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Story(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      ),
      titleKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_ko'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      contentEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_en'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      readTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}read_time_minutes'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $StoriesTable createAlias(String alias) {
    return $StoriesTable(attachedDatabase, alias);
  }
}

class Story extends DataClass implements Insertable<Story> {
  final int id;
  final String title;
  final String? titleEn;
  final String? titleKo;
  final String? content;
  final String? contentEn;
  final String? imageUrl;
  final int readTimeMinutes;
  final DateTime? lastSyncedAt;
  const Story({
    required this.id,
    required this.title,
    this.titleEn,
    this.titleKo,
    this.content,
    this.contentEn,
    this.imageUrl,
    required this.readTimeMinutes,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || titleKo != null) {
      map['title_ko'] = Variable<String>(titleKo);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || contentEn != null) {
      map['content_en'] = Variable<String>(contentEn);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['read_time_minutes'] = Variable<int>(readTimeMinutes);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  StoriesCompanion toCompanion(bool nullToAbsent) {
    return StoriesCompanion(
      id: Value(id),
      title: Value(title),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      titleKo: titleKo == null && nullToAbsent
          ? const Value.absent()
          : Value(titleKo),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      contentEn: contentEn == null && nullToAbsent
          ? const Value.absent()
          : Value(contentEn),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      readTimeMinutes: Value(readTimeMinutes),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory Story.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Story(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      titleKo: serializer.fromJson<String?>(json['titleKo']),
      content: serializer.fromJson<String?>(json['content']),
      contentEn: serializer.fromJson<String?>(json['contentEn']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      readTimeMinutes: serializer.fromJson<int>(json['readTimeMinutes']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'titleEn': serializer.toJson<String?>(titleEn),
      'titleKo': serializer.toJson<String?>(titleKo),
      'content': serializer.toJson<String?>(content),
      'contentEn': serializer.toJson<String?>(contentEn),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'readTimeMinutes': serializer.toJson<int>(readTimeMinutes),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  Story copyWith({
    int? id,
    String? title,
    Value<String?> titleEn = const Value.absent(),
    Value<String?> titleKo = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> contentEn = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    int? readTimeMinutes,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => Story(
    id: id ?? this.id,
    title: title ?? this.title,
    titleEn: titleEn.present ? titleEn.value : this.titleEn,
    titleKo: titleKo.present ? titleKo.value : this.titleKo,
    content: content.present ? content.value : this.content,
    contentEn: contentEn.present ? contentEn.value : this.contentEn,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  Story copyWithCompanion(StoriesCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      titleKo: data.titleKo.present ? data.titleKo.value : this.titleKo,
      content: data.content.present ? data.content.value : this.content,
      contentEn: data.contentEn.present ? data.contentEn.value : this.contentEn,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      readTimeMinutes: data.readTimeMinutes.present
          ? data.readTimeMinutes.value
          : this.readTimeMinutes,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleKo: $titleKo, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('readTimeMinutes: $readTimeMinutes, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleEn,
    titleKo,
    content,
    contentEn,
    imageUrl,
    readTimeMinutes,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleEn == this.titleEn &&
          other.titleKo == this.titleKo &&
          other.content == this.content &&
          other.contentEn == this.contentEn &&
          other.imageUrl == this.imageUrl &&
          other.readTimeMinutes == this.readTimeMinutes &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class StoriesCompanion extends UpdateCompanion<Story> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> titleEn;
  final Value<String?> titleKo;
  final Value<String?> content;
  final Value<String?> contentEn;
  final Value<String?> imageUrl;
  final Value<int> readTimeMinutes;
  final Value<DateTime?> lastSyncedAt;
  const StoriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.titleKo = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.readTimeMinutes = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  StoriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.titleEn = const Value.absent(),
    this.titleKo = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.readTimeMinutes = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Story> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? titleEn,
    Expression<String>? titleKo,
    Expression<String>? content,
    Expression<String>? contentEn,
    Expression<String>? imageUrl,
    Expression<int>? readTimeMinutes,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleEn != null) 'title_en': titleEn,
      if (titleKo != null) 'title_ko': titleKo,
      if (content != null) 'content': content,
      if (contentEn != null) 'content_en': contentEn,
      if (imageUrl != null) 'image_url': imageUrl,
      if (readTimeMinutes != null) 'read_time_minutes': readTimeMinutes,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  StoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? titleEn,
    Value<String?>? titleKo,
    Value<String?>? content,
    Value<String?>? contentEn,
    Value<String?>? imageUrl,
    Value<int>? readTimeMinutes,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return StoriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      titleKo: titleKo ?? this.titleKo,
      content: content ?? this.content,
      contentEn: contentEn ?? this.contentEn,
      imageUrl: imageUrl ?? this.imageUrl,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (titleKo.present) {
      map['title_ko'] = Variable<String>(titleKo.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contentEn.present) {
      map['content_en'] = Variable<String>(contentEn.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (readTimeMinutes.present) {
      map['read_time_minutes'] = Variable<int>(readTimeMinutes.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEn: $titleEn, ')
          ..write('titleKo: $titleKo, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('readTimeMinutes: $readTimeMinutes, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $NewsTable extends News with TableInfo<$NewsTable, New> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnMeta = const VerificationMeta(
    'titleEn',
  );
  @override
  late final GeneratedColumn<String> titleEn = GeneratedColumn<String>(
    'title_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentEnMeta = const VerificationMeta(
    'contentEn',
  );
  @override
  late final GeneratedColumn<String> contentEn = GeneratedColumn<String>(
    'content_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('news'),
  );
  static const VerificationMeta _provinceIdMeta = const VerificationMeta(
    'provinceId',
  );
  @override
  late final GeneratedColumn<int> provinceId = GeneratedColumn<int>(
    'province_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES provinces (id)',
    ),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleEn,
    content,
    contentEn,
    type,
    provinceId,
    imageUrl,
    publishedAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'news';
  @override
  VerificationContext validateIntegrity(
    Insertable<New> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_en')) {
      context.handle(
        _titleEnMeta,
        titleEn.isAcceptableOrUnknown(data['title_en']!, _titleEnMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('content_en')) {
      context.handle(
        _contentEnMeta,
        contentEn.isAcceptableOrUnknown(data['content_en']!, _contentEnMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('province_id')) {
      context.handle(
        _provinceIdMeta,
        provinceId.isAcceptableOrUnknown(data['province_id']!, _provinceIdMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  New map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return New(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_en'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      contentEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_en'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      provinceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}province_id'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $NewsTable createAlias(String alias) {
    return $NewsTable(attachedDatabase, alias);
  }
}

class New extends DataClass implements Insertable<New> {
  final int id;
  final String title;
  final String? titleEn;
  final String? content;
  final String? contentEn;
  final String type;
  final int? provinceId;
  final String? imageUrl;
  final DateTime? publishedAt;
  final bool isActive;
  const New({
    required this.id,
    required this.title,
    this.titleEn,
    this.content,
    this.contentEn,
    required this.type,
    this.provinceId,
    this.imageUrl,
    this.publishedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || titleEn != null) {
      map['title_en'] = Variable<String>(titleEn);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || contentEn != null) {
      map['content_en'] = Variable<String>(contentEn);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || provinceId != null) {
      map['province_id'] = Variable<int>(provinceId);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  NewsCompanion toCompanion(bool nullToAbsent) {
    return NewsCompanion(
      id: Value(id),
      title: Value(title),
      titleEn: titleEn == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEn),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      contentEn: contentEn == null && nullToAbsent
          ? const Value.absent()
          : Value(contentEn),
      type: Value(type),
      provinceId: provinceId == null && nullToAbsent
          ? const Value.absent()
          : Value(provinceId),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      isActive: Value(isActive),
    );
  }

  factory New.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return New(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleEn: serializer.fromJson<String?>(json['titleEn']),
      content: serializer.fromJson<String?>(json['content']),
      contentEn: serializer.fromJson<String?>(json['contentEn']),
      type: serializer.fromJson<String>(json['type']),
      provinceId: serializer.fromJson<int?>(json['provinceId']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'titleEn': serializer.toJson<String?>(titleEn),
      'content': serializer.toJson<String?>(content),
      'contentEn': serializer.toJson<String?>(contentEn),
      'type': serializer.toJson<String>(type),
      'provinceId': serializer.toJson<int?>(provinceId),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  New copyWith({
    int? id,
    String? title,
    Value<String?> titleEn = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> contentEn = const Value.absent(),
    String? type,
    Value<int?> provinceId = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<DateTime?> publishedAt = const Value.absent(),
    bool? isActive,
  }) => New(
    id: id ?? this.id,
    title: title ?? this.title,
    titleEn: titleEn.present ? titleEn.value : this.titleEn,
    content: content.present ? content.value : this.content,
    contentEn: contentEn.present ? contentEn.value : this.contentEn,
    type: type ?? this.type,
    provinceId: provinceId.present ? provinceId.value : this.provinceId,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    isActive: isActive ?? this.isActive,
  );
  New copyWithCompanion(NewsCompanion data) {
    return New(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleEn: data.titleEn.present ? data.titleEn.value : this.titleEn,
      content: data.content.present ? data.content.value : this.content,
      contentEn: data.contentEn.present ? data.contentEn.value : this.contentEn,
      type: data.type.present ? data.type.value : this.type,
      provinceId: data.provinceId.present
          ? data.provinceId.value
          : this.provinceId,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('New(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEn: $titleEn, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('type: $type, ')
          ..write('provinceId: $provinceId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleEn,
    content,
    contentEn,
    type,
    provinceId,
    imageUrl,
    publishedAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is New &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleEn == this.titleEn &&
          other.content == this.content &&
          other.contentEn == this.contentEn &&
          other.type == this.type &&
          other.provinceId == this.provinceId &&
          other.imageUrl == this.imageUrl &&
          other.publishedAt == this.publishedAt &&
          other.isActive == this.isActive);
}

class NewsCompanion extends UpdateCompanion<New> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> titleEn;
  final Value<String?> content;
  final Value<String?> contentEn;
  final Value<String> type;
  final Value<int?> provinceId;
  final Value<String?> imageUrl;
  final Value<DateTime?> publishedAt;
  final Value<bool> isActive;
  const NewsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleEn = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.type = const Value.absent(),
    this.provinceId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  NewsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.titleEn = const Value.absent(),
    this.content = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.type = const Value.absent(),
    this.provinceId = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : title = Value(title);
  static Insertable<New> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? titleEn,
    Expression<String>? content,
    Expression<String>? contentEn,
    Expression<String>? type,
    Expression<int>? provinceId,
    Expression<String>? imageUrl,
    Expression<DateTime>? publishedAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleEn != null) 'title_en': titleEn,
      if (content != null) 'content': content,
      if (contentEn != null) 'content_en': contentEn,
      if (type != null) 'type': type,
      if (provinceId != null) 'province_id': provinceId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (publishedAt != null) 'published_at': publishedAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  NewsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? titleEn,
    Value<String?>? content,
    Value<String?>? contentEn,
    Value<String>? type,
    Value<int?>? provinceId,
    Value<String?>? imageUrl,
    Value<DateTime?>? publishedAt,
    Value<bool>? isActive,
  }) {
    return NewsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEn: titleEn ?? this.titleEn,
      content: content ?? this.content,
      contentEn: contentEn ?? this.contentEn,
      type: type ?? this.type,
      provinceId: provinceId ?? this.provinceId,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleEn.present) {
      map['title_en'] = Variable<String>(titleEn.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contentEn.present) {
      map['content_en'] = Variable<String>(contentEn.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (provinceId.present) {
      map['province_id'] = Variable<int>(provinceId.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEn: $titleEn, ')
          ..write('content: $content, ')
          ..write('contentEn: $contentEn, ')
          ..write('type: $type, ')
          ..write('provinceId: $provinceId, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services
    with TableInfo<$ServicesTable, ServiceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceRangeMeta = const VerificationMeta(
    'priceRange',
  );
  @override
  late final GeneratedColumn<String> priceRange = GeneratedColumn<String>(
    'price_range',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    category,
    description,
    descriptionEn,
    lat,
    lng,
    address,
    phone,
    website,
    imageUrl,
    rating,
    priceRange,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('price_range')) {
      context.handle(
        _priceRangeMeta,
        priceRange.isAcceptableOrUnknown(data['price_range']!, _priceRangeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      ),
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      ),
      priceRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_range'],
      ),
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class ServiceEntry extends DataClass implements Insertable<ServiceEntry> {
  final int id;
  final String name;
  final String? nameEn;
  final String? category;
  final String? description;
  final String? descriptionEn;
  final double? lat;
  final double? lng;
  final String? address;
  final String? phone;
  final String? website;
  final String? imageUrl;
  final double? rating;
  final String? priceRange;
  const ServiceEntry({
    required this.id,
    required this.name,
    this.nameEn,
    this.category,
    this.description,
    this.descriptionEn,
    this.lat,
    this.lng,
    this.address,
    this.phone,
    this.website,
    this.imageUrl,
    this.rating,
    this.priceRange,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameEn != null) {
      map['name_en'] = Variable<String>(nameEn);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || descriptionEn != null) {
      map['description_en'] = Variable<String>(descriptionEn);
    }
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    if (!nullToAbsent || priceRange != null) {
      map['price_range'] = Variable<String>(priceRange);
    }
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: nameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(nameEn),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      descriptionEn: descriptionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionEn),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      priceRange: priceRange == null && nullToAbsent
          ? const Value.absent()
          : Value(priceRange),
    );
  }

  factory ServiceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String?>(json['nameEn']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      descriptionEn: serializer.fromJson<String?>(json['descriptionEn']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      rating: serializer.fromJson<double?>(json['rating']),
      priceRange: serializer.fromJson<String?>(json['priceRange']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String?>(nameEn),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'descriptionEn': serializer.toJson<String?>(descriptionEn),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'rating': serializer.toJson<double?>(rating),
      'priceRange': serializer.toJson<String?>(priceRange),
    };
  }

  ServiceEntry copyWith({
    int? id,
    String? name,
    Value<String?> nameEn = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> descriptionEn = const Value.absent(),
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    Value<double?> rating = const Value.absent(),
    Value<String?> priceRange = const Value.absent(),
  }) => ServiceEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn.present ? nameEn.value : this.nameEn,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    descriptionEn: descriptionEn.present
        ? descriptionEn.value
        : this.descriptionEn,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    address: address.present ? address.value : this.address,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    rating: rating.present ? rating.value : this.rating,
    priceRange: priceRange.present ? priceRange.value : this.priceRange,
  );
  ServiceEntry copyWithCompanion(ServicesCompanion data) {
    return ServiceEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      rating: data.rating.present ? data.rating.value : this.rating,
      priceRange: data.priceRange.present
          ? data.priceRange.value
          : this.priceRange,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('priceRange: $priceRange')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    category,
    description,
    descriptionEn,
    lat,
    lng,
    address,
    phone,
    website,
    imageUrl,
    rating,
    priceRange,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.category == this.category &&
          other.description == this.description &&
          other.descriptionEn == this.descriptionEn &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.imageUrl == this.imageUrl &&
          other.rating == this.rating &&
          other.priceRange == this.priceRange);
}

class ServicesCompanion extends UpdateCompanion<ServiceEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameEn;
  final Value<String?> category;
  final Value<String?> description;
  final Value<String?> descriptionEn;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> imageUrl;
  final Value<double?> rating;
  final Value<String?> priceRange;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.priceRange = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameEn = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rating = const Value.absent(),
    this.priceRange = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ServiceEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? descriptionEn,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? imageUrl,
    Expression<double>? rating,
    Expression<String>? priceRange,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rating != null) 'rating': rating,
      if (priceRange != null) 'price_range': priceRange,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameEn,
    Value<String?>? category,
    Value<String?>? description,
    Value<String?>? descriptionEn,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<String?>? address,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? imageUrl,
    Value<double?>? rating,
    Value<String?>? priceRange,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      priceRange: priceRange ?? this.priceRange,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (priceRange.present) {
      map['price_range'] = Variable<String>(priceRange.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rating: $rating, ')
          ..write('priceRange: $priceRange')
          ..write(')'))
        .toString();
  }
}

class $AudioCacheTable extends AudioCache
    with TableInfo<$AudioCacheTable, AudioCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
    'downloaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    placeId,
    language,
    audioUrl,
    localPath,
    fileSize,
    downloadedAt,
    lastPlayedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_audioUrlMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId, language};
  @override
  AudioCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioCacheData(
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}downloaded_at'],
      )!,
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
    );
  }

  @override
  $AudioCacheTable createAlias(String alias) {
    return $AudioCacheTable(attachedDatabase, alias);
  }
}

class AudioCacheData extends DataClass implements Insertable<AudioCacheData> {
  final int placeId;
  final String language;
  final String audioUrl;
  final String localPath;
  final int fileSize;
  final DateTime downloadedAt;
  final DateTime? lastPlayedAt;
  const AudioCacheData({
    required this.placeId,
    required this.language,
    required this.audioUrl,
    required this.localPath,
    required this.fileSize,
    required this.downloadedAt,
    this.lastPlayedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<int>(placeId);
    map['language'] = Variable<String>(language);
    map['audio_url'] = Variable<String>(audioUrl);
    map['local_path'] = Variable<String>(localPath);
    map['file_size'] = Variable<int>(fileSize);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    return map;
  }

  AudioCacheCompanion toCompanion(bool nullToAbsent) {
    return AudioCacheCompanion(
      placeId: Value(placeId),
      language: Value(language),
      audioUrl: Value(audioUrl),
      localPath: Value(localPath),
      fileSize: Value(fileSize),
      downloadedAt: Value(downloadedAt),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
    );
  }

  factory AudioCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioCacheData(
      placeId: serializer.fromJson<int>(json['placeId']),
      language: serializer.fromJson<String>(json['language']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      localPath: serializer.fromJson<String>(json['localPath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<int>(placeId),
      'language': serializer.toJson<String>(language),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'localPath': serializer.toJson<String>(localPath),
      'fileSize': serializer.toJson<int>(fileSize),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
    };
  }

  AudioCacheData copyWith({
    int? placeId,
    String? language,
    String? audioUrl,
    String? localPath,
    int? fileSize,
    DateTime? downloadedAt,
    Value<DateTime?> lastPlayedAt = const Value.absent(),
  }) => AudioCacheData(
    placeId: placeId ?? this.placeId,
    language: language ?? this.language,
    audioUrl: audioUrl ?? this.audioUrl,
    localPath: localPath ?? this.localPath,
    fileSize: fileSize ?? this.fileSize,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
  );
  AudioCacheData copyWithCompanion(AudioCacheCompanion data) {
    return AudioCacheData(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      language: data.language.present ? data.language.value : this.language,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioCacheData(')
          ..write('placeId: $placeId, ')
          ..write('language: $language, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localPath: $localPath, ')
          ..write('fileSize: $fileSize, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('lastPlayedAt: $lastPlayedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    placeId,
    language,
    audioUrl,
    localPath,
    fileSize,
    downloadedAt,
    lastPlayedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioCacheData &&
          other.placeId == this.placeId &&
          other.language == this.language &&
          other.audioUrl == this.audioUrl &&
          other.localPath == this.localPath &&
          other.fileSize == this.fileSize &&
          other.downloadedAt == this.downloadedAt &&
          other.lastPlayedAt == this.lastPlayedAt);
}

class AudioCacheCompanion extends UpdateCompanion<AudioCacheData> {
  final Value<int> placeId;
  final Value<String> language;
  final Value<String> audioUrl;
  final Value<String> localPath;
  final Value<int> fileSize;
  final Value<DateTime> downloadedAt;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> rowid;
  const AudioCacheCompanion({
    this.placeId = const Value.absent(),
    this.language = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.localPath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AudioCacheCompanion.insert({
    required int placeId,
    required String language,
    required String audioUrl,
    required String localPath,
    this.fileSize = const Value.absent(),
    required DateTime downloadedAt,
    this.lastPlayedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       language = Value(language),
       audioUrl = Value(audioUrl),
       localPath = Value(localPath),
       downloadedAt = Value(downloadedAt);
  static Insertable<AudioCacheData> custom({
    Expression<int>? placeId,
    Expression<String>? language,
    Expression<String>? audioUrl,
    Expression<String>? localPath,
    Expression<int>? fileSize,
    Expression<DateTime>? downloadedAt,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (language != null) 'language': language,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (localPath != null) 'local_path': localPath,
      if (fileSize != null) 'file_size': fileSize,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AudioCacheCompanion copyWith({
    Value<int>? placeId,
    Value<String>? language,
    Value<String>? audioUrl,
    Value<String>? localPath,
    Value<int>? fileSize,
    Value<DateTime>? downloadedAt,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? rowid,
  }) {
    return AudioCacheCompanion(
      placeId: placeId ?? this.placeId,
      language: language ?? this.language,
      audioUrl: audioUrl ?? this.audioUrl,
      localPath: localPath ?? this.localPath,
      fileSize: fileSize ?? this.fileSize,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioCacheCompanion(')
          ..write('placeId: $placeId, ')
          ..write('language: $language, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localPath: $localPath, ')
          ..write('fileSize: $fileSize, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletTable extends Wallet with TableInfo<$WalletTable, WalletData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceUuidMeta = const VerificationMeta(
    'deviceUuid',
  );
  @override
  late final GeneratedColumn<String> deviceUuid = GeneratedColumn<String>(
    'device_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalEarnedMeta = const VerificationMeta(
    'totalEarned',
  );
  @override
  late final GeneratedColumn<int> totalEarned = GeneratedColumn<int>(
    'total_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalSpentMeta = const VerificationMeta(
    'totalSpent',
  );
  @override
  late final GeneratedColumn<int> totalSpent = GeneratedColumn<int>(
    'total_spent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceUuid,
    balance,
    totalEarned,
    totalSpent,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_uuid')) {
      context.handle(
        _deviceUuidMeta,
        deviceUuid.isAcceptableOrUnknown(data['device_uuid']!, _deviceUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceUuidMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    }
    if (data.containsKey('total_earned')) {
      context.handle(
        _totalEarnedMeta,
        totalEarned.isAcceptableOrUnknown(
          data['total_earned']!,
          _totalEarnedMeta,
        ),
      );
    }
    if (data.containsKey('total_spent')) {
      context.handle(
        _totalSpentMeta,
        totalSpent.isAcceptableOrUnknown(data['total_spent']!, _totalSpentMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceUuid};
  @override
  WalletData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletData(
      deviceUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_uuid'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
      totalEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_earned'],
      )!,
      totalSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_spent'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $WalletTable createAlias(String alias) {
    return $WalletTable(attachedDatabase, alias);
  }
}

class WalletData extends DataClass implements Insertable<WalletData> {
  final String deviceUuid;
  final int balance;
  final int totalEarned;
  final int totalSpent;
  final DateTime? lastSyncedAt;
  const WalletData({
    required this.deviceUuid,
    required this.balance,
    required this.totalEarned,
    required this.totalSpent,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_uuid'] = Variable<String>(deviceUuid);
    map['balance'] = Variable<int>(balance);
    map['total_earned'] = Variable<int>(totalEarned);
    map['total_spent'] = Variable<int>(totalSpent);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  WalletCompanion toCompanion(bool nullToAbsent) {
    return WalletCompanion(
      deviceUuid: Value(deviceUuid),
      balance: Value(balance),
      totalEarned: Value(totalEarned),
      totalSpent: Value(totalSpent),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory WalletData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletData(
      deviceUuid: serializer.fromJson<String>(json['deviceUuid']),
      balance: serializer.fromJson<int>(json['balance']),
      totalEarned: serializer.fromJson<int>(json['totalEarned']),
      totalSpent: serializer.fromJson<int>(json['totalSpent']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceUuid': serializer.toJson<String>(deviceUuid),
      'balance': serializer.toJson<int>(balance),
      'totalEarned': serializer.toJson<int>(totalEarned),
      'totalSpent': serializer.toJson<int>(totalSpent),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  WalletData copyWith({
    String? deviceUuid,
    int? balance,
    int? totalEarned,
    int? totalSpent,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => WalletData(
    deviceUuid: deviceUuid ?? this.deviceUuid,
    balance: balance ?? this.balance,
    totalEarned: totalEarned ?? this.totalEarned,
    totalSpent: totalSpent ?? this.totalSpent,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  WalletData copyWithCompanion(WalletCompanion data) {
    return WalletData(
      deviceUuid: data.deviceUuid.present
          ? data.deviceUuid.value
          : this.deviceUuid,
      balance: data.balance.present ? data.balance.value : this.balance,
      totalEarned: data.totalEarned.present
          ? data.totalEarned.value
          : this.totalEarned,
      totalSpent: data.totalSpent.present
          ? data.totalSpent.value
          : this.totalSpent,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletData(')
          ..write('deviceUuid: $deviceUuid, ')
          ..write('balance: $balance, ')
          ..write('totalEarned: $totalEarned, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(deviceUuid, balance, totalEarned, totalSpent, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletData &&
          other.deviceUuid == this.deviceUuid &&
          other.balance == this.balance &&
          other.totalEarned == this.totalEarned &&
          other.totalSpent == this.totalSpent &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class WalletCompanion extends UpdateCompanion<WalletData> {
  final Value<String> deviceUuid;
  final Value<int> balance;
  final Value<int> totalEarned;
  final Value<int> totalSpent;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const WalletCompanion({
    this.deviceUuid = const Value.absent(),
    this.balance = const Value.absent(),
    this.totalEarned = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletCompanion.insert({
    required String deviceUuid,
    this.balance = const Value.absent(),
    this.totalEarned = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceUuid = Value(deviceUuid);
  static Insertable<WalletData> custom({
    Expression<String>? deviceUuid,
    Expression<int>? balance,
    Expression<int>? totalEarned,
    Expression<int>? totalSpent,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceUuid != null) 'device_uuid': deviceUuid,
      if (balance != null) 'balance': balance,
      if (totalEarned != null) 'total_earned': totalEarned,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletCompanion copyWith({
    Value<String>? deviceUuid,
    Value<int>? balance,
    Value<int>? totalEarned,
    Value<int>? totalSpent,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return WalletCompanion(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      balance: balance ?? this.balance,
      totalEarned: totalEarned ?? this.totalEarned,
      totalSpent: totalSpent ?? this.totalSpent,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceUuid.present) {
      map['device_uuid'] = Variable<String>(deviceUuid.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (totalEarned.present) {
      map['total_earned'] = Variable<int>(totalEarned.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<int>(totalSpent.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletCompanion(')
          ..write('deviceUuid: $deviceUuid, ')
          ..write('balance: $balance, ')
          ..write('totalEarned: $totalEarned, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckinsTable extends Checkins with TableInfo<$CheckinsTable, Checkin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowersEarnedMeta = const VerificationMeta(
    'flowersEarned',
  );
  @override
  late final GeneratedColumn<int> flowersEarned = GeneratedColumn<int>(
    'flowers_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeId,
    placeName,
    method,
    flowersEarned,
    lat,
    lng,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checkin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_placeNameMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('flowers_earned')) {
      context.handle(
        _flowersEarnedMeta,
        flowersEarned.isAcceptableOrUnknown(
          data['flowers_earned']!,
          _flowersEarnedMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
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
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checkin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checkin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      flowersEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flowers_earned'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $CheckinsTable createAlias(String alias) {
    return $CheckinsTable(attachedDatabase, alias);
  }
}

class Checkin extends DataClass implements Insertable<Checkin> {
  final int id;
  final int placeId;
  final String placeName;
  final String method;
  final int flowersEarned;
  final double? lat;
  final double? lng;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const Checkin({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.method,
    required this.flowersEarned,
    this.lat,
    this.lng,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['place_id'] = Variable<int>(placeId);
    map['place_name'] = Variable<String>(placeName);
    map['method'] = Variable<String>(method);
    map['flowers_earned'] = Variable<int>(flowersEarned);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CheckinsCompanion toCompanion(bool nullToAbsent) {
    return CheckinsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      placeName: Value(placeName),
      method: Value(method),
      flowersEarned: Value(flowersEarned),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory Checkin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checkin(
      id: serializer.fromJson<int>(json['id']),
      placeId: serializer.fromJson<int>(json['placeId']),
      placeName: serializer.fromJson<String>(json['placeName']),
      method: serializer.fromJson<String>(json['method']),
      flowersEarned: serializer.fromJson<int>(json['flowersEarned']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'placeId': serializer.toJson<int>(placeId),
      'placeName': serializer.toJson<String>(placeName),
      'method': serializer.toJson<String>(method),
      'flowersEarned': serializer.toJson<int>(flowersEarned),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  Checkin copyWith({
    int? id,
    int? placeId,
    String? placeName,
    String? method,
    int? flowersEarned,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => Checkin(
    id: id ?? this.id,
    placeId: placeId ?? this.placeId,
    placeName: placeName ?? this.placeName,
    method: method ?? this.method,
    flowersEarned: flowersEarned ?? this.flowersEarned,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  Checkin copyWithCompanion(CheckinsCompanion data) {
    return Checkin(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      method: data.method.present ? data.method.value : this.method,
      flowersEarned: data.flowersEarned.present
          ? data.flowersEarned.value
          : this.flowersEarned,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checkin(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('placeName: $placeName, ')
          ..write('method: $method, ')
          ..write('flowersEarned: $flowersEarned, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    placeId,
    placeName,
    method,
    flowersEarned,
    lat,
    lng,
    createdAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checkin &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.placeName == this.placeName &&
          other.method == this.method &&
          other.flowersEarned == this.flowersEarned &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class CheckinsCompanion extends UpdateCompanion<Checkin> {
  final Value<int> id;
  final Value<int> placeId;
  final Value<String> placeName;
  final Value<String> method;
  final Value<int> flowersEarned;
  final Value<double?> lat;
  final Value<double?> lng;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  const CheckinsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.placeName = const Value.absent(),
    this.method = const Value.absent(),
    this.flowersEarned = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CheckinsCompanion.insert({
    this.id = const Value.absent(),
    required int placeId,
    required String placeName,
    required String method,
    this.flowersEarned = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
  }) : placeId = Value(placeId),
       placeName = Value(placeName),
       method = Value(method),
       createdAt = Value(createdAt);
  static Insertable<Checkin> custom({
    Expression<int>? id,
    Expression<int>? placeId,
    Expression<String>? placeName,
    Expression<String>? method,
    Expression<int>? flowersEarned,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (placeName != null) 'place_name': placeName,
      if (method != null) 'method': method,
      if (flowersEarned != null) 'flowers_earned': flowersEarned,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CheckinsCompanion copyWith({
    Value<int>? id,
    Value<int>? placeId,
    Value<String>? placeName,
    Value<String>? method,
    Value<int>? flowersEarned,
    Value<double?>? lat,
    Value<double?>? lng,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
  }) {
    return CheckinsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      method: method ?? this.method,
      flowersEarned: flowersEarned ?? this.flowersEarned,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (flowersEarned.present) {
      map['flowers_earned'] = Variable<int>(flowersEarned.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckinsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('placeName: $placeName, ')
          ..write('method: $method, ')
          ..write('flowersEarned: $flowersEarned, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _endpointMeta = const VerificationMeta(
    'endpoint',
  );
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
    'endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retriesLeftMeta = const VerificationMeta(
    'retriesLeft',
  );
  @override
  late final GeneratedColumn<int> retriesLeft = GeneratedColumn<int>(
    'retries_left',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    endpoint,
    method,
    payload,
    createdAt,
    status,
    retriesLeft,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('endpoint')) {
      context.handle(
        _endpointMeta,
        endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta),
      );
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retries_left')) {
      context.handle(
        _retriesLeftMeta,
        retriesLeft.isAcceptableOrUnknown(
          data['retries_left']!,
          _retriesLeftMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endpoint'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retriesLeft: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retries_left'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String endpoint;
  final String method;
  final String payload;
  final DateTime createdAt;
  final String status;
  final int retriesLeft;
  const SyncQueueData({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.createdAt,
    required this.status,
    required this.retriesLeft,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['endpoint'] = Variable<String>(endpoint);
    map['method'] = Variable<String>(method);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['retries_left'] = Variable<int>(retriesLeft);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      endpoint: Value(endpoint),
      method: Value(method),
      payload: Value(payload),
      createdAt: Value(createdAt),
      status: Value(status),
      retriesLeft: Value(retriesLeft),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      method: serializer.fromJson<String>(json['method']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      retriesLeft: serializer.fromJson<int>(json['retriesLeft']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'endpoint': serializer.toJson<String>(endpoint),
      'method': serializer.toJson<String>(method),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'retriesLeft': serializer.toJson<int>(retriesLeft),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? endpoint,
    String? method,
    String? payload,
    DateTime? createdAt,
    String? status,
    int? retriesLeft,
  }) => SyncQueueData(
    id: id ?? this.id,
    endpoint: endpoint ?? this.endpoint,
    method: method ?? this.method,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retriesLeft: retriesLeft ?? this.retriesLeft,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      method: data.method.present ? data.method.value : this.method,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retriesLeft: data.retriesLeft.present
          ? data.retriesLeft.value
          : this.retriesLeft,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retriesLeft: $retriesLeft')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    endpoint,
    method,
    payload,
    createdAt,
    status,
    retriesLeft,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.endpoint == this.endpoint &&
          other.method == this.method &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retriesLeft == this.retriesLeft);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> endpoint;
  final Value<String> method;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> retriesLeft;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.method = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retriesLeft = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String endpoint,
    required String method,
    required String payload,
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.retriesLeft = const Value.absent(),
  }) : endpoint = Value(endpoint),
       method = Value(method),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? endpoint,
    Expression<String>? method,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? retriesLeft,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retriesLeft != null) 'retries_left': retriesLeft,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? endpoint,
    Value<String>? method,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? retriesLeft,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retriesLeft: retriesLeft ?? this.retriesLeft,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retriesLeft.present) {
      map['retries_left'] = Variable<int>(retriesLeft.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('method: $method, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retriesLeft: $retriesLeft')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProvincesTable provinces = $ProvincesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $SubPlacesTable subPlaces = $SubPlacesTable(this);
  late final $JourneysTable journeys = $JourneysTable(this);
  late final $JourneyStopsTable journeyStops = $JourneyStopsTable(this);
  late final $StoriesTable stories = $StoriesTable(this);
  late final $NewsTable news = $NewsTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $AudioCacheTable audioCache = $AudioCacheTable(this);
  late final $WalletTable wallet = $WalletTable(this);
  late final $CheckinsTable checkins = $CheckinsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final ProvinceDao provinceDao = ProvinceDao(this as AppDatabase);
  late final LocationDao locationDao = LocationDao(this as AppDatabase);
  late final PlaceDao placeDao = PlaceDao(this as AppDatabase);
  late final JourneyDao journeyDao = JourneyDao(this as AppDatabase);
  late final StoryDao storyDao = StoryDao(this as AppDatabase);
  late final SyncDao syncDao = SyncDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    provinces,
    locations,
    places,
    subPlaces,
    journeys,
    journeyStops,
    stories,
    news,
    services,
    audioCache,
    wallet,
    checkins,
    syncQueue,
  ];
}

typedef $$ProvincesTableCreateCompanionBuilder =
    ProvincesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      required double lat,
      required double lng,
      Value<String?> imageUrl,
      Value<bool> isActive,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$ProvincesTableUpdateCompanionBuilder =
    ProvincesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      Value<double> lat,
      Value<double> lng,
      Value<String?> imageUrl,
      Value<bool> isActive,
      Value<DateTime?> lastSyncedAt,
    });

final class $$ProvincesTableReferences
    extends BaseReferences<_$AppDatabase, $ProvincesTable, Province> {
  $$ProvincesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LocationsTable, List<Location>>
  _locationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.locations,
    aliasName: $_aliasNameGenerator(db.provinces.id, db.locations.provinceId),
  );

  $$LocationsTableProcessedTableManager get locationsRefs {
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.provinceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_locationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NewsTable, List<New>> _newsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.news,
    aliasName: $_aliasNameGenerator(db.provinces.id, db.news.provinceId),
  );

  $$NewsTableProcessedTableManager get newsRefs {
    final manager = $$NewsTableTableManager(
      $_db,
      $_db.news,
    ).filter((f) => f.provinceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_newsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProvincesTableFilterComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> locationsRefs(
    Expression<bool> Function($$LocationsTableFilterComposer f) f,
  ) {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> newsRefs(
    Expression<bool> Function($$NewsTableFilterComposer f) f,
  ) {
    final $$NewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.news,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NewsTableFilterComposer(
            $db: $db,
            $table: $db.news,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvincesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProvincesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameKo =>
      $composableBuilder(column: $table.nameKo, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  Expression<T> locationsRefs<T extends Object>(
    Expression<T> Function($$LocationsTableAnnotationComposer a) f,
  ) {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> newsRefs<T extends Object>(
    Expression<T> Function($$NewsTableAnnotationComposer a) f,
  ) {
    final $$NewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.news,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NewsTableAnnotationComposer(
            $db: $db,
            $table: $db.news,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvincesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProvincesTable,
          Province,
          $$ProvincesTableFilterComposer,
          $$ProvincesTableOrderingComposer,
          $$ProvincesTableAnnotationComposer,
          $$ProvincesTableCreateCompanionBuilder,
          $$ProvincesTableUpdateCompanionBuilder,
          (Province, $$ProvincesTableReferences),
          Province,
          PrefetchHooks Function({bool locationsRefs, bool newsRefs})
        > {
  $$ProvincesTableTableManager(_$AppDatabase db, $ProvincesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvincesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvincesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvincesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => ProvincesCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                lat: lat,
                lng: lng,
                imageUrl: imageUrl,
                isActive: isActive,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required double lat,
                required double lng,
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => ProvincesCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                lat: lat,
                lng: lng,
                imageUrl: imageUrl,
                isActive: isActive,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProvincesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({locationsRefs = false, newsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (locationsRefs) db.locations,
                if (newsRefs) db.news,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (locationsRefs)
                    await $_getPrefetchedData<
                      Province,
                      $ProvincesTable,
                      Location
                    >(
                      currentTable: table,
                      referencedTable: $$ProvincesTableReferences
                          ._locationsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProvincesTableReferences(
                            db,
                            table,
                            p0,
                          ).locationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.provinceId == item.id),
                      typedResults: items,
                    ),
                  if (newsRefs)
                    await $_getPrefetchedData<Province, $ProvincesTable, New>(
                      currentTable: table,
                      referencedTable: $$ProvincesTableReferences
                          ._newsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProvincesTableReferences(db, table, p0).newsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.provinceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProvincesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProvincesTable,
      Province,
      $$ProvincesTableFilterComposer,
      $$ProvincesTableOrderingComposer,
      $$ProvincesTableAnnotationComposer,
      $$ProvincesTableCreateCompanionBuilder,
      $$ProvincesTableUpdateCompanionBuilder,
      (Province, $$ProvincesTableReferences),
      Province,
      PrefetchHooks Function({bool locationsRefs, bool newsRefs})
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      Value<int> id,
      required int provinceId,
      required String name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      Value<int> orderNum,
      Value<String?> imageUrl,
      required double lat,
      required double lng,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<int> id,
      Value<int> provinceId,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      Value<int> orderNum,
      Value<String?> imageUrl,
      Value<double> lat,
      Value<double> lng,
      Value<DateTime?> lastSyncedAt,
    });

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, Location> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProvincesTable _provinceIdTable(_$AppDatabase db) =>
      db.provinces.createAlias(
        $_aliasNameGenerator(db.locations.provinceId, db.provinces.id),
      );

  $$ProvincesTableProcessedTableManager get provinceId {
    final $_column = $_itemColumn<int>('province_id')!;

    final manager = $$ProvincesTableTableManager(
      $_db,
      $_db.provinces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_provinceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlacesTable, List<Place>> _placesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.places,
    aliasName: $_aliasNameGenerator(db.locations.id, db.places.locationId),
  );

  $$PlacesTableProcessedTableManager get placesRefs {
    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_placesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProvincesTableFilterComposer get provinceId {
    final $$ProvincesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableFilterComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> placesRefs(
    Expression<bool> Function($$PlacesTableFilterComposer f) f,
  ) {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProvincesTableOrderingComposer get provinceId {
    final $$ProvincesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableOrderingComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameKo =>
      $composableBuilder(column: $table.nameKo, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderNum =>
      $composableBuilder(column: $table.orderNum, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$ProvincesTableAnnotationComposer get provinceId {
    final $$ProvincesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableAnnotationComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> placesRefs<T extends Object>(
    Expression<T> Function($$PlacesTableAnnotationComposer a) f,
  ) {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          Location,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (Location, $$LocationsTableReferences),
          Location,
          PrefetchHooks Function({bool provinceId, bool placesRefs})
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> provinceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> orderNum = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => LocationsCompanion(
                id: id,
                provinceId: provinceId,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                orderNum: orderNum,
                imageUrl: imageUrl,
                lat: lat,
                lng: lng,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int provinceId,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> orderNum = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required double lat,
                required double lng,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => LocationsCompanion.insert(
                id: id,
                provinceId: provinceId,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                orderNum: orderNum,
                imageUrl: imageUrl,
                lat: lat,
                lng: lng,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({provinceId = false, placesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (placesRefs) db.places],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (provinceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.provinceId,
                                referencedTable: $$LocationsTableReferences
                                    ._provinceIdTable(db),
                                referencedColumn: $$LocationsTableReferences
                                    ._provinceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (placesRefs)
                    await $_getPrefetchedData<Location, $LocationsTable, Place>(
                      currentTable: table,
                      referencedTable: $$LocationsTableReferences
                          ._placesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocationsTableReferences(db, table, p0).placesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.locationId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      Location,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (Location, $$LocationsTableReferences),
      Location,
      PrefetchHooks Function({bool provinceId, bool placesRefs})
    >;
typedef $$PlacesTableCreateCompanionBuilder =
    PlacesCompanion Function({
      Value<int> id,
      required int locationId,
      required String name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      required String slug,
      Value<String?> description,
      Value<String?> descriptionEn,
      required double lat,
      required double lng,
      Value<String?> imageUrl,
      Value<String?> audioUrlVi,
      Value<String?> audioUrlEn,
      Value<String?> audioUrlKo,
      Value<String?> audioUrlZh,
      Value<int> audioDuration,
      Value<String?> category,
      Value<String?> difficulty,
      Value<int> flowerCost,
      Value<String?> qrCode,
      Value<String?> status,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$PlacesTableUpdateCompanionBuilder =
    PlacesCompanion Function({
      Value<int> id,
      Value<int> locationId,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String> slug,
      Value<String?> description,
      Value<String?> descriptionEn,
      Value<double> lat,
      Value<double> lng,
      Value<String?> imageUrl,
      Value<String?> audioUrlVi,
      Value<String?> audioUrlEn,
      Value<String?> audioUrlKo,
      Value<String?> audioUrlZh,
      Value<int> audioDuration,
      Value<String?> category,
      Value<String?> difficulty,
      Value<int> flowerCost,
      Value<String?> qrCode,
      Value<String?> status,
      Value<DateTime?> lastSyncedAt,
    });

final class $$PlacesTableReferences
    extends BaseReferences<_$AppDatabase, $PlacesTable, Place> {
  $$PlacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LocationsTable _locationIdTable(_$AppDatabase db) => db.locations
      .createAlias($_aliasNameGenerator(db.places.locationId, db.locations.id));

  $$LocationsTableProcessedTableManager get locationId {
    final $_column = $_itemColumn<int>('location_id')!;

    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SubPlacesTable, List<SubPlace>>
  _subPlacesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subPlaces,
    aliasName: $_aliasNameGenerator(db.places.id, db.subPlaces.placeId),
  );

  $$SubPlacesTableProcessedTableManager get subPlacesRefs {
    final manager = $$SubPlacesTableTableManager(
      $_db,
      $_db.subPlaces,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subPlacesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$JourneyStopsTable, List<JourneyStop>>
  _journeyStopsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journeyStops,
    aliasName: $_aliasNameGenerator(db.places.id, db.journeyStops.placeId),
  );

  $$JourneyStopsTableProcessedTableManager get journeyStopsRefs {
    final manager = $$JourneyStopsTableTableManager(
      $_db,
      $_db.journeyStops,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_journeyStopsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AudioCacheTable, List<AudioCacheData>>
  _audioCacheRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.audioCache,
    aliasName: $_aliasNameGenerator(db.places.id, db.audioCache.placeId),
  );

  $$AudioCacheTableProcessedTableManager get audioCacheRefs {
    final manager = $$AudioCacheTableTableManager(
      $_db,
      $_db.audioCache,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_audioCacheRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrlVi => $composableBuilder(
    column: $table.audioUrlVi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrlEn => $composableBuilder(
    column: $table.audioUrlEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrlKo => $composableBuilder(
    column: $table.audioUrlKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrlZh => $composableBuilder(
    column: $table.audioUrlZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flowerCost => $composableBuilder(
    column: $table.flowerCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> subPlacesRefs(
    Expression<bool> Function($$SubPlacesTableFilterComposer f) f,
  ) {
    final $$SubPlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subPlaces,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubPlacesTableFilterComposer(
            $db: $db,
            $table: $db.subPlaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journeyStopsRefs(
    Expression<bool> Function($$JourneyStopsTableFilterComposer f) f,
  ) {
    final $$JourneyStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyStops,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyStopsTableFilterComposer(
            $db: $db,
            $table: $db.journeyStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> audioCacheRefs(
    Expression<bool> Function($$AudioCacheTableFilterComposer f) f,
  ) {
    final $$AudioCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioCache,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioCacheTableFilterComposer(
            $db: $db,
            $table: $db.audioCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrlVi => $composableBuilder(
    column: $table.audioUrlVi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrlEn => $composableBuilder(
    column: $table.audioUrlEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrlKo => $composableBuilder(
    column: $table.audioUrlKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrlZh => $composableBuilder(
    column: $table.audioUrlZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flowerCost => $composableBuilder(
    column: $table.flowerCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameKo =>
      $composableBuilder(column: $table.nameKo, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get audioUrlVi => $composableBuilder(
    column: $table.audioUrlVi,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrlEn => $composableBuilder(
    column: $table.audioUrlEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrlKo => $composableBuilder(
    column: $table.audioUrlKo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioUrlZh => $composableBuilder(
    column: $table.audioUrlZh,
    builder: (column) => column,
  );

  GeneratedColumn<int> get audioDuration => $composableBuilder(
    column: $table.audioDuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flowerCost => $composableBuilder(
    column: $table.flowerCost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> subPlacesRefs<T extends Object>(
    Expression<T> Function($$SubPlacesTableAnnotationComposer a) f,
  ) {
    final $$SubPlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subPlaces,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubPlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.subPlaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journeyStopsRefs<T extends Object>(
    Expression<T> Function($$JourneyStopsTableAnnotationComposer a) f,
  ) {
    final $$JourneyStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyStops,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.journeyStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> audioCacheRefs<T extends Object>(
    Expression<T> Function($$AudioCacheTableAnnotationComposer a) f,
  ) {
    final $$AudioCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioCache,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.audioCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTable,
          Place,
          $$PlacesTableFilterComposer,
          $$PlacesTableOrderingComposer,
          $$PlacesTableAnnotationComposer,
          $$PlacesTableCreateCompanionBuilder,
          $$PlacesTableUpdateCompanionBuilder,
          (Place, $$PlacesTableReferences),
          Place,
          PrefetchHooks Function({
            bool locationId,
            bool subPlacesRefs,
            bool journeyStopsRefs,
            bool audioCacheRefs,
          })
        > {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> locationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lng = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> audioUrlVi = const Value.absent(),
                Value<String?> audioUrlEn = const Value.absent(),
                Value<String?> audioUrlKo = const Value.absent(),
                Value<String?> audioUrlZh = const Value.absent(),
                Value<int> audioDuration = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<int> flowerCost = const Value.absent(),
                Value<String?> qrCode = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => PlacesCompanion(
                id: id,
                locationId: locationId,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                slug: slug,
                description: description,
                descriptionEn: descriptionEn,
                lat: lat,
                lng: lng,
                imageUrl: imageUrl,
                audioUrlVi: audioUrlVi,
                audioUrlEn: audioUrlEn,
                audioUrlKo: audioUrlKo,
                audioUrlZh: audioUrlZh,
                audioDuration: audioDuration,
                category: category,
                difficulty: difficulty,
                flowerCost: flowerCost,
                qrCode: qrCode,
                status: status,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int locationId,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                required String slug,
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                required double lat,
                required double lng,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> audioUrlVi = const Value.absent(),
                Value<String?> audioUrlEn = const Value.absent(),
                Value<String?> audioUrlKo = const Value.absent(),
                Value<String?> audioUrlZh = const Value.absent(),
                Value<int> audioDuration = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<int> flowerCost = const Value.absent(),
                Value<String?> qrCode = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => PlacesCompanion.insert(
                id: id,
                locationId: locationId,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                slug: slug,
                description: description,
                descriptionEn: descriptionEn,
                lat: lat,
                lng: lng,
                imageUrl: imageUrl,
                audioUrlVi: audioUrlVi,
                audioUrlEn: audioUrlEn,
                audioUrlKo: audioUrlKo,
                audioUrlZh: audioUrlZh,
                audioDuration: audioDuration,
                category: category,
                difficulty: difficulty,
                flowerCost: flowerCost,
                qrCode: qrCode,
                status: status,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PlacesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                locationId = false,
                subPlacesRefs = false,
                journeyStopsRefs = false,
                audioCacheRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subPlacesRefs) db.subPlaces,
                    if (journeyStopsRefs) db.journeyStops,
                    if (audioCacheRefs) db.audioCache,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (locationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.locationId,
                                    referencedTable: $$PlacesTableReferences
                                        ._locationIdTable(db),
                                    referencedColumn: $$PlacesTableReferences
                                        ._locationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subPlacesRefs)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          SubPlace
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._subPlacesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).subPlacesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (journeyStopsRefs)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          JourneyStop
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._journeyStopsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).journeyStopsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (audioCacheRefs)
                        await $_getPrefetchedData<
                          Place,
                          $PlacesTable,
                          AudioCacheData
                        >(
                          currentTable: table,
                          referencedTable: $$PlacesTableReferences
                              ._audioCacheRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlacesTableReferences(
                                db,
                                table,
                                p0,
                              ).audioCacheRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.placeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTable,
      Place,
      $$PlacesTableFilterComposer,
      $$PlacesTableOrderingComposer,
      $$PlacesTableAnnotationComposer,
      $$PlacesTableCreateCompanionBuilder,
      $$PlacesTableUpdateCompanionBuilder,
      (Place, $$PlacesTableReferences),
      Place,
      PrefetchHooks Function({
        bool locationId,
        bool subPlacesRefs,
        bool journeyStopsRefs,
        bool audioCacheRefs,
      })
    >;
typedef $$SubPlacesTableCreateCompanionBuilder =
    SubPlacesCompanion Function({
      Value<int> id,
      required int placeId,
      required String name,
      Value<String?> nameEn,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String?> imageUrl,
      Value<int> orderNum,
    });
typedef $$SubPlacesTableUpdateCompanionBuilder =
    SubPlacesCompanion Function({
      Value<int> id,
      Value<int> placeId,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String?> imageUrl,
      Value<int> orderNum,
    });

final class $$SubPlacesTableReferences
    extends BaseReferences<_$AppDatabase, $SubPlacesTable, SubPlace> {
  $$SubPlacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlacesTable _placeIdTable(_$AppDatabase db) => db.places.createAlias(
    $_aliasNameGenerator(db.subPlaces.placeId, db.places.id),
  );

  $$PlacesTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<int>('place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubPlacesTableFilterComposer
    extends Composer<_$AppDatabase, $SubPlacesTable> {
  $$SubPlacesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubPlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubPlacesTable> {
  $$SubPlacesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubPlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubPlacesTable> {
  $$SubPlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentEn =>
      $composableBuilder(column: $table.contentEn, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get orderNum =>
      $composableBuilder(column: $table.orderNum, builder: (column) => column);

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubPlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubPlacesTable,
          SubPlace,
          $$SubPlacesTableFilterComposer,
          $$SubPlacesTableOrderingComposer,
          $$SubPlacesTableAnnotationComposer,
          $$SubPlacesTableCreateCompanionBuilder,
          $$SubPlacesTableUpdateCompanionBuilder,
          (SubPlace, $$SubPlacesTableReferences),
          SubPlace,
          PrefetchHooks Function({bool placeId})
        > {
  $$SubPlacesTableTableManager(_$AppDatabase db, $SubPlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubPlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubPlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubPlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> placeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> orderNum = const Value.absent(),
              }) => SubPlacesCompanion(
                id: id,
                placeId: placeId,
                name: name,
                nameEn: nameEn,
                content: content,
                contentEn: contentEn,
                imageUrl: imageUrl,
                orderNum: orderNum,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int placeId,
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> orderNum = const Value.absent(),
              }) => SubPlacesCompanion.insert(
                id: id,
                placeId: placeId,
                name: name,
                nameEn: nameEn,
                content: content,
                contentEn: contentEn,
                imageUrl: imageUrl,
                orderNum: orderNum,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubPlacesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable: $$SubPlacesTableReferences
                                    ._placeIdTable(db),
                                referencedColumn: $$SubPlacesTableReferences
                                    ._placeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubPlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubPlacesTable,
      SubPlace,
      $$SubPlacesTableFilterComposer,
      $$SubPlacesTableOrderingComposer,
      $$SubPlacesTableAnnotationComposer,
      $$SubPlacesTableCreateCompanionBuilder,
      $$SubPlacesTableUpdateCompanionBuilder,
      (SubPlace, $$SubPlacesTableReferences),
      SubPlace,
      PrefetchHooks Function({bool placeId})
    >;
typedef $$JourneysTableCreateCompanionBuilder =
    JourneysCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      Value<String?> descriptionEn,
      Value<String?> imageUrl,
      Value<String?> totalDistance,
      Value<String?> estimatedDays,
      Value<String?> difficulty,
      Value<bool> isPopular,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$JourneysTableUpdateCompanionBuilder =
    JourneysCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> nameKo,
      Value<String?> nameZh,
      Value<String?> description,
      Value<String?> descriptionEn,
      Value<String?> imageUrl,
      Value<String?> totalDistance,
      Value<String?> estimatedDays,
      Value<String?> difficulty,
      Value<bool> isPopular,
      Value<DateTime?> lastSyncedAt,
    });

final class $$JourneysTableReferences
    extends BaseReferences<_$AppDatabase, $JourneysTable, Journey> {
  $$JourneysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JourneyStopsTable, List<JourneyStop>>
  _journeyStopsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journeyStops,
    aliasName: $_aliasNameGenerator(db.journeys.id, db.journeyStops.journeyId),
  );

  $$JourneyStopsTableProcessedTableManager get journeyStopsRefs {
    final manager = $$JourneyStopsTableTableManager(
      $_db,
      $_db.journeyStops,
    ).filter((f) => f.journeyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_journeyStopsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JourneysTableFilterComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estimatedDays => $composableBuilder(
    column: $table.estimatedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPopular => $composableBuilder(
    column: $table.isPopular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journeyStopsRefs(
    Expression<bool> Function($$JourneyStopsTableFilterComposer f) f,
  ) {
    final $$JourneyStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyStops,
      getReferencedColumn: (t) => t.journeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyStopsTableFilterComposer(
            $db: $db,
            $table: $db.journeyStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JourneysTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKo => $composableBuilder(
    column: $table.nameKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameZh => $composableBuilder(
    column: $table.nameZh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estimatedDays => $composableBuilder(
    column: $table.estimatedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPopular => $composableBuilder(
    column: $table.isPopular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneysTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneysTable> {
  $$JourneysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameKo =>
      $composableBuilder(column: $table.nameKo, builder: (column) => column);

  GeneratedColumn<String> get nameZh =>
      $composableBuilder(column: $table.nameZh, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get totalDistance => $composableBuilder(
    column: $table.totalDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estimatedDays => $composableBuilder(
    column: $table.estimatedDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPopular =>
      $composableBuilder(column: $table.isPopular, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  Expression<T> journeyStopsRefs<T extends Object>(
    Expression<T> Function($$JourneyStopsTableAnnotationComposer a) f,
  ) {
    final $$JourneyStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journeyStops,
      getReferencedColumn: (t) => t.journeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneyStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.journeyStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JourneysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneysTable,
          Journey,
          $$JourneysTableFilterComposer,
          $$JourneysTableOrderingComposer,
          $$JourneysTableAnnotationComposer,
          $$JourneysTableCreateCompanionBuilder,
          $$JourneysTableUpdateCompanionBuilder,
          (Journey, $$JourneysTableReferences),
          Journey,
          PrefetchHooks Function({bool journeyStopsRefs})
        > {
  $$JourneysTableTableManager(_$AppDatabase db, $JourneysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JourneysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> totalDistance = const Value.absent(),
                Value<String?> estimatedDays = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<bool> isPopular = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => JourneysCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                descriptionEn: descriptionEn,
                imageUrl: imageUrl,
                totalDistance: totalDistance,
                estimatedDays: estimatedDays,
                difficulty: difficulty,
                isPopular: isPopular,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> nameKo = const Value.absent(),
                Value<String?> nameZh = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> totalDistance = const Value.absent(),
                Value<String?> estimatedDays = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<bool> isPopular = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => JourneysCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                nameKo: nameKo,
                nameZh: nameZh,
                description: description,
                descriptionEn: descriptionEn,
                imageUrl: imageUrl,
                totalDistance: totalDistance,
                estimatedDays: estimatedDays,
                difficulty: difficulty,
                isPopular: isPopular,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JourneysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journeyStopsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (journeyStopsRefs) db.journeyStops],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journeyStopsRefs)
                    await $_getPrefetchedData<
                      Journey,
                      $JourneysTable,
                      JourneyStop
                    >(
                      currentTable: table,
                      referencedTable: $$JourneysTableReferences
                          ._journeyStopsRefsTable(db),
                      managerFromTypedResult: (p0) => $$JourneysTableReferences(
                        db,
                        table,
                        p0,
                      ).journeyStopsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.journeyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$JourneysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneysTable,
      Journey,
      $$JourneysTableFilterComposer,
      $$JourneysTableOrderingComposer,
      $$JourneysTableAnnotationComposer,
      $$JourneysTableCreateCompanionBuilder,
      $$JourneysTableUpdateCompanionBuilder,
      (Journey, $$JourneysTableReferences),
      Journey,
      PrefetchHooks Function({bool journeyStopsRefs})
    >;
typedef $$JourneyStopsTableCreateCompanionBuilder =
    JourneyStopsCompanion Function({
      Value<int> id,
      required int journeyId,
      required int placeId,
      Value<int> orderNum,
      Value<String?> placeName,
      Value<String?> placeImageUrl,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> distanceFromPrev,
    });
typedef $$JourneyStopsTableUpdateCompanionBuilder =
    JourneyStopsCompanion Function({
      Value<int> id,
      Value<int> journeyId,
      Value<int> placeId,
      Value<int> orderNum,
      Value<String?> placeName,
      Value<String?> placeImageUrl,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> distanceFromPrev,
    });

final class $$JourneyStopsTableReferences
    extends BaseReferences<_$AppDatabase, $JourneyStopsTable, JourneyStop> {
  $$JourneyStopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $JourneysTable _journeyIdTable(_$AppDatabase db) =>
      db.journeys.createAlias(
        $_aliasNameGenerator(db.journeyStops.journeyId, db.journeys.id),
      );

  $$JourneysTableProcessedTableManager get journeyId {
    final $_column = $_itemColumn<int>('journey_id')!;

    final manager = $$JourneysTableTableManager(
      $_db,
      $_db.journeys,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journeyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlacesTable _placeIdTable(_$AppDatabase db) => db.places.createAlias(
    $_aliasNameGenerator(db.journeyStops.placeId, db.places.id),
  );

  $$PlacesTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<int>('place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JourneyStopsTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyStopsTable> {
  $$JourneyStopsTableFilterComposer({
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

  ColumnFilters<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeImageUrl => $composableBuilder(
    column: $table.placeImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distanceFromPrev => $composableBuilder(
    column: $table.distanceFromPrev,
    builder: (column) => ColumnFilters(column),
  );

  $$JourneysTableFilterComposer get journeyId {
    final $$JourneysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableFilterComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyStopsTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyStopsTable> {
  $$JourneyStopsTableOrderingComposer({
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

  ColumnOrderings<int> get orderNum => $composableBuilder(
    column: $table.orderNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeImageUrl => $composableBuilder(
    column: $table.placeImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distanceFromPrev => $composableBuilder(
    column: $table.distanceFromPrev,
    builder: (column) => ColumnOrderings(column),
  );

  $$JourneysTableOrderingComposer get journeyId {
    final $$JourneysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableOrderingComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyStopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyStopsTable> {
  $$JourneyStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderNum =>
      $composableBuilder(column: $table.orderNum, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get placeImageUrl => $composableBuilder(
    column: $table.placeImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get distanceFromPrev => $composableBuilder(
    column: $table.distanceFromPrev,
    builder: (column) => column,
  );

  $$JourneysTableAnnotationComposer get journeyId {
    final $$JourneysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journeyId,
      referencedTable: $db.journeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JourneysTableAnnotationComposer(
            $db: $db,
            $table: $db.journeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JourneyStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyStopsTable,
          JourneyStop,
          $$JourneyStopsTableFilterComposer,
          $$JourneyStopsTableOrderingComposer,
          $$JourneyStopsTableAnnotationComposer,
          $$JourneyStopsTableCreateCompanionBuilder,
          $$JourneyStopsTableUpdateCompanionBuilder,
          (JourneyStop, $$JourneyStopsTableReferences),
          JourneyStop,
          PrefetchHooks Function({bool journeyId, bool placeId})
        > {
  $$JourneyStopsTableTableManager(_$AppDatabase db, $JourneyStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneyStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JourneyStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> journeyId = const Value.absent(),
                Value<int> placeId = const Value.absent(),
                Value<int> orderNum = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> placeImageUrl = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> distanceFromPrev = const Value.absent(),
              }) => JourneyStopsCompanion(
                id: id,
                journeyId: journeyId,
                placeId: placeId,
                orderNum: orderNum,
                placeName: placeName,
                placeImageUrl: placeImageUrl,
                lat: lat,
                lng: lng,
                distanceFromPrev: distanceFromPrev,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int journeyId,
                required int placeId,
                Value<int> orderNum = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> placeImageUrl = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> distanceFromPrev = const Value.absent(),
              }) => JourneyStopsCompanion.insert(
                id: id,
                journeyId: journeyId,
                placeId: placeId,
                orderNum: orderNum,
                placeName: placeName,
                placeImageUrl: placeImageUrl,
                lat: lat,
                lng: lng,
                distanceFromPrev: distanceFromPrev,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JourneyStopsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journeyId = false, placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journeyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.journeyId,
                                referencedTable: $$JourneyStopsTableReferences
                                    ._journeyIdTable(db),
                                referencedColumn: $$JourneyStopsTableReferences
                                    ._journeyIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable: $$JourneyStopsTableReferences
                                    ._placeIdTable(db),
                                referencedColumn: $$JourneyStopsTableReferences
                                    ._placeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JourneyStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyStopsTable,
      JourneyStop,
      $$JourneyStopsTableFilterComposer,
      $$JourneyStopsTableOrderingComposer,
      $$JourneyStopsTableAnnotationComposer,
      $$JourneyStopsTableCreateCompanionBuilder,
      $$JourneyStopsTableUpdateCompanionBuilder,
      (JourneyStop, $$JourneyStopsTableReferences),
      JourneyStop,
      PrefetchHooks Function({bool journeyId, bool placeId})
    >;
typedef $$StoriesTableCreateCompanionBuilder =
    StoriesCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> titleEn,
      Value<String?> titleKo,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String?> imageUrl,
      Value<int> readTimeMinutes,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$StoriesTableUpdateCompanionBuilder =
    StoriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> titleEn,
      Value<String?> titleKo,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String?> imageUrl,
      Value<int> readTimeMinutes,
      Value<DateTime?> lastSyncedAt,
    });

class $$StoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleKo => $composableBuilder(
    column: $table.titleKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleKo => $composableBuilder(
    column: $table.titleKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get titleKo =>
      $composableBuilder(column: $table.titleKo, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentEn =>
      $composableBuilder(column: $table.contentEn, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get readTimeMinutes => $composableBuilder(
    column: $table.readTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$StoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoriesTable,
          Story,
          $$StoriesTableFilterComposer,
          $$StoriesTableOrderingComposer,
          $$StoriesTableAnnotationComposer,
          $$StoriesTableCreateCompanionBuilder,
          $$StoriesTableUpdateCompanionBuilder,
          (Story, BaseReferences<_$AppDatabase, $StoriesTable, Story>),
          Story,
          PrefetchHooks Function()
        > {
  $$StoriesTableTableManager(_$AppDatabase db, $StoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleKo = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> readTimeMinutes = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => StoriesCompanion(
                id: id,
                title: title,
                titleEn: titleEn,
                titleKo: titleKo,
                content: content,
                contentEn: contentEn,
                imageUrl: imageUrl,
                readTimeMinutes: readTimeMinutes,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> titleEn = const Value.absent(),
                Value<String?> titleKo = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> readTimeMinutes = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => StoriesCompanion.insert(
                id: id,
                title: title,
                titleEn: titleEn,
                titleKo: titleKo,
                content: content,
                contentEn: contentEn,
                imageUrl: imageUrl,
                readTimeMinutes: readTimeMinutes,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoriesTable,
      Story,
      $$StoriesTableFilterComposer,
      $$StoriesTableOrderingComposer,
      $$StoriesTableAnnotationComposer,
      $$StoriesTableCreateCompanionBuilder,
      $$StoriesTableUpdateCompanionBuilder,
      (Story, BaseReferences<_$AppDatabase, $StoriesTable, Story>),
      Story,
      PrefetchHooks Function()
    >;
typedef $$NewsTableCreateCompanionBuilder =
    NewsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> titleEn,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String> type,
      Value<int?> provinceId,
      Value<String?> imageUrl,
      Value<DateTime?> publishedAt,
      Value<bool> isActive,
    });
typedef $$NewsTableUpdateCompanionBuilder =
    NewsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> titleEn,
      Value<String?> content,
      Value<String?> contentEn,
      Value<String> type,
      Value<int?> provinceId,
      Value<String?> imageUrl,
      Value<DateTime?> publishedAt,
      Value<bool> isActive,
    });

final class $$NewsTableReferences
    extends BaseReferences<_$AppDatabase, $NewsTable, New> {
  $$NewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProvincesTable _provinceIdTable(_$AppDatabase db) => db.provinces
      .createAlias($_aliasNameGenerator(db.news.provinceId, db.provinces.id));

  $$ProvincesTableProcessedTableManager? get provinceId {
    final $_column = $_itemColumn<int>('province_id');
    if ($_column == null) return null;
    final manager = $$ProvincesTableTableManager(
      $_db,
      $_db.provinces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_provinceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NewsTableFilterComposer extends Composer<_$AppDatabase, $NewsTable> {
  $$NewsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$ProvincesTableFilterComposer get provinceId {
    final $$ProvincesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableFilterComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NewsTableOrderingComposer extends Composer<_$AppDatabase, $NewsTable> {
  $$NewsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEn => $composableBuilder(
    column: $table.titleEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentEn => $composableBuilder(
    column: $table.contentEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProvincesTableOrderingComposer get provinceId {
    final $$ProvincesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableOrderingComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NewsTable> {
  $$NewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleEn =>
      $composableBuilder(column: $table.titleEn, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentEn =>
      $composableBuilder(column: $table.contentEn, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ProvincesTableAnnotationComposer get provinceId {
    final $$ProvincesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableAnnotationComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NewsTable,
          New,
          $$NewsTableFilterComposer,
          $$NewsTableOrderingComposer,
          $$NewsTableAnnotationComposer,
          $$NewsTableCreateCompanionBuilder,
          $$NewsTableUpdateCompanionBuilder,
          (New, $$NewsTableReferences),
          New,
          PrefetchHooks Function({bool provinceId})
        > {
  $$NewsTableTableManager(_$AppDatabase db, $NewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> titleEn = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> provinceId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => NewsCompanion(
                id: id,
                title: title,
                titleEn: titleEn,
                content: content,
                contentEn: contentEn,
                type: type,
                provinceId: provinceId,
                imageUrl: imageUrl,
                publishedAt: publishedAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> titleEn = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> contentEn = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> provinceId = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => NewsCompanion.insert(
                id: id,
                title: title,
                titleEn: titleEn,
                content: content,
                contentEn: contentEn,
                type: type,
                provinceId: provinceId,
                imageUrl: imageUrl,
                publishedAt: publishedAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NewsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({provinceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (provinceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.provinceId,
                                referencedTable: $$NewsTableReferences
                                    ._provinceIdTable(db),
                                referencedColumn: $$NewsTableReferences
                                    ._provinceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NewsTable,
      New,
      $$NewsTableFilterComposer,
      $$NewsTableOrderingComposer,
      $$NewsTableAnnotationComposer,
      $$NewsTableCreateCompanionBuilder,
      $$NewsTableUpdateCompanionBuilder,
      (New, $$NewsTableReferences),
      New,
      PrefetchHooks Function({bool provinceId})
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nameEn,
      Value<String?> category,
      Value<String?> description,
      Value<String?> descriptionEn,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> imageUrl,
      Value<double?> rating,
      Value<String?> priceRange,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nameEn,
      Value<String?> category,
      Value<String?> description,
      Value<String?> descriptionEn,
      Value<double?> lat,
      Value<double?> lng,
      Value<String?> address,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> imageUrl,
      Value<double?> rating,
      Value<String?> priceRange,
    });

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceRange => $composableBuilder(
    column: $table.priceRange,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceRange => $composableBuilder(
    column: $table.priceRange,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get priceRange => $composableBuilder(
    column: $table.priceRange,
    builder: (column) => column,
  );
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          ServiceEntry,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (
            ServiceEntry,
            BaseReferences<_$AppDatabase, $ServicesTable, ServiceEntry>,
          ),
          ServiceEntry,
          PrefetchHooks Function()
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameEn = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> priceRange = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                category: category,
                description: description,
                descriptionEn: descriptionEn,
                lat: lat,
                lng: lng,
                address: address,
                phone: phone,
                website: website,
                imageUrl: imageUrl,
                rating: rating,
                priceRange: priceRange,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameEn = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> descriptionEn = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double?> rating = const Value.absent(),
                Value<String?> priceRange = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                category: category,
                description: description,
                descriptionEn: descriptionEn,
                lat: lat,
                lng: lng,
                address: address,
                phone: phone,
                website: website,
                imageUrl: imageUrl,
                rating: rating,
                priceRange: priceRange,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      ServiceEntry,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (
        ServiceEntry,
        BaseReferences<_$AppDatabase, $ServicesTable, ServiceEntry>,
      ),
      ServiceEntry,
      PrefetchHooks Function()
    >;
typedef $$AudioCacheTableCreateCompanionBuilder =
    AudioCacheCompanion Function({
      required int placeId,
      required String language,
      required String audioUrl,
      required String localPath,
      Value<int> fileSize,
      required DateTime downloadedAt,
      Value<DateTime?> lastPlayedAt,
      Value<int> rowid,
    });
typedef $$AudioCacheTableUpdateCompanionBuilder =
    AudioCacheCompanion Function({
      Value<int> placeId,
      Value<String> language,
      Value<String> audioUrl,
      Value<String> localPath,
      Value<int> fileSize,
      Value<DateTime> downloadedAt,
      Value<DateTime?> lastPlayedAt,
      Value<int> rowid,
    });

final class $$AudioCacheTableReferences
    extends BaseReferences<_$AppDatabase, $AudioCacheTable, AudioCacheData> {
  $$AudioCacheTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlacesTable _placeIdTable(_$AppDatabase db) => db.places.createAlias(
    $_aliasNameGenerator(db.audioCache.placeId, db.places.id),
  );

  $$PlacesTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<int>('place_id')!;

    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AudioCacheTableFilterComposer
    extends Composer<_$AppDatabase, $AudioCacheTable> {
  $$AudioCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioCacheTable> {
  $$AudioCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioCacheTable> {
  $$AudioCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioCacheTable,
          AudioCacheData,
          $$AudioCacheTableFilterComposer,
          $$AudioCacheTableOrderingComposer,
          $$AudioCacheTableAnnotationComposer,
          $$AudioCacheTableCreateCompanionBuilder,
          $$AudioCacheTableUpdateCompanionBuilder,
          (AudioCacheData, $$AudioCacheTableReferences),
          AudioCacheData,
          PrefetchHooks Function({bool placeId})
        > {
  $$AudioCacheTableTableManager(_$AppDatabase db, $AudioCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> placeId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<DateTime> downloadedAt = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioCacheCompanion(
                placeId: placeId,
                language: language,
                audioUrl: audioUrl,
                localPath: localPath,
                fileSize: fileSize,
                downloadedAt: downloadedAt,
                lastPlayedAt: lastPlayedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int placeId,
                required String language,
                required String audioUrl,
                required String localPath,
                Value<int> fileSize = const Value.absent(),
                required DateTime downloadedAt,
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AudioCacheCompanion.insert(
                placeId: placeId,
                language: language,
                audioUrl: audioUrl,
                localPath: localPath,
                fileSize: fileSize,
                downloadedAt: downloadedAt,
                lastPlayedAt: lastPlayedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudioCacheTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable: $$AudioCacheTableReferences
                                    ._placeIdTable(db),
                                referencedColumn: $$AudioCacheTableReferences
                                    ._placeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AudioCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioCacheTable,
      AudioCacheData,
      $$AudioCacheTableFilterComposer,
      $$AudioCacheTableOrderingComposer,
      $$AudioCacheTableAnnotationComposer,
      $$AudioCacheTableCreateCompanionBuilder,
      $$AudioCacheTableUpdateCompanionBuilder,
      (AudioCacheData, $$AudioCacheTableReferences),
      AudioCacheData,
      PrefetchHooks Function({bool placeId})
    >;
typedef $$WalletTableCreateCompanionBuilder =
    WalletCompanion Function({
      required String deviceUuid,
      Value<int> balance,
      Value<int> totalEarned,
      Value<int> totalSpent,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$WalletTableUpdateCompanionBuilder =
    WalletCompanion Function({
      Value<String> deviceUuid,
      Value<int> balance,
      Value<int> totalEarned,
      Value<int> totalSpent,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$WalletTableFilterComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceUuid => $composableBuilder(
    column: $table.deviceUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalEarned => $composableBuilder(
    column: $table.totalEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceUuid => $composableBuilder(
    column: $table.deviceUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalEarned => $composableBuilder(
    column: $table.totalEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletTable> {
  $$WalletTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceUuid => $composableBuilder(
    column: $table.deviceUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<int> get totalEarned => $composableBuilder(
    column: $table.totalEarned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSpent => $composableBuilder(
    column: $table.totalSpent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$WalletTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletTable,
          WalletData,
          $$WalletTableFilterComposer,
          $$WalletTableOrderingComposer,
          $$WalletTableAnnotationComposer,
          $$WalletTableCreateCompanionBuilder,
          $$WalletTableUpdateCompanionBuilder,
          (WalletData, BaseReferences<_$AppDatabase, $WalletTable, WalletData>),
          WalletData,
          PrefetchHooks Function()
        > {
  $$WalletTableTableManager(_$AppDatabase db, $WalletTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceUuid = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<int> totalEarned = const Value.absent(),
                Value<int> totalSpent = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletCompanion(
                deviceUuid: deviceUuid,
                balance: balance,
                totalEarned: totalEarned,
                totalSpent: totalSpent,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceUuid,
                Value<int> balance = const Value.absent(),
                Value<int> totalEarned = const Value.absent(),
                Value<int> totalSpent = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletCompanion.insert(
                deviceUuid: deviceUuid,
                balance: balance,
                totalEarned: totalEarned,
                totalSpent: totalSpent,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletTable,
      WalletData,
      $$WalletTableFilterComposer,
      $$WalletTableOrderingComposer,
      $$WalletTableAnnotationComposer,
      $$WalletTableCreateCompanionBuilder,
      $$WalletTableUpdateCompanionBuilder,
      (WalletData, BaseReferences<_$AppDatabase, $WalletTable, WalletData>),
      WalletData,
      PrefetchHooks Function()
    >;
typedef $$CheckinsTableCreateCompanionBuilder =
    CheckinsCompanion Function({
      Value<int> id,
      required int placeId,
      required String placeName,
      required String method,
      Value<int> flowersEarned,
      Value<double?> lat,
      Value<double?> lng,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
    });
typedef $$CheckinsTableUpdateCompanionBuilder =
    CheckinsCompanion Function({
      Value<int> id,
      Value<int> placeId,
      Value<String> placeName,
      Value<String> method,
      Value<int> flowersEarned,
      Value<double?> lat,
      Value<double?> lng,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
    });

class $$CheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableFilterComposer({
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

  ColumnFilters<int> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flowersEarned => $composableBuilder(
    column: $table.flowersEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableOrderingComposer({
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

  ColumnOrderings<int> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flowersEarned => $composableBuilder(
    column: $table.flowersEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckinsTable> {
  $$CheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get flowersEarned => $composableBuilder(
    column: $table.flowersEarned,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckinsTable,
          Checkin,
          $$CheckinsTableFilterComposer,
          $$CheckinsTableOrderingComposer,
          $$CheckinsTableAnnotationComposer,
          $$CheckinsTableCreateCompanionBuilder,
          $$CheckinsTableUpdateCompanionBuilder,
          (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
          Checkin,
          PrefetchHooks Function()
        > {
  $$CheckinsTableTableManager(_$AppDatabase db, $CheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> placeId = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> flowersEarned = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => CheckinsCompanion(
                id: id,
                placeId: placeId,
                placeName: placeName,
                method: method,
                flowersEarned: flowersEarned,
                lat: lat,
                lng: lng,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int placeId,
                required String placeName,
                required String method,
                Value<int> flowersEarned = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => CheckinsCompanion.insert(
                id: id,
                placeId: placeId,
                placeName: placeName,
                method: method,
                flowersEarned: flowersEarned,
                lat: lat,
                lng: lng,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckinsTable,
      Checkin,
      $$CheckinsTableFilterComposer,
      $$CheckinsTableOrderingComposer,
      $$CheckinsTableAnnotationComposer,
      $$CheckinsTableCreateCompanionBuilder,
      $$CheckinsTableUpdateCompanionBuilder,
      (Checkin, BaseReferences<_$AppDatabase, $CheckinsTable, Checkin>),
      Checkin,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String endpoint,
      required String method,
      required String payload,
      required DateTime createdAt,
      Value<String> status,
      Value<int> retriesLeft,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> endpoint,
      Value<String> method,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> retriesLeft,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
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

  ColumnFilters<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retriesLeft => $composableBuilder(
    column: $table.retriesLeft,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retriesLeft => $composableBuilder(
    column: $table.retriesLeft,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retriesLeft => $composableBuilder(
    column: $table.retriesLeft,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> endpoint = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retriesLeft = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                endpoint: endpoint,
                method: method,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retriesLeft: retriesLeft,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String endpoint,
                required String method,
                required String payload,
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<int> retriesLeft = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                endpoint: endpoint,
                method: method,
                payload: payload,
                createdAt: createdAt,
                status: status,
                retriesLeft: retriesLeft,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db, _db.provinces);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$SubPlacesTableTableManager get subPlaces =>
      $$SubPlacesTableTableManager(_db, _db.subPlaces);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db, _db.journeys);
  $$JourneyStopsTableTableManager get journeyStops =>
      $$JourneyStopsTableTableManager(_db, _db.journeyStops);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db, _db.stories);
  $$NewsTableTableManager get news => $$NewsTableTableManager(_db, _db.news);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$AudioCacheTableTableManager get audioCache =>
      $$AudioCacheTableTableManager(_db, _db.audioCache);
  $$WalletTableTableManager get wallet =>
      $$WalletTableTableManager(_db, _db.wallet);
  $$CheckinsTableTableManager get checkins =>
      $$CheckinsTableTableManager(_db, _db.checkins);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
