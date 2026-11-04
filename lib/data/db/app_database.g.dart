// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, SubscriptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconTextMeta = const VerificationMeta(
    'iconText',
  );
  @override
  late final GeneratedColumn<String> iconText = GeneratedColumn<String>(
    'icon_text',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleEveryMeta = const VerificationMeta(
    'cycleEvery',
  );
  @override
  late final GeneratedColumn<int> cycleEvery = GeneratedColumn<int>(
    'cycle_every',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleUnitMeta = const VerificationMeta(
    'cycleUnit',
  );
  @override
  late final GeneratedColumn<String> cycleUnit = GeneratedColumn<String>(
    'cycle_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorDateMeta = const VerificationMeta(
    'anchorDate',
  );
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
    'anchor_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodIndexMeta = const VerificationMeta(
    'periodIndex',
  );
  @override
  late final GeneratedColumn<int> periodIndex = GeneratedColumn<int>(
    'period_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trialEndDateMeta = const VerificationMeta(
    'trialEndDate',
  );
  @override
  late final GeneratedColumn<String> trialEndDate = GeneratedColumn<String>(
    'trial_end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<int> sharedWith = GeneratedColumn<int>(
    'shared_with',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _reminderDaysMeta = const VerificationMeta(
    'reminderDays',
  );
  @override
  late final GeneratedColumn<int> reminderDays = GeneratedColumn<int>(
    'reminder_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manageUrlMeta = const VerificationMeta(
    'manageUrl',
  );
  @override
  late final GeneratedColumn<String> manageUrl = GeneratedColumn<String>(
    'manage_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cancelledOnMeta = const VerificationMeta(
    'cancelledOn',
  );
  @override
  late final GeneratedColumn<String> cancelledOn = GeneratedColumn<String>(
    'cancelled_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    serviceId,
    colorValue,
    iconText,
    category,
    priceMinor,
    currency,
    cycleEvery,
    cycleUnit,
    anchorDate,
    periodIndex,
    status,
    trialEndDate,
    sharedWith,
    reminderDays,
    paymentMethod,
    manageUrl,
    notes,
    startDate,
    cancelledOn,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionRow> instance, {
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
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('icon_text')) {
      context.handle(
        _iconTextMeta,
        iconText.isAcceptableOrUnknown(data['icon_text']!, _iconTextMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('cycle_every')) {
      context.handle(
        _cycleEveryMeta,
        cycleEvery.isAcceptableOrUnknown(data['cycle_every']!, _cycleEveryMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleEveryMeta);
    }
    if (data.containsKey('cycle_unit')) {
      context.handle(
        _cycleUnitMeta,
        cycleUnit.isAcceptableOrUnknown(data['cycle_unit']!, _cycleUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleUnitMeta);
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
        _anchorDateMeta,
        anchorDate.isAcceptableOrUnknown(data['anchor_date']!, _anchorDateMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorDateMeta);
    }
    if (data.containsKey('period_index')) {
      context.handle(
        _periodIndexMeta,
        periodIndex.isAcceptableOrUnknown(
          data['period_index']!,
          _periodIndexMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('trial_end_date')) {
      context.handle(
        _trialEndDateMeta,
        trialEndDate.isAcceptableOrUnknown(
          data['trial_end_date']!,
          _trialEndDateMeta,
        ),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
        _reminderDaysMeta,
        reminderDays.isAcceptableOrUnknown(
          data['reminder_days']!,
          _reminderDaysMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('manage_url')) {
      context.handle(
        _manageUrlMeta,
        manageUrl.isAcceptableOrUnknown(data['manage_url']!, _manageUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('cancelled_on')) {
      context.handle(
        _cancelledOnMeta,
        cancelledOn.isAcceptableOrUnknown(
          data['cancelled_on']!,
          _cancelledOnMeta,
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
  SubscriptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      iconText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_text'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      cycleEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_every'],
      )!,
      cycleUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_unit'],
      )!,
      anchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_date'],
      )!,
      periodIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_index'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      trialEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trial_end_date'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shared_with'],
      )!,
      reminderDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_days'],
      ),
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      manageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manage_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      cancelledOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancelled_on'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class SubscriptionRow extends DataClass implements Insertable<SubscriptionRow> {
  final String id;
  final String name;
  final String? serviceId;
  final int colorValue;
  final String? iconText;
  final String category;
  final int priceMinor;
  final String currency;
  final int cycleEvery;
  final String cycleUnit;
  final String anchorDate;
  final int periodIndex;
  final String status;
  final String? trialEndDate;
  final int sharedWith;
  final int? reminderDays;
  final String? paymentMethod;
  final String? manageUrl;
  final String? notes;
  final String startDate;
  final String? cancelledOn;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubscriptionRow({
    required this.id,
    required this.name,
    this.serviceId,
    required this.colorValue,
    this.iconText,
    required this.category,
    required this.priceMinor,
    required this.currency,
    required this.cycleEvery,
    required this.cycleUnit,
    required this.anchorDate,
    required this.periodIndex,
    required this.status,
    this.trialEndDate,
    required this.sharedWith,
    this.reminderDays,
    this.paymentMethod,
    this.manageUrl,
    this.notes,
    required this.startDate,
    this.cancelledOn,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<String>(serviceId);
    }
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || iconText != null) {
      map['icon_text'] = Variable<String>(iconText);
    }
    map['category'] = Variable<String>(category);
    map['price_minor'] = Variable<int>(priceMinor);
    map['currency'] = Variable<String>(currency);
    map['cycle_every'] = Variable<int>(cycleEvery);
    map['cycle_unit'] = Variable<String>(cycleUnit);
    map['anchor_date'] = Variable<String>(anchorDate);
    map['period_index'] = Variable<int>(periodIndex);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || trialEndDate != null) {
      map['trial_end_date'] = Variable<String>(trialEndDate);
    }
    map['shared_with'] = Variable<int>(sharedWith);
    if (!nullToAbsent || reminderDays != null) {
      map['reminder_days'] = Variable<int>(reminderDays);
    }
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || manageUrl != null) {
      map['manage_url'] = Variable<String>(manageUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || cancelledOn != null) {
      map['cancelled_on'] = Variable<String>(cancelledOn);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
      colorValue: Value(colorValue),
      iconText: iconText == null && nullToAbsent
          ? const Value.absent()
          : Value(iconText),
      category: Value(category),
      priceMinor: Value(priceMinor),
      currency: Value(currency),
      cycleEvery: Value(cycleEvery),
      cycleUnit: Value(cycleUnit),
      anchorDate: Value(anchorDate),
      periodIndex: Value(periodIndex),
      status: Value(status),
      trialEndDate: trialEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEndDate),
      sharedWith: Value(sharedWith),
      reminderDays: reminderDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDays),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      manageUrl: manageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(manageUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      startDate: Value(startDate),
      cancelledOn: cancelledOn == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledOn),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubscriptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      serviceId: serializer.fromJson<String?>(json['serviceId']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      iconText: serializer.fromJson<String?>(json['iconText']),
      category: serializer.fromJson<String>(json['category']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      cycleEvery: serializer.fromJson<int>(json['cycleEvery']),
      cycleUnit: serializer.fromJson<String>(json['cycleUnit']),
      anchorDate: serializer.fromJson<String>(json['anchorDate']),
      periodIndex: serializer.fromJson<int>(json['periodIndex']),
      status: serializer.fromJson<String>(json['status']),
      trialEndDate: serializer.fromJson<String?>(json['trialEndDate']),
      sharedWith: serializer.fromJson<int>(json['sharedWith']),
      reminderDays: serializer.fromJson<int?>(json['reminderDays']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      manageUrl: serializer.fromJson<String?>(json['manageUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      startDate: serializer.fromJson<String>(json['startDate']),
      cancelledOn: serializer.fromJson<String?>(json['cancelledOn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'serviceId': serializer.toJson<String?>(serviceId),
      'colorValue': serializer.toJson<int>(colorValue),
      'iconText': serializer.toJson<String?>(iconText),
      'category': serializer.toJson<String>(category),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'cycleEvery': serializer.toJson<int>(cycleEvery),
      'cycleUnit': serializer.toJson<String>(cycleUnit),
      'anchorDate': serializer.toJson<String>(anchorDate),
      'periodIndex': serializer.toJson<int>(periodIndex),
      'status': serializer.toJson<String>(status),
      'trialEndDate': serializer.toJson<String?>(trialEndDate),
      'sharedWith': serializer.toJson<int>(sharedWith),
      'reminderDays': serializer.toJson<int?>(reminderDays),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'manageUrl': serializer.toJson<String?>(manageUrl),
      'notes': serializer.toJson<String?>(notes),
      'startDate': serializer.toJson<String>(startDate),
      'cancelledOn': serializer.toJson<String?>(cancelledOn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubscriptionRow copyWith({
    String? id,
    String? name,
    Value<String?> serviceId = const Value.absent(),
    int? colorValue,
    Value<String?> iconText = const Value.absent(),
    String? category,
    int? priceMinor,
    String? currency,
    int? cycleEvery,
    String? cycleUnit,
    String? anchorDate,
    int? periodIndex,
    String? status,
    Value<String?> trialEndDate = const Value.absent(),
    int? sharedWith,
    Value<int?> reminderDays = const Value.absent(),
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> manageUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? startDate,
    Value<String?> cancelledOn = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubscriptionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    serviceId: serviceId.present ? serviceId.value : this.serviceId,
    colorValue: colorValue ?? this.colorValue,
    iconText: iconText.present ? iconText.value : this.iconText,
    category: category ?? this.category,
    priceMinor: priceMinor ?? this.priceMinor,
    currency: currency ?? this.currency,
    cycleEvery: cycleEvery ?? this.cycleEvery,
    cycleUnit: cycleUnit ?? this.cycleUnit,
    anchorDate: anchorDate ?? this.anchorDate,
    periodIndex: periodIndex ?? this.periodIndex,
    status: status ?? this.status,
    trialEndDate: trialEndDate.present ? trialEndDate.value : this.trialEndDate,
    sharedWith: sharedWith ?? this.sharedWith,
    reminderDays: reminderDays.present ? reminderDays.value : this.reminderDays,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    manageUrl: manageUrl.present ? manageUrl.value : this.manageUrl,
    notes: notes.present ? notes.value : this.notes,
    startDate: startDate ?? this.startDate,
    cancelledOn: cancelledOn.present ? cancelledOn.value : this.cancelledOn,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubscriptionRow copyWithCompanion(SubscriptionsCompanion data) {
    return SubscriptionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      iconText: data.iconText.present ? data.iconText.value : this.iconText,
      category: data.category.present ? data.category.value : this.category,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      cycleEvery: data.cycleEvery.present
          ? data.cycleEvery.value
          : this.cycleEvery,
      cycleUnit: data.cycleUnit.present ? data.cycleUnit.value : this.cycleUnit,
      anchorDate: data.anchorDate.present
          ? data.anchorDate.value
          : this.anchorDate,
      periodIndex: data.periodIndex.present
          ? data.periodIndex.value
          : this.periodIndex,
      status: data.status.present ? data.status.value : this.status,
      trialEndDate: data.trialEndDate.present
          ? data.trialEndDate.value
          : this.trialEndDate,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      manageUrl: data.manageUrl.present ? data.manageUrl.value : this.manageUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      cancelledOn: data.cancelledOn.present
          ? data.cancelledOn.value
          : this.cancelledOn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('serviceId: $serviceId, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconText: $iconText, ')
          ..write('category: $category, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('periodIndex: $periodIndex, ')
          ..write('status: $status, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('manageUrl: $manageUrl, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('cancelledOn: $cancelledOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    serviceId,
    colorValue,
    iconText,
    category,
    priceMinor,
    currency,
    cycleEvery,
    cycleUnit,
    anchorDate,
    periodIndex,
    status,
    trialEndDate,
    sharedWith,
    reminderDays,
    paymentMethod,
    manageUrl,
    notes,
    startDate,
    cancelledOn,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.serviceId == this.serviceId &&
          other.colorValue == this.colorValue &&
          other.iconText == this.iconText &&
          other.category == this.category &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.cycleEvery == this.cycleEvery &&
          other.cycleUnit == this.cycleUnit &&
          other.anchorDate == this.anchorDate &&
          other.periodIndex == this.periodIndex &&
          other.status == this.status &&
          other.trialEndDate == this.trialEndDate &&
          other.sharedWith == this.sharedWith &&
          other.reminderDays == this.reminderDays &&
          other.paymentMethod == this.paymentMethod &&
          other.manageUrl == this.manageUrl &&
          other.notes == this.notes &&
          other.startDate == this.startDate &&
          other.cancelledOn == this.cancelledOn &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<SubscriptionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> serviceId;
  final Value<int> colorValue;
  final Value<String?> iconText;
  final Value<String> category;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<int> cycleEvery;
  final Value<String> cycleUnit;
  final Value<String> anchorDate;
  final Value<int> periodIndex;
  final Value<String> status;
  final Value<String?> trialEndDate;
  final Value<int> sharedWith;
  final Value<int?> reminderDays;
  final Value<String?> paymentMethod;
  final Value<String?> manageUrl;
  final Value<String?> notes;
  final Value<String> startDate;
  final Value<String?> cancelledOn;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconText = const Value.absent(),
    this.category = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.cycleEvery = const Value.absent(),
    this.cycleUnit = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.periodIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.manageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.cancelledOn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    required String id,
    required String name,
    this.serviceId = const Value.absent(),
    required int colorValue,
    this.iconText = const Value.absent(),
    required String category,
    required int priceMinor,
    required String currency,
    required int cycleEvery,
    required String cycleUnit,
    required String anchorDate,
    this.periodIndex = const Value.absent(),
    required String status,
    this.trialEndDate = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.manageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    required String startDate,
    this.cancelledOn = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
       category = Value(category),
       priceMinor = Value(priceMinor),
       currency = Value(currency),
       cycleEvery = Value(cycleEvery),
       cycleUnit = Value(cycleUnit),
       anchorDate = Value(anchorDate),
       status = Value(status),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubscriptionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? serviceId,
    Expression<int>? colorValue,
    Expression<String>? iconText,
    Expression<String>? category,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<int>? cycleEvery,
    Expression<String>? cycleUnit,
    Expression<String>? anchorDate,
    Expression<int>? periodIndex,
    Expression<String>? status,
    Expression<String>? trialEndDate,
    Expression<int>? sharedWith,
    Expression<int>? reminderDays,
    Expression<String>? paymentMethod,
    Expression<String>? manageUrl,
    Expression<String>? notes,
    Expression<String>? startDate,
    Expression<String>? cancelledOn,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (serviceId != null) 'service_id': serviceId,
      if (colorValue != null) 'color_value': colorValue,
      if (iconText != null) 'icon_text': iconText,
      if (category != null) 'category': category,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (cycleEvery != null) 'cycle_every': cycleEvery,
      if (cycleUnit != null) 'cycle_unit': cycleUnit,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (periodIndex != null) 'period_index': periodIndex,
      if (status != null) 'status': status,
      if (trialEndDate != null) 'trial_end_date': trialEndDate,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (manageUrl != null) 'manage_url': manageUrl,
      if (notes != null) 'notes': notes,
      if (startDate != null) 'start_date': startDate,
      if (cancelledOn != null) 'cancelled_on': cancelledOn,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? serviceId,
    Value<int>? colorValue,
    Value<String?>? iconText,
    Value<String>? category,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<int>? cycleEvery,
    Value<String>? cycleUnit,
    Value<String>? anchorDate,
    Value<int>? periodIndex,
    Value<String>? status,
    Value<String?>? trialEndDate,
    Value<int>? sharedWith,
    Value<int?>? reminderDays,
    Value<String?>? paymentMethod,
    Value<String?>? manageUrl,
    Value<String?>? notes,
    Value<String>? startDate,
    Value<String?>? cancelledOn,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      serviceId: serviceId ?? this.serviceId,
      colorValue: colorValue ?? this.colorValue,
      iconText: iconText ?? this.iconText,
      category: category ?? this.category,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      cycleEvery: cycleEvery ?? this.cycleEvery,
      cycleUnit: cycleUnit ?? this.cycleUnit,
      anchorDate: anchorDate ?? this.anchorDate,
      periodIndex: periodIndex ?? this.periodIndex,
      status: status ?? this.status,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      sharedWith: sharedWith ?? this.sharedWith,
      reminderDays: reminderDays ?? this.reminderDays,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      manageUrl: manageUrl ?? this.manageUrl,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      cancelledOn: cancelledOn ?? this.cancelledOn,
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
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (iconText.present) {
      map['icon_text'] = Variable<String>(iconText.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (cycleEvery.present) {
      map['cycle_every'] = Variable<int>(cycleEvery.value);
    }
    if (cycleUnit.present) {
      map['cycle_unit'] = Variable<String>(cycleUnit.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (periodIndex.present) {
      map['period_index'] = Variable<int>(periodIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (trialEndDate.present) {
      map['trial_end_date'] = Variable<String>(trialEndDate.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<int>(sharedWith.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<int>(reminderDays.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (manageUrl.present) {
      map['manage_url'] = Variable<String>(manageUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (cancelledOn.present) {
      map['cancelled_on'] = Variable<String>(cancelledOn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('serviceId: $serviceId, ')
          ..write('colorValue: $colorValue, ')
          ..write('iconText: $iconText, ')
          ..write('category: $category, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('periodIndex: $periodIndex, ')
          ..write('status: $status, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('manageUrl: $manageUrl, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('cancelledOn: $cancelledOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConfirmedPeriodsTable extends ConfirmedPeriods
    with TableInfo<$ConfirmedPeriodsTable, ConfirmedPeriodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfirmedPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscriptions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subscriptionId,
    dueDate,
    outcome,
    amountMinor,
    currency,
    confirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'confirmed_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfirmedPeriodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    } else if (isInserting) {
      context.missing(_outcomeMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {subscriptionId, dueDate},
  ];
  @override
  ConfirmedPeriodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfirmedPeriodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_date'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      )!,
    );
  }

  @override
  $ConfirmedPeriodsTable createAlias(String alias) {
    return $ConfirmedPeriodsTable(attachedDatabase, alias);
  }
}

class ConfirmedPeriodRow extends DataClass
    implements Insertable<ConfirmedPeriodRow> {
  final String id;
  final String subscriptionId;
  final String dueDate;
  final String outcome;
  final int amountMinor;
  final String currency;
  final DateTime confirmedAt;
  const ConfirmedPeriodRow({
    required this.id,
    required this.subscriptionId,
    required this.dueDate,
    required this.outcome,
    required this.amountMinor,
    required this.currency,
    required this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['due_date'] = Variable<String>(dueDate);
    map['outcome'] = Variable<String>(outcome);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    return map;
  }

  ConfirmedPeriodsCompanion toCompanion(bool nullToAbsent) {
    return ConfirmedPeriodsCompanion(
      id: Value(id),
      subscriptionId: Value(subscriptionId),
      dueDate: Value(dueDate),
      outcome: Value(outcome),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      confirmedAt: Value(confirmedAt),
    );
  }

  factory ConfirmedPeriodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfirmedPeriodRow(
      id: serializer.fromJson<String>(json['id']),
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      dueDate: serializer.fromJson<String>(json['dueDate']),
      outcome: serializer.fromJson<String>(json['outcome']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      confirmedAt: serializer.fromJson<DateTime>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'dueDate': serializer.toJson<String>(dueDate),
      'outcome': serializer.toJson<String>(outcome),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'confirmedAt': serializer.toJson<DateTime>(confirmedAt),
    };
  }

  ConfirmedPeriodRow copyWith({
    String? id,
    String? subscriptionId,
    String? dueDate,
    String? outcome,
    int? amountMinor,
    String? currency,
    DateTime? confirmedAt,
  }) => ConfirmedPeriodRow(
    id: id ?? this.id,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    dueDate: dueDate ?? this.dueDate,
    outcome: outcome ?? this.outcome,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    confirmedAt: confirmedAt ?? this.confirmedAt,
  );
  ConfirmedPeriodRow copyWithCompanion(ConfirmedPeriodsCompanion data) {
    return ConfirmedPeriodRow(
      id: data.id.present ? data.id.value : this.id,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfirmedPeriodRow(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('dueDate: $dueDate, ')
          ..write('outcome: $outcome, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subscriptionId,
    dueDate,
    outcome,
    amountMinor,
    currency,
    confirmedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfirmedPeriodRow &&
          other.id == this.id &&
          other.subscriptionId == this.subscriptionId &&
          other.dueDate == this.dueDate &&
          other.outcome == this.outcome &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.confirmedAt == this.confirmedAt);
}

class ConfirmedPeriodsCompanion extends UpdateCompanion<ConfirmedPeriodRow> {
  final Value<String> id;
  final Value<String> subscriptionId;
  final Value<String> dueDate;
  final Value<String> outcome;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<DateTime> confirmedAt;
  final Value<int> rowid;
  const ConfirmedPeriodsCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.outcome = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConfirmedPeriodsCompanion.insert({
    required String id,
    required String subscriptionId,
    required String dueDate,
    required String outcome,
    required int amountMinor,
    required String currency,
    required DateTime confirmedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subscriptionId = Value(subscriptionId),
       dueDate = Value(dueDate),
       outcome = Value(outcome),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       confirmedAt = Value(confirmedAt);
  static Insertable<ConfirmedPeriodRow> custom({
    Expression<String>? id,
    Expression<String>? subscriptionId,
    Expression<String>? dueDate,
    Expression<String>? outcome,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<DateTime>? confirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (dueDate != null) 'due_date': dueDate,
      if (outcome != null) 'outcome': outcome,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConfirmedPeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? subscriptionId,
    Value<String>? dueDate,
    Value<String>? outcome,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<DateTime>? confirmedAt,
    Value<int>? rowid,
  }) {
    return ConfirmedPeriodsCompanion(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      dueDate: dueDate ?? this.dueDate,
      outcome: outcome ?? this.outcome,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<String>(dueDate.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfirmedPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('dueDate: $dueDate, ')
          ..write('outcome: $outcome, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedRatesTable extends CachedRates
    with TableInfo<$CachedRatesTable, CachedRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _perUsdMeta = const VerificationMeta('perUsd');
  @override
  late final GeneratedColumn<double> perUsd = GeneratedColumn<double>(
    'per_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, perUsd];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('per_usd')) {
      context.handle(
        _perUsdMeta,
        perUsd.isAcceptableOrUnknown(data['per_usd']!, _perUsdMeta),
      );
    } else if (isInserting) {
      context.missing(_perUsdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  CachedRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedRateRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      perUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}per_usd'],
      )!,
    );
  }

  @override
  $CachedRatesTable createAlias(String alias) {
    return $CachedRatesTable(attachedDatabase, alias);
  }
}

class CachedRateRow extends DataClass implements Insertable<CachedRateRow> {
  final String code;
  final double perUsd;
  const CachedRateRow({required this.code, required this.perUsd});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['per_usd'] = Variable<double>(perUsd);
    return map;
  }

  CachedRatesCompanion toCompanion(bool nullToAbsent) {
    return CachedRatesCompanion(code: Value(code), perUsd: Value(perUsd));
  }

  factory CachedRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedRateRow(
      code: serializer.fromJson<String>(json['code']),
      perUsd: serializer.fromJson<double>(json['perUsd']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'perUsd': serializer.toJson<double>(perUsd),
    };
  }

  CachedRateRow copyWith({String? code, double? perUsd}) =>
      CachedRateRow(code: code ?? this.code, perUsd: perUsd ?? this.perUsd);
  CachedRateRow copyWithCompanion(CachedRatesCompanion data) {
    return CachedRateRow(
      code: data.code.present ? data.code.value : this.code,
      perUsd: data.perUsd.present ? data.perUsd.value : this.perUsd,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedRateRow(')
          ..write('code: $code, ')
          ..write('perUsd: $perUsd')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, perUsd);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedRateRow &&
          other.code == this.code &&
          other.perUsd == this.perUsd);
}

class CachedRatesCompanion extends UpdateCompanion<CachedRateRow> {
  final Value<String> code;
  final Value<double> perUsd;
  final Value<int> rowid;
  const CachedRatesCompanion({
    this.code = const Value.absent(),
    this.perUsd = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedRatesCompanion.insert({
    required String code,
    required double perUsd,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       perUsd = Value(perUsd);
  static Insertable<CachedRateRow> custom({
    Expression<String>? code,
    Expression<double>? perUsd,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (perUsd != null) 'per_usd': perUsd,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedRatesCompanion copyWith({
    Value<String>? code,
    Value<double>? perUsd,
    Value<int>? rowid,
  }) {
    return CachedRatesCompanion(
      code: code ?? this.code,
      perUsd: perUsd ?? this.perUsd,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (perUsd.present) {
      map['per_usd'] = Variable<double>(perUsd.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedRatesCompanion(')
          ..write('code: $code, ')
          ..write('perUsd: $perUsd, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RateOverridesTable extends RateOverrides
    with TableInfo<$RateOverridesTable, RateOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RateOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pairMeta = const VerificationMeta('pair');
  @override
  late final GeneratedColumn<String> pair = GeneratedColumn<String>(
    'pair',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [pair, rate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rate_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<RateOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pair')) {
      context.handle(
        _pairMeta,
        pair.isAcceptableOrUnknown(data['pair']!, _pairMeta),
      );
    } else if (isInserting) {
      context.missing(_pairMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pair};
  @override
  RateOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateOverrideRow(
      pair: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pair'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  $RateOverridesTable createAlias(String alias) {
    return $RateOverridesTable(attachedDatabase, alias);
  }
}

class RateOverrideRow extends DataClass implements Insertable<RateOverrideRow> {
  final String pair;
  final double rate;
  const RateOverrideRow({required this.pair, required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pair'] = Variable<String>(pair);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  RateOverridesCompanion toCompanion(bool nullToAbsent) {
    return RateOverridesCompanion(pair: Value(pair), rate: Value(rate));
  }

  factory RateOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateOverrideRow(
      pair: serializer.fromJson<String>(json['pair']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pair': serializer.toJson<String>(pair),
      'rate': serializer.toJson<double>(rate),
    };
  }

  RateOverrideRow copyWith({String? pair, double? rate}) =>
      RateOverrideRow(pair: pair ?? this.pair, rate: rate ?? this.rate);
  RateOverrideRow copyWithCompanion(RateOverridesCompanion data) {
    return RateOverrideRow(
      pair: data.pair.present ? data.pair.value : this.pair,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateOverrideRow(')
          ..write('pair: $pair, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pair, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateOverrideRow &&
          other.pair == this.pair &&
          other.rate == this.rate);
}

class RateOverridesCompanion extends UpdateCompanion<RateOverrideRow> {
  final Value<String> pair;
  final Value<double> rate;
  final Value<int> rowid;
  const RateOverridesCompanion({
    this.pair = const Value.absent(),
    this.rate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RateOverridesCompanion.insert({
    required String pair,
    required double rate,
    this.rowid = const Value.absent(),
  }) : pair = Value(pair),
       rate = Value(rate);
  static Insertable<RateOverrideRow> custom({
    Expression<String>? pair,
    Expression<double>? rate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pair != null) 'pair': pair,
      if (rate != null) 'rate': rate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RateOverridesCompanion copyWith({
    Value<String>? pair,
    Value<double>? rate,
    Value<int>? rowid,
  }) {
    return RateOverridesCompanion(
      pair: pair ?? this.pair,
      rate: rate ?? this.rate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pair.present) {
      map['pair'] = Variable<String>(pair.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RateOverridesCompanion(')
          ..write('pair: $pair, ')
          ..write('rate: $rate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $ConfirmedPeriodsTable confirmedPeriods = $ConfirmedPeriodsTable(
    this,
  );
  late final $CachedRatesTable cachedRates = $CachedRatesTable(this);
  late final $RateOverridesTable rateOverrides = $RateOverridesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subscriptions,
    confirmedPeriods,
    cachedRates,
    rateOverrides,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('confirmed_periods', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      required String id,
      required String name,
      Value<String?> serviceId,
      required int colorValue,
      Value<String?> iconText,
      required String category,
      required int priceMinor,
      required String currency,
      required int cycleEvery,
      required String cycleUnit,
      required String anchorDate,
      Value<int> periodIndex,
      required String status,
      Value<String?> trialEndDate,
      Value<int> sharedWith,
      Value<int?> reminderDays,
      Value<String?> paymentMethod,
      Value<String?> manageUrl,
      Value<String?> notes,
      required String startDate,
      Value<String?> cancelledOn,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> serviceId,
      Value<int> colorValue,
      Value<String?> iconText,
      Value<String> category,
      Value<int> priceMinor,
      Value<String> currency,
      Value<int> cycleEvery,
      Value<String> cycleUnit,
      Value<String> anchorDate,
      Value<int> periodIndex,
      Value<String> status,
      Value<String?> trialEndDate,
      Value<int> sharedWith,
      Value<int?> reminderDays,
      Value<String?> paymentMethod,
      Value<String?> manageUrl,
      Value<String?> notes,
      Value<String> startDate,
      Value<String?> cancelledOn,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SubscriptionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubscriptionsTable, SubscriptionRow> {
  $$SubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ConfirmedPeriodsTable, List<ConfirmedPeriodRow>>
  _confirmedPeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.confirmedPeriods,
    aliasName: 'subscriptions__id__confirmed_periods__subscription_id',
  );

  $$ConfirmedPeriodsTableProcessedTableManager get confirmedPeriodsRefs {
    final manager = $$ConfirmedPeriodsTableTableManager(
      $_db,
      $_db.confirmedPeriods,
    ).filter((f) => f.subscriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _confirmedPeriodsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
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

  ColumnFilters<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconText => $composableBuilder(
    column: $table.iconText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleEvery => $composableBuilder(
    column: $table.cycleEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleUnit => $composableBuilder(
    column: $table.cycleUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodIndex => $composableBuilder(
    column: $table.periodIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manageUrl => $composableBuilder(
    column: $table.manageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelledOn => $composableBuilder(
    column: $table.cancelledOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> confirmedPeriodsRefs(
    Expression<bool> Function($$ConfirmedPeriodsTableFilterComposer f) f,
  ) {
    final $$ConfirmedPeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.confirmedPeriods,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConfirmedPeriodsTableFilterComposer(
            $db: $db,
            $table: $db.confirmedPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
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

  ColumnOrderings<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconText => $composableBuilder(
    column: $table.iconText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleEvery => $composableBuilder(
    column: $table.cycleEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleUnit => $composableBuilder(
    column: $table.cycleUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodIndex => $composableBuilder(
    column: $table.periodIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manageUrl => $composableBuilder(
    column: $table.manageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelledOn => $composableBuilder(
    column: $table.cancelledOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
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

  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconText =>
      $composableBuilder(column: $table.iconText, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get cycleEvery => $composableBuilder(
    column: $table.cycleEvery,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cycleUnit =>
      $composableBuilder(column: $table.cycleUnit, builder: (column) => column);

  GeneratedColumn<String> get anchorDate => $composableBuilder(
    column: $table.anchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodIndex => $composableBuilder(
    column: $table.periodIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderDays => $composableBuilder(
    column: $table.reminderDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manageUrl =>
      $composableBuilder(column: $table.manageUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get cancelledOn => $composableBuilder(
    column: $table.cancelledOn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> confirmedPeriodsRefs<T extends Object>(
    Expression<T> Function($$ConfirmedPeriodsTableAnnotationComposer a) f,
  ) {
    final $$ConfirmedPeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.confirmedPeriods,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConfirmedPeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.confirmedPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          SubscriptionRow,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (SubscriptionRow, $$SubscriptionsTableReferences),
          SubscriptionRow,
          PrefetchHooks Function({bool confirmedPeriodsRefs})
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> serviceId = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> iconText = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> cycleEvery = const Value.absent(),
                Value<String> cycleUnit = const Value.absent(),
                Value<String> anchorDate = const Value.absent(),
                Value<int> periodIndex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> trialEndDate = const Value.absent(),
                Value<int> sharedWith = const Value.absent(),
                Value<int?> reminderDays = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> manageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> cancelledOn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                name: name,
                serviceId: serviceId,
                colorValue: colorValue,
                iconText: iconText,
                category: category,
                priceMinor: priceMinor,
                currency: currency,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                anchorDate: anchorDate,
                periodIndex: periodIndex,
                status: status,
                trialEndDate: trialEndDate,
                sharedWith: sharedWith,
                reminderDays: reminderDays,
                paymentMethod: paymentMethod,
                manageUrl: manageUrl,
                notes: notes,
                startDate: startDate,
                cancelledOn: cancelledOn,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> serviceId = const Value.absent(),
                required int colorValue,
                Value<String?> iconText = const Value.absent(),
                required String category,
                required int priceMinor,
                required String currency,
                required int cycleEvery,
                required String cycleUnit,
                required String anchorDate,
                Value<int> periodIndex = const Value.absent(),
                required String status,
                Value<String?> trialEndDate = const Value.absent(),
                Value<int> sharedWith = const Value.absent(),
                Value<int?> reminderDays = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> manageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String startDate,
                Value<String?> cancelledOn = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                name: name,
                serviceId: serviceId,
                colorValue: colorValue,
                iconText: iconText,
                category: category,
                priceMinor: priceMinor,
                currency: currency,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                anchorDate: anchorDate,
                periodIndex: periodIndex,
                status: status,
                trialEndDate: trialEndDate,
                sharedWith: sharedWith,
                reminderDays: reminderDays,
                paymentMethod: paymentMethod,
                manageUrl: manageUrl,
                notes: notes,
                startDate: startDate,
                cancelledOn: cancelledOn,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionsTable, SubscriptionRow>(table),
                  $$SubscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({confirmedPeriodsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (confirmedPeriodsRefs) db.confirmedPeriods,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (confirmedPeriodsRefs)
                    await $_getPrefetchedDataByColumns<
                      SubscriptionRow,
                      $SubscriptionsTable,
                      ConfirmedPeriodRow,
                      $ConfirmedPeriodsTable
                    >(
                      currentTable: table,
                      referencedTable: $$SubscriptionsTableReferences
                          ._confirmedPeriodsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SubscriptionsTableReferences(
                            db,
                            table,
                            p0,
                          ).confirmedPeriodsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'subscription_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      SubscriptionRow,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (SubscriptionRow, $$SubscriptionsTableReferences),
      SubscriptionRow,
      PrefetchHooks Function({bool confirmedPeriodsRefs})
    >;
typedef $$ConfirmedPeriodsTableCreateCompanionBuilder =
    ConfirmedPeriodsCompanion Function({
      required String id,
      required String subscriptionId,
      required String dueDate,
      required String outcome,
      required int amountMinor,
      required String currency,
      required DateTime confirmedAt,
      Value<int> rowid,
    });
typedef $$ConfirmedPeriodsTableUpdateCompanionBuilder =
    ConfirmedPeriodsCompanion Function({
      Value<String> id,
      Value<String> subscriptionId,
      Value<String> dueDate,
      Value<String> outcome,
      Value<int> amountMinor,
      Value<String> currency,
      Value<DateTime> confirmedAt,
      Value<int> rowid,
    });

final class $$ConfirmedPeriodsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ConfirmedPeriodsTable,
          ConfirmedPeriodRow
        > {
  $$ConfirmedPeriodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubscriptionsTable _subscriptionIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('confirmed_periods__subscription_id__subscriptions__id');

  $$SubscriptionsTableProcessedTableManager get subscriptionId {
    final $_column = $_itemColumn<String>('subscription_id')!;

    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subscriptionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConfirmedPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $ConfirmedPeriodsTable> {
  $$ConfirmedPeriodsTableFilterComposer({
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

  ColumnFilters<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscriptionsTableFilterComposer get subscriptionId {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfirmedPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfirmedPeriodsTable> {
  $$ConfirmedPeriodsTableOrderingComposer({
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

  ColumnOrderings<String> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscriptionsTableOrderingComposer get subscriptionId {
    final $$SubscriptionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableOrderingComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfirmedPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfirmedPeriodsTable> {
  $$ConfirmedPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  $$SubscriptionsTableAnnotationComposer get subscriptionId {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriptionId,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConfirmedPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfirmedPeriodsTable,
          ConfirmedPeriodRow,
          $$ConfirmedPeriodsTableFilterComposer,
          $$ConfirmedPeriodsTableOrderingComposer,
          $$ConfirmedPeriodsTableAnnotationComposer,
          $$ConfirmedPeriodsTableCreateCompanionBuilder,
          $$ConfirmedPeriodsTableUpdateCompanionBuilder,
          (ConfirmedPeriodRow, $$ConfirmedPeriodsTableReferences),
          ConfirmedPeriodRow,
          PrefetchHooks Function({bool subscriptionId})
        > {
  $$ConfirmedPeriodsTableTableManager(
    _$AppDatabase db,
    $ConfirmedPeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfirmedPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfirmedPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfirmedPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subscriptionId = const Value.absent(),
                Value<String> dueDate = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfirmedPeriodsCompanion(
                id: id,
                subscriptionId: subscriptionId,
                dueDate: dueDate,
                outcome: outcome,
                amountMinor: amountMinor,
                currency: currency,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subscriptionId,
                required String dueDate,
                required String outcome,
                required int amountMinor,
                required String currency,
                required DateTime confirmedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConfirmedPeriodsCompanion.insert(
                id: id,
                subscriptionId: subscriptionId,
                dueDate: dueDate,
                outcome: outcome,
                amountMinor: amountMinor,
                currency: currency,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConfirmedPeriodsTable, ConfirmedPeriodRow>(
                    table,
                  ),
                  $$ConfirmedPeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriptionId = false}) {
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
                    if (subscriptionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.subscriptionId,
                        referencedTable: $$ConfirmedPeriodsTableReferences
                            ._subscriptionIdTable(db),
                        referencedColumn: $$ConfirmedPeriodsTableReferences
                            ._subscriptionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ConfirmedPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfirmedPeriodsTable,
      ConfirmedPeriodRow,
      $$ConfirmedPeriodsTableFilterComposer,
      $$ConfirmedPeriodsTableOrderingComposer,
      $$ConfirmedPeriodsTableAnnotationComposer,
      $$ConfirmedPeriodsTableCreateCompanionBuilder,
      $$ConfirmedPeriodsTableUpdateCompanionBuilder,
      (ConfirmedPeriodRow, $$ConfirmedPeriodsTableReferences),
      ConfirmedPeriodRow,
      PrefetchHooks Function({bool subscriptionId})
    >;
typedef $$CachedRatesTableCreateCompanionBuilder =
    CachedRatesCompanion Function({
      required String code,
      required double perUsd,
      Value<int> rowid,
    });
typedef $$CachedRatesTableUpdateCompanionBuilder =
    CachedRatesCompanion Function({
      Value<String> code,
      Value<double> perUsd,
      Value<int> rowid,
    });

class $$CachedRatesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedRatesTable> {
  $$CachedRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get perUsd => $composableBuilder(
    column: $table.perUsd,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedRatesTable> {
  $$CachedRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get perUsd => $composableBuilder(
    column: $table.perUsd,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedRatesTable> {
  $$CachedRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<double> get perUsd =>
      $composableBuilder(column: $table.perUsd, builder: (column) => column);
}

class $$CachedRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedRatesTable,
          CachedRateRow,
          $$CachedRatesTableFilterComposer,
          $$CachedRatesTableOrderingComposer,
          $$CachedRatesTableAnnotationComposer,
          $$CachedRatesTableCreateCompanionBuilder,
          $$CachedRatesTableUpdateCompanionBuilder,
          (
            CachedRateRow,
            BaseReferences<_$AppDatabase, $CachedRatesTable, CachedRateRow>,
          ),
          CachedRateRow,
          PrefetchHooks Function()
        > {
  $$CachedRatesTableTableManager(_$AppDatabase db, $CachedRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> code = const Value.absent(),
            Value<double> perUsd = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CachedRatesCompanion(code: code, perUsd: perUsd, rowid: rowid),
          createCompanionCallback:
              ({
                required String code,
                required double perUsd,
                Value<int> rowid = const Value.absent(),
              }) => CachedRatesCompanion.insert(
                code: code,
                perUsd: perUsd,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedRatesTable, CachedRateRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedRatesTable,
                    CachedRateRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedRatesTable,
      CachedRateRow,
      $$CachedRatesTableFilterComposer,
      $$CachedRatesTableOrderingComposer,
      $$CachedRatesTableAnnotationComposer,
      $$CachedRatesTableCreateCompanionBuilder,
      $$CachedRatesTableUpdateCompanionBuilder,
      (
        CachedRateRow,
        BaseReferences<_$AppDatabase, $CachedRatesTable, CachedRateRow>,
      ),
      CachedRateRow,
      PrefetchHooks Function()
    >;
typedef $$RateOverridesTableCreateCompanionBuilder =
    RateOverridesCompanion Function({
      required String pair,
      required double rate,
      Value<int> rowid,
    });
typedef $$RateOverridesTableUpdateCompanionBuilder =
    RateOverridesCompanion Function({
      Value<String> pair,
      Value<double> rate,
      Value<int> rowid,
    });

class $$RateOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $RateOverridesTable> {
  $$RateOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RateOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $RateOverridesTable> {
  $$RateOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get pair => $composableBuilder(
    column: $table.pair,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RateOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RateOverridesTable> {
  $$RateOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get pair =>
      $composableBuilder(column: $table.pair, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$RateOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RateOverridesTable,
          RateOverrideRow,
          $$RateOverridesTableFilterComposer,
          $$RateOverridesTableOrderingComposer,
          $$RateOverridesTableAnnotationComposer,
          $$RateOverridesTableCreateCompanionBuilder,
          $$RateOverridesTableUpdateCompanionBuilder,
          (
            RateOverrideRow,
            BaseReferences<_$AppDatabase, $RateOverridesTable, RateOverrideRow>,
          ),
          RateOverrideRow,
          PrefetchHooks Function()
        > {
  $$RateOverridesTableTableManager(_$AppDatabase db, $RateOverridesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RateOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RateOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RateOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> pair = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => RateOverridesCompanion(pair: pair, rate: rate, rowid: rowid),
          createCompanionCallback:
              ({
                required String pair,
                required double rate,
                Value<int> rowid = const Value.absent(),
              }) => RateOverridesCompanion.insert(
                pair: pair,
                rate: rate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RateOverridesTable, RateOverrideRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RateOverridesTable,
                    RateOverrideRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RateOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RateOverridesTable,
      RateOverrideRow,
      $$RateOverridesTableFilterComposer,
      $$RateOverridesTableOrderingComposer,
      $$RateOverridesTableAnnotationComposer,
      $$RateOverridesTableCreateCompanionBuilder,
      $$RateOverridesTableUpdateCompanionBuilder,
      (
        RateOverrideRow,
        BaseReferences<_$AppDatabase, $RateOverridesTable, RateOverrideRow>,
      ),
      RateOverrideRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>(
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

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$ConfirmedPeriodsTableTableManager get confirmedPeriods =>
      $$ConfirmedPeriodsTableTableManager(_db, _db.confirmedPeriods);
  $$CachedRatesTableTableManager get cachedRates =>
      $$CachedRatesTableTableManager(_db, _db.cachedRates);
  $$RateOverridesTableTableManager get rateOverrides =>
      $$RateOverridesTableTableManager(_db, _db.rateOverrides);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
