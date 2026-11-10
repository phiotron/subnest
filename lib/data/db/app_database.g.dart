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
  static const VerificationMeta _customLogoFileMeta = const VerificationMeta(
    'customLogoFile',
  );
  @override
  late final GeneratedColumn<String> customLogoFile = GeneratedColumn<String>(
    'custom_logo_file',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
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
  static const VerificationMeta _reminderOffsetsMeta = const VerificationMeta(
    'reminderOffsets',
  );
  @override
  late final GeneratedColumn<String> reminderOffsets = GeneratedColumn<String>(
    'reminder_offsets',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodIdMeta = const VerificationMeta(
    'paymentMethodId',
  );
  @override
  late final GeneratedColumn<String> paymentMethodId = GeneratedColumn<String>(
    'payment_method_id',
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
  static const VerificationMeta _pausedFromMeta = const VerificationMeta(
    'pausedFrom',
  );
  @override
  late final GeneratedColumn<String> pausedFrom = GeneratedColumn<String>(
    'paused_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _worthItMeta = const VerificationMeta(
    'worthIt',
  );
  @override
  late final GeneratedColumn<String> worthIt = GeneratedColumn<String>(
    'worth_it',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectionSourceMeta = const VerificationMeta(
    'detectionSource',
  );
  @override
  late final GeneratedColumn<String> detectionSource = GeneratedColumn<String>(
    'detection_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    customLogoFile,
    categoryId,
    priceMinor,
    currency,
    cycleEvery,
    cycleUnit,
    anchorDate,
    periodIndex,
    status,
    trialEndDate,
    sharedWith,
    reminderOffsets,
    paymentMethodId,
    manageUrl,
    notes,
    startDate,
    cancelledOn,
    pausedFrom,
    worthIt,
    detectionSource,
    detectedAt,
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
    if (data.containsKey('custom_logo_file')) {
      context.handle(
        _customLogoFileMeta,
        customLogoFile.isAcceptableOrUnknown(
          data['custom_logo_file']!,
          _customLogoFileMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
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
    if (data.containsKey('reminder_offsets')) {
      context.handle(
        _reminderOffsetsMeta,
        reminderOffsets.isAcceptableOrUnknown(
          data['reminder_offsets']!,
          _reminderOffsetsMeta,
        ),
      );
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
        _paymentMethodIdMeta,
        paymentMethodId.isAcceptableOrUnknown(
          data['payment_method_id']!,
          _paymentMethodIdMeta,
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
    if (data.containsKey('paused_from')) {
      context.handle(
        _pausedFromMeta,
        pausedFrom.isAcceptableOrUnknown(data['paused_from']!, _pausedFromMeta),
      );
    }
    if (data.containsKey('worth_it')) {
      context.handle(
        _worthItMeta,
        worthIt.isAcceptableOrUnknown(data['worth_it']!, _worthItMeta),
      );
    }
    if (data.containsKey('detection_source')) {
      context.handle(
        _detectionSourceMeta,
        detectionSource.isAcceptableOrUnknown(
          data['detection_source']!,
          _detectionSourceMeta,
        ),
      );
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
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
      customLogoFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_logo_file'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
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
      reminderOffsets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_offsets'],
      ),
      paymentMethodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method_id'],
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
      pausedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paused_from'],
      ),
      worthIt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worth_it'],
      ),
      detectionSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detection_source'],
      ),
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
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
  final String? customLogoFile;
  final String categoryId;
  final int priceMinor;
  final String currency;
  final int cycleEvery;
  final String cycleUnit;
  final String anchorDate;
  final int periodIndex;
  final String status;
  final String? trialEndDate;
  final int sharedWith;
  final String? reminderOffsets;
  final String? paymentMethodId;
  final String? manageUrl;
  final String? notes;
  final String startDate;
  final String? cancelledOn;
  final String? pausedFrom;
  final String? worthIt;
  final String? detectionSource;
  final DateTime? detectedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubscriptionRow({
    required this.id,
    required this.name,
    this.serviceId,
    required this.colorValue,
    this.iconText,
    this.customLogoFile,
    required this.categoryId,
    required this.priceMinor,
    required this.currency,
    required this.cycleEvery,
    required this.cycleUnit,
    required this.anchorDate,
    required this.periodIndex,
    required this.status,
    this.trialEndDate,
    required this.sharedWith,
    this.reminderOffsets,
    this.paymentMethodId,
    this.manageUrl,
    this.notes,
    required this.startDate,
    this.cancelledOn,
    this.pausedFrom,
    this.worthIt,
    this.detectionSource,
    this.detectedAt,
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
    if (!nullToAbsent || customLogoFile != null) {
      map['custom_logo_file'] = Variable<String>(customLogoFile);
    }
    map['category_id'] = Variable<String>(categoryId);
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
    if (!nullToAbsent || reminderOffsets != null) {
      map['reminder_offsets'] = Variable<String>(reminderOffsets);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<String>(paymentMethodId);
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
    if (!nullToAbsent || pausedFrom != null) {
      map['paused_from'] = Variable<String>(pausedFrom);
    }
    if (!nullToAbsent || worthIt != null) {
      map['worth_it'] = Variable<String>(worthIt);
    }
    if (!nullToAbsent || detectionSource != null) {
      map['detection_source'] = Variable<String>(detectionSource);
    }
    if (!nullToAbsent || detectedAt != null) {
      map['detected_at'] = Variable<DateTime>(detectedAt);
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
      customLogoFile: customLogoFile == null && nullToAbsent
          ? const Value.absent()
          : Value(customLogoFile),
      categoryId: Value(categoryId),
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
      reminderOffsets: reminderOffsets == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderOffsets),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
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
      pausedFrom: pausedFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(pausedFrom),
      worthIt: worthIt == null && nullToAbsent
          ? const Value.absent()
          : Value(worthIt),
      detectionSource: detectionSource == null && nullToAbsent
          ? const Value.absent()
          : Value(detectionSource),
      detectedAt: detectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(detectedAt),
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
      customLogoFile: serializer.fromJson<String?>(json['customLogoFile']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      cycleEvery: serializer.fromJson<int>(json['cycleEvery']),
      cycleUnit: serializer.fromJson<String>(json['cycleUnit']),
      anchorDate: serializer.fromJson<String>(json['anchorDate']),
      periodIndex: serializer.fromJson<int>(json['periodIndex']),
      status: serializer.fromJson<String>(json['status']),
      trialEndDate: serializer.fromJson<String?>(json['trialEndDate']),
      sharedWith: serializer.fromJson<int>(json['sharedWith']),
      reminderOffsets: serializer.fromJson<String?>(json['reminderOffsets']),
      paymentMethodId: serializer.fromJson<String?>(json['paymentMethodId']),
      manageUrl: serializer.fromJson<String?>(json['manageUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      startDate: serializer.fromJson<String>(json['startDate']),
      cancelledOn: serializer.fromJson<String?>(json['cancelledOn']),
      pausedFrom: serializer.fromJson<String?>(json['pausedFrom']),
      worthIt: serializer.fromJson<String?>(json['worthIt']),
      detectionSource: serializer.fromJson<String?>(json['detectionSource']),
      detectedAt: serializer.fromJson<DateTime?>(json['detectedAt']),
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
      'customLogoFile': serializer.toJson<String?>(customLogoFile),
      'categoryId': serializer.toJson<String>(categoryId),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'currency': serializer.toJson<String>(currency),
      'cycleEvery': serializer.toJson<int>(cycleEvery),
      'cycleUnit': serializer.toJson<String>(cycleUnit),
      'anchorDate': serializer.toJson<String>(anchorDate),
      'periodIndex': serializer.toJson<int>(periodIndex),
      'status': serializer.toJson<String>(status),
      'trialEndDate': serializer.toJson<String?>(trialEndDate),
      'sharedWith': serializer.toJson<int>(sharedWith),
      'reminderOffsets': serializer.toJson<String?>(reminderOffsets),
      'paymentMethodId': serializer.toJson<String?>(paymentMethodId),
      'manageUrl': serializer.toJson<String?>(manageUrl),
      'notes': serializer.toJson<String?>(notes),
      'startDate': serializer.toJson<String>(startDate),
      'cancelledOn': serializer.toJson<String?>(cancelledOn),
      'pausedFrom': serializer.toJson<String?>(pausedFrom),
      'worthIt': serializer.toJson<String?>(worthIt),
      'detectionSource': serializer.toJson<String?>(detectionSource),
      'detectedAt': serializer.toJson<DateTime?>(detectedAt),
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
    Value<String?> customLogoFile = const Value.absent(),
    String? categoryId,
    int? priceMinor,
    String? currency,
    int? cycleEvery,
    String? cycleUnit,
    String? anchorDate,
    int? periodIndex,
    String? status,
    Value<String?> trialEndDate = const Value.absent(),
    int? sharedWith,
    Value<String?> reminderOffsets = const Value.absent(),
    Value<String?> paymentMethodId = const Value.absent(),
    Value<String?> manageUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? startDate,
    Value<String?> cancelledOn = const Value.absent(),
    Value<String?> pausedFrom = const Value.absent(),
    Value<String?> worthIt = const Value.absent(),
    Value<String?> detectionSource = const Value.absent(),
    Value<DateTime?> detectedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubscriptionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    serviceId: serviceId.present ? serviceId.value : this.serviceId,
    colorValue: colorValue ?? this.colorValue,
    iconText: iconText.present ? iconText.value : this.iconText,
    customLogoFile: customLogoFile.present
        ? customLogoFile.value
        : this.customLogoFile,
    categoryId: categoryId ?? this.categoryId,
    priceMinor: priceMinor ?? this.priceMinor,
    currency: currency ?? this.currency,
    cycleEvery: cycleEvery ?? this.cycleEvery,
    cycleUnit: cycleUnit ?? this.cycleUnit,
    anchorDate: anchorDate ?? this.anchorDate,
    periodIndex: periodIndex ?? this.periodIndex,
    status: status ?? this.status,
    trialEndDate: trialEndDate.present ? trialEndDate.value : this.trialEndDate,
    sharedWith: sharedWith ?? this.sharedWith,
    reminderOffsets: reminderOffsets.present
        ? reminderOffsets.value
        : this.reminderOffsets,
    paymentMethodId: paymentMethodId.present
        ? paymentMethodId.value
        : this.paymentMethodId,
    manageUrl: manageUrl.present ? manageUrl.value : this.manageUrl,
    notes: notes.present ? notes.value : this.notes,
    startDate: startDate ?? this.startDate,
    cancelledOn: cancelledOn.present ? cancelledOn.value : this.cancelledOn,
    pausedFrom: pausedFrom.present ? pausedFrom.value : this.pausedFrom,
    worthIt: worthIt.present ? worthIt.value : this.worthIt,
    detectionSource: detectionSource.present
        ? detectionSource.value
        : this.detectionSource,
    detectedAt: detectedAt.present ? detectedAt.value : this.detectedAt,
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
      customLogoFile: data.customLogoFile.present
          ? data.customLogoFile.value
          : this.customLogoFile,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
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
      reminderOffsets: data.reminderOffsets.present
          ? data.reminderOffsets.value
          : this.reminderOffsets,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      manageUrl: data.manageUrl.present ? data.manageUrl.value : this.manageUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      cancelledOn: data.cancelledOn.present
          ? data.cancelledOn.value
          : this.cancelledOn,
      pausedFrom: data.pausedFrom.present
          ? data.pausedFrom.value
          : this.pausedFrom,
      worthIt: data.worthIt.present ? data.worthIt.value : this.worthIt,
      detectionSource: data.detectionSource.present
          ? data.detectionSource.value
          : this.detectionSource,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
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
          ..write('customLogoFile: $customLogoFile, ')
          ..write('categoryId: $categoryId, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('periodIndex: $periodIndex, ')
          ..write('status: $status, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('reminderOffsets: $reminderOffsets, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('manageUrl: $manageUrl, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('cancelledOn: $cancelledOn, ')
          ..write('pausedFrom: $pausedFrom, ')
          ..write('worthIt: $worthIt, ')
          ..write('detectionSource: $detectionSource, ')
          ..write('detectedAt: $detectedAt, ')
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
    customLogoFile,
    categoryId,
    priceMinor,
    currency,
    cycleEvery,
    cycleUnit,
    anchorDate,
    periodIndex,
    status,
    trialEndDate,
    sharedWith,
    reminderOffsets,
    paymentMethodId,
    manageUrl,
    notes,
    startDate,
    cancelledOn,
    pausedFrom,
    worthIt,
    detectionSource,
    detectedAt,
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
          other.customLogoFile == this.customLogoFile &&
          other.categoryId == this.categoryId &&
          other.priceMinor == this.priceMinor &&
          other.currency == this.currency &&
          other.cycleEvery == this.cycleEvery &&
          other.cycleUnit == this.cycleUnit &&
          other.anchorDate == this.anchorDate &&
          other.periodIndex == this.periodIndex &&
          other.status == this.status &&
          other.trialEndDate == this.trialEndDate &&
          other.sharedWith == this.sharedWith &&
          other.reminderOffsets == this.reminderOffsets &&
          other.paymentMethodId == this.paymentMethodId &&
          other.manageUrl == this.manageUrl &&
          other.notes == this.notes &&
          other.startDate == this.startDate &&
          other.cancelledOn == this.cancelledOn &&
          other.pausedFrom == this.pausedFrom &&
          other.worthIt == this.worthIt &&
          other.detectionSource == this.detectionSource &&
          other.detectedAt == this.detectedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<SubscriptionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> serviceId;
  final Value<int> colorValue;
  final Value<String?> iconText;
  final Value<String?> customLogoFile;
  final Value<String> categoryId;
  final Value<int> priceMinor;
  final Value<String> currency;
  final Value<int> cycleEvery;
  final Value<String> cycleUnit;
  final Value<String> anchorDate;
  final Value<int> periodIndex;
  final Value<String> status;
  final Value<String?> trialEndDate;
  final Value<int> sharedWith;
  final Value<String?> reminderOffsets;
  final Value<String?> paymentMethodId;
  final Value<String?> manageUrl;
  final Value<String?> notes;
  final Value<String> startDate;
  final Value<String?> cancelledOn;
  final Value<String?> pausedFrom;
  final Value<String?> worthIt;
  final Value<String?> detectionSource;
  final Value<DateTime?> detectedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.iconText = const Value.absent(),
    this.customLogoFile = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.cycleEvery = const Value.absent(),
    this.cycleUnit = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.periodIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.reminderOffsets = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.manageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.cancelledOn = const Value.absent(),
    this.pausedFrom = const Value.absent(),
    this.worthIt = const Value.absent(),
    this.detectionSource = const Value.absent(),
    this.detectedAt = const Value.absent(),
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
    this.customLogoFile = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int priceMinor,
    required String currency,
    required int cycleEvery,
    required String cycleUnit,
    required String anchorDate,
    this.periodIndex = const Value.absent(),
    required String status,
    this.trialEndDate = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.reminderOffsets = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.manageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    required String startDate,
    this.cancelledOn = const Value.absent(),
    this.pausedFrom = const Value.absent(),
    this.worthIt = const Value.absent(),
    this.detectionSource = const Value.absent(),
    this.detectedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       colorValue = Value(colorValue),
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
    Expression<String>? customLogoFile,
    Expression<String>? categoryId,
    Expression<int>? priceMinor,
    Expression<String>? currency,
    Expression<int>? cycleEvery,
    Expression<String>? cycleUnit,
    Expression<String>? anchorDate,
    Expression<int>? periodIndex,
    Expression<String>? status,
    Expression<String>? trialEndDate,
    Expression<int>? sharedWith,
    Expression<String>? reminderOffsets,
    Expression<String>? paymentMethodId,
    Expression<String>? manageUrl,
    Expression<String>? notes,
    Expression<String>? startDate,
    Expression<String>? cancelledOn,
    Expression<String>? pausedFrom,
    Expression<String>? worthIt,
    Expression<String>? detectionSource,
    Expression<DateTime>? detectedAt,
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
      if (customLogoFile != null) 'custom_logo_file': customLogoFile,
      if (categoryId != null) 'category_id': categoryId,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (currency != null) 'currency': currency,
      if (cycleEvery != null) 'cycle_every': cycleEvery,
      if (cycleUnit != null) 'cycle_unit': cycleUnit,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (periodIndex != null) 'period_index': periodIndex,
      if (status != null) 'status': status,
      if (trialEndDate != null) 'trial_end_date': trialEndDate,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (reminderOffsets != null) 'reminder_offsets': reminderOffsets,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (manageUrl != null) 'manage_url': manageUrl,
      if (notes != null) 'notes': notes,
      if (startDate != null) 'start_date': startDate,
      if (cancelledOn != null) 'cancelled_on': cancelledOn,
      if (pausedFrom != null) 'paused_from': pausedFrom,
      if (worthIt != null) 'worth_it': worthIt,
      if (detectionSource != null) 'detection_source': detectionSource,
      if (detectedAt != null) 'detected_at': detectedAt,
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
    Value<String?>? customLogoFile,
    Value<String>? categoryId,
    Value<int>? priceMinor,
    Value<String>? currency,
    Value<int>? cycleEvery,
    Value<String>? cycleUnit,
    Value<String>? anchorDate,
    Value<int>? periodIndex,
    Value<String>? status,
    Value<String?>? trialEndDate,
    Value<int>? sharedWith,
    Value<String?>? reminderOffsets,
    Value<String?>? paymentMethodId,
    Value<String?>? manageUrl,
    Value<String?>? notes,
    Value<String>? startDate,
    Value<String?>? cancelledOn,
    Value<String?>? pausedFrom,
    Value<String?>? worthIt,
    Value<String?>? detectionSource,
    Value<DateTime?>? detectedAt,
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
      customLogoFile: customLogoFile ?? this.customLogoFile,
      categoryId: categoryId ?? this.categoryId,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      cycleEvery: cycleEvery ?? this.cycleEvery,
      cycleUnit: cycleUnit ?? this.cycleUnit,
      anchorDate: anchorDate ?? this.anchorDate,
      periodIndex: periodIndex ?? this.periodIndex,
      status: status ?? this.status,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      sharedWith: sharedWith ?? this.sharedWith,
      reminderOffsets: reminderOffsets ?? this.reminderOffsets,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      manageUrl: manageUrl ?? this.manageUrl,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      cancelledOn: cancelledOn ?? this.cancelledOn,
      pausedFrom: pausedFrom ?? this.pausedFrom,
      worthIt: worthIt ?? this.worthIt,
      detectionSource: detectionSource ?? this.detectionSource,
      detectedAt: detectedAt ?? this.detectedAt,
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
    if (customLogoFile.present) {
      map['custom_logo_file'] = Variable<String>(customLogoFile.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
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
    if (reminderOffsets.present) {
      map['reminder_offsets'] = Variable<String>(reminderOffsets.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<String>(paymentMethodId.value);
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
    if (pausedFrom.present) {
      map['paused_from'] = Variable<String>(pausedFrom.value);
    }
    if (worthIt.present) {
      map['worth_it'] = Variable<String>(worthIt.value);
    }
    if (detectionSource.present) {
      map['detection_source'] = Variable<String>(detectionSource.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
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
          ..write('customLogoFile: $customLogoFile, ')
          ..write('categoryId: $categoryId, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('currency: $currency, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('periodIndex: $periodIndex, ')
          ..write('status: $status, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('reminderOffsets: $reminderOffsets, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('manageUrl: $manageUrl, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('cancelledOn: $cancelledOn, ')
          ..write('pausedFrom: $pausedFrom, ')
          ..write('worthIt: $worthIt, ')
          ..write('detectionSource: $detectionSource, ')
          ..write('detectedAt: $detectedAt, ')
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    source,
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
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
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
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
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

  /// v2: Detection source when the app confirmed it itself (ADR 0003); NULL = by the user.
  final String? source;
  const ConfirmedPeriodRow({
    required this.id,
    required this.subscriptionId,
    required this.dueDate,
    required this.outcome,
    required this.amountMinor,
    required this.currency,
    required this.confirmedAt,
    this.source,
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
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
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
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
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
      source: serializer.fromJson<String?>(json['source']),
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
      'source': serializer.toJson<String?>(source),
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
    Value<String?> source = const Value.absent(),
  }) => ConfirmedPeriodRow(
    id: id ?? this.id,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    dueDate: dueDate ?? this.dueDate,
    outcome: outcome ?? this.outcome,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    confirmedAt: confirmedAt ?? this.confirmedAt,
    source: source.present ? source.value : this.source,
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
      source: data.source.present ? data.source.value : this.source,
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
          ..write('confirmedAt: $confirmedAt, ')
          ..write('source: $source')
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
    source,
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
          other.confirmedAt == this.confirmedAt &&
          other.source == this.source);
}

class ConfirmedPeriodsCompanion extends UpdateCompanion<ConfirmedPeriodRow> {
  final Value<String> id;
  final Value<String> subscriptionId;
  final Value<String> dueDate;
  final Value<String> outcome;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<DateTime> confirmedAt;
  final Value<String?> source;
  final Value<int> rowid;
  const ConfirmedPeriodsCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.outcome = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.source = const Value.absent(),
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
    this.source = const Value.absent(),
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
    Expression<String>? source,
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
      if (source != null) 'source': source,
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
    Value<String?>? source,
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
      source: source ?? this.source,
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
    if (source.present) {
      map['source'] = Variable<String>(source.value);
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
          ..write('source: $source, ')
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

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _builtInKeyMeta = const VerificationMeta(
    'builtInKey',
  );
  @override
  late final GeneratedColumn<String> builtInKey = GeneratedColumn<String>(
    'built_in_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    colorValue,
    icon,
    sortOrder,
    builtInKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
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
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('built_in_key')) {
      context.handle(
        _builtInKeyMeta,
        builtInKey.isAcceptableOrUnknown(
          data['built_in_key']!,
          _builtInKeyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      builtInKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}built_in_key'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String? name;
  final int colorValue;
  final String? icon;
  final int sortOrder;
  final String? builtInKey;
  const CategoryRow({
    required this.id,
    this.name,
    required this.colorValue,
    this.icon,
    required this.sortOrder,
    this.builtInKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || builtInKey != null) {
      map['built_in_key'] = Variable<String>(builtInKey);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      colorValue: Value(colorValue),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      builtInKey: builtInKey == null && nullToAbsent
          ? const Value.absent()
          : Value(builtInKey),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      builtInKey: serializer.fromJson<String?>(json['builtInKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'colorValue': serializer.toJson<int>(colorValue),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'builtInKey': serializer.toJson<String?>(builtInKey),
    };
  }

  CategoryRow copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    int? colorValue,
    Value<String?> icon = const Value.absent(),
    int? sortOrder,
    Value<String?> builtInKey = const Value.absent(),
  }) => CategoryRow(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    colorValue: colorValue ?? this.colorValue,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    builtInKey: builtInKey.present ? builtInKey.value : this.builtInKey,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      builtInKey: data.builtInKey.present
          ? data.builtInKey.value
          : this.builtInKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('builtInKey: $builtInKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, colorValue, icon, sortOrder, builtInKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.builtInKey == this.builtInKey);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String?> name;
  final Value<int> colorValue;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<String?> builtInKey;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.builtInKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required int colorValue,
    this.icon = const Value.absent(),
    required int sortOrder,
    this.builtInKey = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       colorValue = Value(colorValue),
       sortOrder = Value(sortOrder);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<String>? builtInKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (builtInKey != null) 'built_in_key': builtInKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<int>? colorValue,
    Value<String?>? icon,
    Value<int>? sortOrder,
    Value<String?>? builtInKey,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      builtInKey: builtInKey ?? this.builtInKey,
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
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (builtInKey.present) {
      map['built_in_key'] = Variable<String>(builtInKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('builtInKey: $builtInKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, LabelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorValue, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabelRow> instance, {
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
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabelRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(attachedDatabase, alias);
  }
}

class LabelRow extends DataClass implements Insertable<LabelRow> {
  final String id;
  final String name;
  final int? colorValue;
  final int sortOrder;
  const LabelRow({
    required this.id,
    required this.name,
    this.colorValue,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      id: Value(id),
      name: Value(name),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      sortOrder: Value(sortOrder),
    );
  }

  factory LabelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabelRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorValue': serializer.toJson<int?>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  LabelRow copyWith({
    String? id,
    String? name,
    Value<int?> colorValue = const Value.absent(),
    int? sortOrder,
  }) => LabelRow(
    id: id ?? this.id,
    name: name ?? this.name,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  LabelRow copyWithCompanion(LabelsCompanion data) {
    return LabelRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabelRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorValue, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabelRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder);
}

class LabelsCompanion extends UpdateCompanion<LabelRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int?> colorValue;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const LabelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabelsCompanion.insert({
    required String id,
    required String name,
    this.colorValue = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<LabelRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabelsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int?>? colorValue,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return LabelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionLabelsTable extends SubscriptionLabels
    with TableInfo<$SubscriptionLabelsTable, SubscriptionLabelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionLabelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelIdMeta = const VerificationMeta(
    'labelId',
  );
  @override
  late final GeneratedColumn<String> labelId = GeneratedColumn<String>(
    'label_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES labels (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [subscriptionId, labelId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionLabelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('label_id')) {
      context.handle(
        _labelIdMeta,
        labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_labelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subscriptionId, labelId};
  @override
  SubscriptionLabelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionLabelRow(
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      labelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_id'],
      )!,
    );
  }

  @override
  $SubscriptionLabelsTable createAlias(String alias) {
    return $SubscriptionLabelsTable(attachedDatabase, alias);
  }
}

class SubscriptionLabelRow extends DataClass
    implements Insertable<SubscriptionLabelRow> {
  final String subscriptionId;
  final String labelId;
  const SubscriptionLabelRow({
    required this.subscriptionId,
    required this.labelId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['label_id'] = Variable<String>(labelId);
    return map;
  }

  SubscriptionLabelsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionLabelsCompanion(
      subscriptionId: Value(subscriptionId),
      labelId: Value(labelId),
    );
  }

  factory SubscriptionLabelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionLabelRow(
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      labelId: serializer.fromJson<String>(json['labelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'labelId': serializer.toJson<String>(labelId),
    };
  }

  SubscriptionLabelRow copyWith({String? subscriptionId, String? labelId}) =>
      SubscriptionLabelRow(
        subscriptionId: subscriptionId ?? this.subscriptionId,
        labelId: labelId ?? this.labelId,
      );
  SubscriptionLabelRow copyWithCompanion(SubscriptionLabelsCompanion data) {
    return SubscriptionLabelRow(
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      labelId: data.labelId.present ? data.labelId.value : this.labelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionLabelRow(')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('labelId: $labelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subscriptionId, labelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionLabelRow &&
          other.subscriptionId == this.subscriptionId &&
          other.labelId == this.labelId);
}

class SubscriptionLabelsCompanion
    extends UpdateCompanion<SubscriptionLabelRow> {
  final Value<String> subscriptionId;
  final Value<String> labelId;
  final Value<int> rowid;
  const SubscriptionLabelsCompanion({
    this.subscriptionId = const Value.absent(),
    this.labelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionLabelsCompanion.insert({
    required String subscriptionId,
    required String labelId,
    this.rowid = const Value.absent(),
  }) : subscriptionId = Value(subscriptionId),
       labelId = Value(labelId);
  static Insertable<SubscriptionLabelRow> custom({
    Expression<String>? subscriptionId,
    Expression<String>? labelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (labelId != null) 'label_id': labelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionLabelsCompanion copyWith({
    Value<String>? subscriptionId,
    Value<String>? labelId,
    Value<int>? rowid,
  }) {
    return SubscriptionLabelsCompanion(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      labelId: labelId ?? this.labelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<String>(labelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionLabelsCompanion(')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('labelId: $labelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentMethodRow> instance, {
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
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethodRow extends DataClass
    implements Insertable<PaymentMethodRow> {
  final String id;
  final String name;
  final int sortOrder;
  const PaymentMethodRow({
    required this.id,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory PaymentMethodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethodRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PaymentMethodRow copyWith({String? id, String? name, int? sortOrder}) =>
      PaymentMethodRow(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  PaymentMethodRow copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethodRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    required String id,
    required String name,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<PaymentMethodRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [id, categoryId, amountMinor, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final String id;
  final String? categoryId;
  final int amountMinor;
  final String currency;
  const BudgetRow({
    required this.id,
    this.categoryId,
    required this.amountMinor,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String?>(categoryId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
    };
  }

  BudgetRow copyWith({
    String? id,
    Value<String?> categoryId = const Value.absent(),
    int? amountMinor,
    String? currency,
  }) => BudgetRow(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryId, amountMinor, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<String> id;
  final Value<String?> categoryId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    this.categoryId = const Value.absent(),
    required int amountMinor,
    required String currency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountMinor = Value(amountMinor),
       currency = Value(currency);
  static Insertable<BudgetRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String?>? categoryId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DetectedChargesTable extends DetectedCharges
    with TableInfo<$DetectedChargesTable, DetectedChargeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetectedChargesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
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
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleUnitMeta = const VerificationMeta(
    'cycleUnit',
  );
  @override
  late final GeneratedColumn<String> cycleUnit = GeneratedColumn<String>(
    'cycle_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRenewalMeta = const VerificationMeta(
    'isRenewal',
  );
  @override
  late final GeneratedColumn<bool> isRenewal = GeneratedColumn<bool>(
    'is_renewal',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_renewal" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    amountMinor,
    currency,
    date,
    source,
    cycleEvery,
    cycleUnit,
    isRenewal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detected_charges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DetectedChargeRow> instance, {
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
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('cycle_every')) {
      context.handle(
        _cycleEveryMeta,
        cycleEvery.isAcceptableOrUnknown(data['cycle_every']!, _cycleEveryMeta),
      );
    }
    if (data.containsKey('cycle_unit')) {
      context.handle(
        _cycleUnitMeta,
        cycleUnit.isAcceptableOrUnknown(data['cycle_unit']!, _cycleUnitMeta),
      );
    }
    if (data.containsKey('is_renewal')) {
      context.handle(
        _isRenewalMeta,
        isRenewal.isAcceptableOrUnknown(data['is_renewal']!, _isRenewalMeta),
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
  DetectedChargeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetectedChargeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      cycleEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_every'],
      ),
      cycleUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_unit'],
      ),
      isRenewal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_renewal'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DetectedChargesTable createAlias(String alias) {
    return $DetectedChargesTable(attachedDatabase, alias);
  }
}

class DetectedChargeRow extends DataClass
    implements Insertable<DetectedChargeRow> {
  final String id;
  final String name;
  final int amountMinor;
  final String currency;
  final String date;
  final String source;
  final int? cycleEvery;
  final String? cycleUnit;
  final bool isRenewal;
  final DateTime createdAt;
  const DetectedChargeRow({
    required this.id,
    required this.name,
    required this.amountMinor,
    required this.currency,
    required this.date,
    required this.source,
    this.cycleEvery,
    this.cycleUnit,
    required this.isRenewal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['date'] = Variable<String>(date);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || cycleEvery != null) {
      map['cycle_every'] = Variable<int>(cycleEvery);
    }
    if (!nullToAbsent || cycleUnit != null) {
      map['cycle_unit'] = Variable<String>(cycleUnit);
    }
    map['is_renewal'] = Variable<bool>(isRenewal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DetectedChargesCompanion toCompanion(bool nullToAbsent) {
    return DetectedChargesCompanion(
      id: Value(id),
      name: Value(name),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      date: Value(date),
      source: Value(source),
      cycleEvery: cycleEvery == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleEvery),
      cycleUnit: cycleUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleUnit),
      isRenewal: Value(isRenewal),
      createdAt: Value(createdAt),
    );
  }

  factory DetectedChargeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetectedChargeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      date: serializer.fromJson<String>(json['date']),
      source: serializer.fromJson<String>(json['source']),
      cycleEvery: serializer.fromJson<int?>(json['cycleEvery']),
      cycleUnit: serializer.fromJson<String?>(json['cycleUnit']),
      isRenewal: serializer.fromJson<bool>(json['isRenewal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'date': serializer.toJson<String>(date),
      'source': serializer.toJson<String>(source),
      'cycleEvery': serializer.toJson<int?>(cycleEvery),
      'cycleUnit': serializer.toJson<String?>(cycleUnit),
      'isRenewal': serializer.toJson<bool>(isRenewal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DetectedChargeRow copyWith({
    String? id,
    String? name,
    int? amountMinor,
    String? currency,
    String? date,
    String? source,
    Value<int?> cycleEvery = const Value.absent(),
    Value<String?> cycleUnit = const Value.absent(),
    bool? isRenewal,
    DateTime? createdAt,
  }) => DetectedChargeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    date: date ?? this.date,
    source: source ?? this.source,
    cycleEvery: cycleEvery.present ? cycleEvery.value : this.cycleEvery,
    cycleUnit: cycleUnit.present ? cycleUnit.value : this.cycleUnit,
    isRenewal: isRenewal ?? this.isRenewal,
    createdAt: createdAt ?? this.createdAt,
  );
  DetectedChargeRow copyWithCompanion(DetectedChargesCompanion data) {
    return DetectedChargeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      date: data.date.present ? data.date.value : this.date,
      source: data.source.present ? data.source.value : this.source,
      cycleEvery: data.cycleEvery.present
          ? data.cycleEvery.value
          : this.cycleEvery,
      cycleUnit: data.cycleUnit.present ? data.cycleUnit.value : this.cycleUnit,
      isRenewal: data.isRenewal.present ? data.isRenewal.value : this.isRenewal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetectedChargeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('source: $source, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('isRenewal: $isRenewal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    amountMinor,
    currency,
    date,
    source,
    cycleEvery,
    cycleUnit,
    isRenewal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetectedChargeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.date == this.date &&
          other.source == this.source &&
          other.cycleEvery == this.cycleEvery &&
          other.cycleUnit == this.cycleUnit &&
          other.isRenewal == this.isRenewal &&
          other.createdAt == this.createdAt);
}

class DetectedChargesCompanion extends UpdateCompanion<DetectedChargeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> date;
  final Value<String> source;
  final Value<int?> cycleEvery;
  final Value<String?> cycleUnit;
  final Value<bool> isRenewal;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DetectedChargesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.source = const Value.absent(),
    this.cycleEvery = const Value.absent(),
    this.cycleUnit = const Value.absent(),
    this.isRenewal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DetectedChargesCompanion.insert({
    required String id,
    required String name,
    required int amountMinor,
    required String currency,
    required String date,
    required String source,
    this.cycleEvery = const Value.absent(),
    this.cycleUnit = const Value.absent(),
    this.isRenewal = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       date = Value(date),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<DetectedChargeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? date,
    Expression<String>? source,
    Expression<int>? cycleEvery,
    Expression<String>? cycleUnit,
    Expression<bool>? isRenewal,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (date != null) 'date': date,
      if (source != null) 'source': source,
      if (cycleEvery != null) 'cycle_every': cycleEvery,
      if (cycleUnit != null) 'cycle_unit': cycleUnit,
      if (isRenewal != null) 'is_renewal': isRenewal,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DetectedChargesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? date,
    Value<String>? source,
    Value<int?>? cycleEvery,
    Value<String?>? cycleUnit,
    Value<bool>? isRenewal,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DetectedChargesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      source: source ?? this.source,
      cycleEvery: cycleEvery ?? this.cycleEvery,
      cycleUnit: cycleUnit ?? this.cycleUnit,
      isRenewal: isRenewal ?? this.isRenewal,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (cycleEvery.present) {
      map['cycle_every'] = Variable<int>(cycleEvery.value);
    }
    if (cycleUnit.present) {
      map['cycle_unit'] = Variable<String>(cycleUnit.value);
    }
    if (isRenewal.present) {
      map['is_renewal'] = Variable<bool>(isRenewal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetectedChargesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('source: $source, ')
          ..write('cycleEvery: $cycleEvery, ')
          ..write('cycleUnit: $cycleUnit, ')
          ..write('isRenewal: $isRenewal, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DismissedDetectionsTable extends DismissedDetections
    with TableInfo<$DismissedDetectionsTable, DismissedDetectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DismissedDetectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  @override
  List<GeneratedColumn> get $columns => [key, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dismissed_detections';
  @override
  VerificationContext validateIntegrity(
    Insertable<DismissedDetectionRow> instance, {
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DismissedDetectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DismissedDetectionRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DismissedDetectionsTable createAlias(String alias) {
    return $DismissedDetectionsTable(attachedDatabase, alias);
  }
}

class DismissedDetectionRow extends DataClass
    implements Insertable<DismissedDetectionRow> {
  final String key;
  final DateTime createdAt;
  const DismissedDetectionRow({required this.key, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DismissedDetectionsCompanion toCompanion(bool nullToAbsent) {
    return DismissedDetectionsCompanion(
      key: Value(key),
      createdAt: Value(createdAt),
    );
  }

  factory DismissedDetectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DismissedDetectionRow(
      key: serializer.fromJson<String>(json['key']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DismissedDetectionRow copyWith({String? key, DateTime? createdAt}) =>
      DismissedDetectionRow(
        key: key ?? this.key,
        createdAt: createdAt ?? this.createdAt,
      );
  DismissedDetectionRow copyWithCompanion(DismissedDetectionsCompanion data) {
    return DismissedDetectionRow(
      key: data.key.present ? data.key.value : this.key,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DismissedDetectionRow(')
          ..write('key: $key, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DismissedDetectionRow &&
          other.key == this.key &&
          other.createdAt == this.createdAt);
}

class DismissedDetectionsCompanion
    extends UpdateCompanion<DismissedDetectionRow> {
  final Value<String> key;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DismissedDetectionsCompanion({
    this.key = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DismissedDetectionsCompanion.insert({
    required String key,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       createdAt = Value(createdAt);
  static Insertable<DismissedDetectionRow> custom({
    Expression<String>? key,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DismissedDetectionsCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DismissedDetectionsCompanion(
      key: key ?? this.key,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DismissedDetectionsCompanion(')
          ..write('key: $key, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceChangesTable extends PriceChanges
    with TableInfo<$PriceChangesTable, PriceChangeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceChangesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _oldPriceMinorMeta = const VerificationMeta(
    'oldPriceMinor',
  );
  @override
  late final GeneratedColumn<int> oldPriceMinor = GeneratedColumn<int>(
    'old_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newPriceMinorMeta = const VerificationMeta(
    'newPriceMinor',
  );
  @override
  late final GeneratedColumn<int> newPriceMinor = GeneratedColumn<int>(
    'new_price_minor',
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
  static const VerificationMeta _oldCurrencyMeta = const VerificationMeta(
    'oldCurrency',
  );
  @override
  late final GeneratedColumn<String> oldCurrency = GeneratedColumn<String>(
    'old_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<String> effectiveFrom = GeneratedColumn<String>(
    'effective_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subscriptionId,
    oldPriceMinor,
    newPriceMinor,
    currency,
    oldCurrency,
    effectiveFrom,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceChangeRow> instance, {
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
    if (data.containsKey('old_price_minor')) {
      context.handle(
        _oldPriceMinorMeta,
        oldPriceMinor.isAcceptableOrUnknown(
          data['old_price_minor']!,
          _oldPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_oldPriceMinorMeta);
    }
    if (data.containsKey('new_price_minor')) {
      context.handle(
        _newPriceMinorMeta,
        newPriceMinor.isAcceptableOrUnknown(
          data['new_price_minor']!,
          _newPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newPriceMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('old_currency')) {
      context.handle(
        _oldCurrencyMeta,
        oldCurrency.isAcceptableOrUnknown(
          data['old_currency']!,
          _oldCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
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
  PriceChangeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceChangeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      oldPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}old_price_minor'],
      )!,
      newPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_price_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      oldCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_currency'],
      ),
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_from'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PriceChangesTable createAlias(String alias) {
    return $PriceChangesTable(attachedDatabase, alias);
  }
}

class PriceChangeRow extends DataClass implements Insertable<PriceChangeRow> {
  final String id;
  final String subscriptionId;
  final int oldPriceMinor;
  final int newPriceMinor;

  /// Currency of the new price.
  final String currency;

  /// Currency of the old price when it changed too; NULL = same as [currency].
  final String? oldCurrency;
  final String effectiveFrom;

  /// `manual` · `catalog` · `backfill` (PriceChangeSource).
  final String source;
  final DateTime createdAt;
  const PriceChangeRow({
    required this.id,
    required this.subscriptionId,
    required this.oldPriceMinor,
    required this.newPriceMinor,
    required this.currency,
    this.oldCurrency,
    required this.effectiveFrom,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['old_price_minor'] = Variable<int>(oldPriceMinor);
    map['new_price_minor'] = Variable<int>(newPriceMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || oldCurrency != null) {
      map['old_currency'] = Variable<String>(oldCurrency);
    }
    map['effective_from'] = Variable<String>(effectiveFrom);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PriceChangesCompanion toCompanion(bool nullToAbsent) {
    return PriceChangesCompanion(
      id: Value(id),
      subscriptionId: Value(subscriptionId),
      oldPriceMinor: Value(oldPriceMinor),
      newPriceMinor: Value(newPriceMinor),
      currency: Value(currency),
      oldCurrency: oldCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(oldCurrency),
      effectiveFrom: Value(effectiveFrom),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory PriceChangeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceChangeRow(
      id: serializer.fromJson<String>(json['id']),
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      oldPriceMinor: serializer.fromJson<int>(json['oldPriceMinor']),
      newPriceMinor: serializer.fromJson<int>(json['newPriceMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      oldCurrency: serializer.fromJson<String?>(json['oldCurrency']),
      effectiveFrom: serializer.fromJson<String>(json['effectiveFrom']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'oldPriceMinor': serializer.toJson<int>(oldPriceMinor),
      'newPriceMinor': serializer.toJson<int>(newPriceMinor),
      'currency': serializer.toJson<String>(currency),
      'oldCurrency': serializer.toJson<String?>(oldCurrency),
      'effectiveFrom': serializer.toJson<String>(effectiveFrom),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PriceChangeRow copyWith({
    String? id,
    String? subscriptionId,
    int? oldPriceMinor,
    int? newPriceMinor,
    String? currency,
    Value<String?> oldCurrency = const Value.absent(),
    String? effectiveFrom,
    String? source,
    DateTime? createdAt,
  }) => PriceChangeRow(
    id: id ?? this.id,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    oldPriceMinor: oldPriceMinor ?? this.oldPriceMinor,
    newPriceMinor: newPriceMinor ?? this.newPriceMinor,
    currency: currency ?? this.currency,
    oldCurrency: oldCurrency.present ? oldCurrency.value : this.oldCurrency,
    effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  PriceChangeRow copyWithCompanion(PriceChangesCompanion data) {
    return PriceChangeRow(
      id: data.id.present ? data.id.value : this.id,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      oldPriceMinor: data.oldPriceMinor.present
          ? data.oldPriceMinor.value
          : this.oldPriceMinor,
      newPriceMinor: data.newPriceMinor.present
          ? data.newPriceMinor.value
          : this.newPriceMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      oldCurrency: data.oldCurrency.present
          ? data.oldCurrency.value
          : this.oldCurrency,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceChangeRow(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('oldPriceMinor: $oldPriceMinor, ')
          ..write('newPriceMinor: $newPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('oldCurrency: $oldCurrency, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subscriptionId,
    oldPriceMinor,
    newPriceMinor,
    currency,
    oldCurrency,
    effectiveFrom,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceChangeRow &&
          other.id == this.id &&
          other.subscriptionId == this.subscriptionId &&
          other.oldPriceMinor == this.oldPriceMinor &&
          other.newPriceMinor == this.newPriceMinor &&
          other.currency == this.currency &&
          other.oldCurrency == this.oldCurrency &&
          other.effectiveFrom == this.effectiveFrom &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class PriceChangesCompanion extends UpdateCompanion<PriceChangeRow> {
  final Value<String> id;
  final Value<String> subscriptionId;
  final Value<int> oldPriceMinor;
  final Value<int> newPriceMinor;
  final Value<String> currency;
  final Value<String?> oldCurrency;
  final Value<String> effectiveFrom;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PriceChangesCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.oldPriceMinor = const Value.absent(),
    this.newPriceMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.oldCurrency = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceChangesCompanion.insert({
    required String id,
    required String subscriptionId,
    required int oldPriceMinor,
    required int newPriceMinor,
    required String currency,
    this.oldCurrency = const Value.absent(),
    required String effectiveFrom,
    required String source,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subscriptionId = Value(subscriptionId),
       oldPriceMinor = Value(oldPriceMinor),
       newPriceMinor = Value(newPriceMinor),
       currency = Value(currency),
       effectiveFrom = Value(effectiveFrom),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<PriceChangeRow> custom({
    Expression<String>? id,
    Expression<String>? subscriptionId,
    Expression<int>? oldPriceMinor,
    Expression<int>? newPriceMinor,
    Expression<String>? currency,
    Expression<String>? oldCurrency,
    Expression<String>? effectiveFrom,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (oldPriceMinor != null) 'old_price_minor': oldPriceMinor,
      if (newPriceMinor != null) 'new_price_minor': newPriceMinor,
      if (currency != null) 'currency': currency,
      if (oldCurrency != null) 'old_currency': oldCurrency,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceChangesCompanion copyWith({
    Value<String>? id,
    Value<String>? subscriptionId,
    Value<int>? oldPriceMinor,
    Value<int>? newPriceMinor,
    Value<String>? currency,
    Value<String?>? oldCurrency,
    Value<String>? effectiveFrom,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PriceChangesCompanion(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      oldPriceMinor: oldPriceMinor ?? this.oldPriceMinor,
      newPriceMinor: newPriceMinor ?? this.newPriceMinor,
      currency: currency ?? this.currency,
      oldCurrency: oldCurrency ?? this.oldCurrency,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      source: source ?? this.source,
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
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (oldPriceMinor.present) {
      map['old_price_minor'] = Variable<int>(oldPriceMinor.value);
    }
    if (newPriceMinor.present) {
      map['new_price_minor'] = Variable<int>(newPriceMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (oldCurrency.present) {
      map['old_currency'] = Variable<String>(oldCurrency.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<String>(effectiveFrom.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceChangesCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('oldPriceMinor: $oldPriceMinor, ')
          ..write('newPriceMinor: $newPriceMinor, ')
          ..write('currency: $currency, ')
          ..write('oldCurrency: $oldCurrency, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
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
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $SubscriptionLabelsTable subscriptionLabels =
      $SubscriptionLabelsTable(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $DetectedChargesTable detectedCharges = $DetectedChargesTable(
    this,
  );
  late final $DismissedDetectionsTable dismissedDetections =
      $DismissedDetectionsTable(this);
  late final $PriceChangesTable priceChanges = $PriceChangesTable(this);
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
    categories,
    labels,
    subscriptionLabels,
    paymentMethods,
    budgets,
    detectedCharges,
    dismissedDetections,
    priceChanges,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subscription_labels', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'labels',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subscription_labels', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subscriptions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('price_changes', kind: UpdateKind.delete)],
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
      Value<String?> customLogoFile,
      Value<String> categoryId,
      required int priceMinor,
      required String currency,
      required int cycleEvery,
      required String cycleUnit,
      required String anchorDate,
      Value<int> periodIndex,
      required String status,
      Value<String?> trialEndDate,
      Value<int> sharedWith,
      Value<String?> reminderOffsets,
      Value<String?> paymentMethodId,
      Value<String?> manageUrl,
      Value<String?> notes,
      required String startDate,
      Value<String?> cancelledOn,
      Value<String?> pausedFrom,
      Value<String?> worthIt,
      Value<String?> detectionSource,
      Value<DateTime?> detectedAt,
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
      Value<String?> customLogoFile,
      Value<String> categoryId,
      Value<int> priceMinor,
      Value<String> currency,
      Value<int> cycleEvery,
      Value<String> cycleUnit,
      Value<String> anchorDate,
      Value<int> periodIndex,
      Value<String> status,
      Value<String?> trialEndDate,
      Value<int> sharedWith,
      Value<String?> reminderOffsets,
      Value<String?> paymentMethodId,
      Value<String?> manageUrl,
      Value<String?> notes,
      Value<String> startDate,
      Value<String?> cancelledOn,
      Value<String?> pausedFrom,
      Value<String?> worthIt,
      Value<String?> detectionSource,
      Value<DateTime?> detectedAt,
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

  static MultiTypedResultKey<
    $SubscriptionLabelsTable,
    List<SubscriptionLabelRow>
  >
  _subscriptionLabelsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subscriptionLabels,
        aliasName: 'subscriptions__id__subscription_labels__subscription_id',
      );

  $$SubscriptionLabelsTableProcessedTableManager get subscriptionLabelsRefs {
    final manager = $$SubscriptionLabelsTableTableManager(
      $_db,
      $_db.subscriptionLabels,
    ).filter((f) => f.subscriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subscriptionLabelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PriceChangesTable, List<PriceChangeRow>>
  _priceChangesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.priceChanges,
    aliasName: 'subscriptions__id__price_changes__subscription_id',
  );

  $$PriceChangesTableProcessedTableManager get priceChangesRefs {
    final manager = $$PriceChangesTableTableManager(
      $_db,
      $_db.priceChanges,
    ).filter((f) => f.subscriptionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceChangesRefsTable($_db));
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

  ColumnFilters<String> get customLogoFile => $composableBuilder(
    column: $table.customLogoFile,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
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

  ColumnFilters<String> get reminderOffsets => $composableBuilder(
    column: $table.reminderOffsets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethodId => $composableBuilder(
    column: $table.paymentMethodId,
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

  ColumnFilters<String> get pausedFrom => $composableBuilder(
    column: $table.pausedFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worthIt => $composableBuilder(
    column: $table.worthIt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detectionSource => $composableBuilder(
    column: $table.detectionSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
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

  Expression<bool> subscriptionLabelsRefs(
    Expression<bool> Function($$SubscriptionLabelsTableFilterComposer f) f,
  ) {
    final $$SubscriptionLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptionLabels,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionLabelsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptionLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> priceChangesRefs(
    Expression<bool> Function($$PriceChangesTableFilterComposer f) f,
  ) {
    final $$PriceChangesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceChanges,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceChangesTableFilterComposer(
            $db: $db,
            $table: $db.priceChanges,
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

  ColumnOrderings<String> get customLogoFile => $composableBuilder(
    column: $table.customLogoFile,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
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

  ColumnOrderings<String> get reminderOffsets => $composableBuilder(
    column: $table.reminderOffsets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethodId => $composableBuilder(
    column: $table.paymentMethodId,
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

  ColumnOrderings<String> get pausedFrom => $composableBuilder(
    column: $table.pausedFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worthIt => $composableBuilder(
    column: $table.worthIt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detectionSource => $composableBuilder(
    column: $table.detectionSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
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

  GeneratedColumn<String> get customLogoFile => $composableBuilder(
    column: $table.customLogoFile,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get reminderOffsets => $composableBuilder(
    column: $table.reminderOffsets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethodId => $composableBuilder(
    column: $table.paymentMethodId,
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

  GeneratedColumn<String> get pausedFrom => $composableBuilder(
    column: $table.pausedFrom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get worthIt =>
      $composableBuilder(column: $table.worthIt, builder: (column) => column);

  GeneratedColumn<String> get detectionSource => $composableBuilder(
    column: $table.detectionSource,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
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

  Expression<T> subscriptionLabelsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionLabelsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionLabelsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.subscriptionLabels,
          getReferencedColumn: (t) => t.subscriptionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SubscriptionLabelsTableAnnotationComposer(
                $db: $db,
                $table: $db.subscriptionLabels,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> priceChangesRefs<T extends Object>(
    Expression<T> Function($$PriceChangesTableAnnotationComposer a) f,
  ) {
    final $$PriceChangesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.priceChanges,
      getReferencedColumn: (t) => t.subscriptionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PriceChangesTableAnnotationComposer(
            $db: $db,
            $table: $db.priceChanges,
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
          PrefetchHooks Function({
            bool confirmedPeriodsRefs,
            bool subscriptionLabelsRefs,
            bool priceChangesRefs,
          })
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
                Value<String?> customLogoFile = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> cycleEvery = const Value.absent(),
                Value<String> cycleUnit = const Value.absent(),
                Value<String> anchorDate = const Value.absent(),
                Value<int> periodIndex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> trialEndDate = const Value.absent(),
                Value<int> sharedWith = const Value.absent(),
                Value<String?> reminderOffsets = const Value.absent(),
                Value<String?> paymentMethodId = const Value.absent(),
                Value<String?> manageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> cancelledOn = const Value.absent(),
                Value<String?> pausedFrom = const Value.absent(),
                Value<String?> worthIt = const Value.absent(),
                Value<String?> detectionSource = const Value.absent(),
                Value<DateTime?> detectedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                name: name,
                serviceId: serviceId,
                colorValue: colorValue,
                iconText: iconText,
                customLogoFile: customLogoFile,
                categoryId: categoryId,
                priceMinor: priceMinor,
                currency: currency,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                anchorDate: anchorDate,
                periodIndex: periodIndex,
                status: status,
                trialEndDate: trialEndDate,
                sharedWith: sharedWith,
                reminderOffsets: reminderOffsets,
                paymentMethodId: paymentMethodId,
                manageUrl: manageUrl,
                notes: notes,
                startDate: startDate,
                cancelledOn: cancelledOn,
                pausedFrom: pausedFrom,
                worthIt: worthIt,
                detectionSource: detectionSource,
                detectedAt: detectedAt,
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
                Value<String?> customLogoFile = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                required int priceMinor,
                required String currency,
                required int cycleEvery,
                required String cycleUnit,
                required String anchorDate,
                Value<int> periodIndex = const Value.absent(),
                required String status,
                Value<String?> trialEndDate = const Value.absent(),
                Value<int> sharedWith = const Value.absent(),
                Value<String?> reminderOffsets = const Value.absent(),
                Value<String?> paymentMethodId = const Value.absent(),
                Value<String?> manageUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String startDate,
                Value<String?> cancelledOn = const Value.absent(),
                Value<String?> pausedFrom = const Value.absent(),
                Value<String?> worthIt = const Value.absent(),
                Value<String?> detectionSource = const Value.absent(),
                Value<DateTime?> detectedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                name: name,
                serviceId: serviceId,
                colorValue: colorValue,
                iconText: iconText,
                customLogoFile: customLogoFile,
                categoryId: categoryId,
                priceMinor: priceMinor,
                currency: currency,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                anchorDate: anchorDate,
                periodIndex: periodIndex,
                status: status,
                trialEndDate: trialEndDate,
                sharedWith: sharedWith,
                reminderOffsets: reminderOffsets,
                paymentMethodId: paymentMethodId,
                manageUrl: manageUrl,
                notes: notes,
                startDate: startDate,
                cancelledOn: cancelledOn,
                pausedFrom: pausedFrom,
                worthIt: worthIt,
                detectionSource: detectionSource,
                detectedAt: detectedAt,
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
          prefetchHooksCallback:
              ({
                confirmedPeriodsRefs = false,
                subscriptionLabelsRefs = false,
                priceChangesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (confirmedPeriodsRefs) db.confirmedPeriods,
                    if (subscriptionLabelsRefs) db.subscriptionLabels,
                    if (priceChangesRefs) db.priceChanges,
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
                      if (subscriptionLabelsRefs)
                        await $_getPrefetchedDataByColumns<
                          SubscriptionRow,
                          $SubscriptionsTable,
                          SubscriptionLabelRow,
                          $SubscriptionLabelsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._subscriptionLabelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).subscriptionLabelsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'subscription_id',
                          typedResults: items,
                        ),
                      if (priceChangesRefs)
                        await $_getPrefetchedDataByColumns<
                          SubscriptionRow,
                          $SubscriptionsTable,
                          PriceChangeRow,
                          $PriceChangesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SubscriptionsTableReferences
                              ._priceChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubscriptionsTableReferences(
                                db,
                                table,
                                p0,
                              ).priceChangesRefs,
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
      PrefetchHooks Function({
        bool confirmedPeriodsRefs,
        bool subscriptionLabelsRefs,
        bool priceChangesRefs,
      })
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
      Value<String?> source,
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
      Value<String?> source,
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

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

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
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfirmedPeriodsCompanion(
                id: id,
                subscriptionId: subscriptionId,
                dueDate: dueDate,
                outcome: outcome,
                amountMinor: amountMinor,
                currency: currency,
                confirmedAt: confirmedAt,
                source: source,
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
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConfirmedPeriodsCompanion.insert(
                id: id,
                subscriptionId: subscriptionId,
                dueDate: dueDate,
                outcome: outcome,
                amountMinor: amountMinor,
                currency: currency,
                confirmedAt: confirmedAt,
                source: source,
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
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  Value<String?> name,
  required int colorValue,
  Value<String?> icon,
  required int sortOrder,
  Value<String?> builtInKey,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String?> name,
  Value<int> colorValue,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<String?> builtInKey,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
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

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get builtInKey => $composableBuilder(
    column: $table.builtInKey,
    builder: (column) => column,
  );
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoryRow,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
          ),
          CategoryRow,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> builtInKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                icon: icon,
                sortOrder: sortOrder,
                builtInKey: builtInKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                required int colorValue,
                Value<String?> icon = const Value.absent(),
                required int sortOrder,
                Value<String?> builtInKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                icon: icon,
                sortOrder: sortOrder,
                builtInKey: builtInKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>(
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

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoryRow,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow>,
      ),
      CategoryRow,
      PrefetchHooks Function()
    >;
typedef $$LabelsTableCreateCompanionBuilder = LabelsCompanion Function({
  required String id,
  required String name,
  Value<int?> colorValue,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$LabelsTableUpdateCompanionBuilder = LabelsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int?> colorValue,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$LabelsTableReferences
    extends BaseReferences<_$AppDatabase, $LabelsTable, LabelRow> {
  $$LabelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $SubscriptionLabelsTable,
    List<SubscriptionLabelRow>
  >
  _subscriptionLabelsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.subscriptionLabels,
        aliasName: 'labels__id__subscription_labels__label_id',
      );

  $$SubscriptionLabelsTableProcessedTableManager get subscriptionLabelsRefs {
    final manager = $$SubscriptionLabelsTableTableManager(
      $_db,
      $_db.subscriptionLabels,
    ).filter((f) => f.labelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subscriptionLabelsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LabelsTableFilterComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableFilterComposer({
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

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subscriptionLabelsRefs(
    Expression<bool> Function($$SubscriptionLabelsTableFilterComposer f) f,
  ) {
    final $$SubscriptionLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptionLabels,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionLabelsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptionLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableOrderingComposer({
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

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableAnnotationComposer({
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

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> subscriptionLabelsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionLabelsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionLabelsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.subscriptionLabels,
          getReferencedColumn: (t) => t.labelId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SubscriptionLabelsTableAnnotationComposer(
                $db: $db,
                $table: $db.subscriptionLabels,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabelsTable,
          LabelRow,
          $$LabelsTableFilterComposer,
          $$LabelsTableOrderingComposer,
          $$LabelsTableAnnotationComposer,
          $$LabelsTableCreateCompanionBuilder,
          $$LabelsTableUpdateCompanionBuilder,
          (LabelRow, $$LabelsTableReferences),
          LabelRow,
          PrefetchHooks Function({bool subscriptionLabelsRefs})
        > {
  $$LabelsTableTableManager(_$AppDatabase db, $LabelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabelsCompanion(
                id: id,
                name: name,
                colorValue: colorValue,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int?> colorValue = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => LabelsCompanion.insert(
                id: id,
                name: name,
                colorValue: colorValue,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LabelsTable, LabelRow>(table),
                  $$LabelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriptionLabelsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriptionLabelsRefs) db.subscriptionLabels,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriptionLabelsRefs)
                    await $_getPrefetchedDataByColumns<
                      LabelRow,
                      $LabelsTable,
                      SubscriptionLabelRow,
                      $SubscriptionLabelsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LabelsTableReferences
                          ._subscriptionLabelsRefsTable(db),
                      managerFromTypedResult: (p0) => $$LabelsTableReferences(
                        db,
                        table,
                        p0,
                      ).subscriptionLabelsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'label_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabelsTable,
      LabelRow,
      $$LabelsTableFilterComposer,
      $$LabelsTableOrderingComposer,
      $$LabelsTableAnnotationComposer,
      $$LabelsTableCreateCompanionBuilder,
      $$LabelsTableUpdateCompanionBuilder,
      (LabelRow, $$LabelsTableReferences),
      LabelRow,
      PrefetchHooks Function({bool subscriptionLabelsRefs})
    >;
typedef $$SubscriptionLabelsTableCreateCompanionBuilder =
    SubscriptionLabelsCompanion Function({
      required String subscriptionId,
      required String labelId,
      Value<int> rowid,
    });
typedef $$SubscriptionLabelsTableUpdateCompanionBuilder =
    SubscriptionLabelsCompanion Function({
      Value<String> subscriptionId,
      Value<String> labelId,
      Value<int> rowid,
    });

final class $$SubscriptionLabelsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubscriptionLabelsTable,
          SubscriptionLabelRow
        > {
  $$SubscriptionLabelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubscriptionsTable _subscriptionIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('subscription_labels__subscription_id__subscriptions__id');

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

  static $LabelsTable _labelIdTable(_$AppDatabase db) =>
      db.labels.createAlias('subscription_labels__label_id__labels__id');

  $$LabelsTableProcessedTableManager get labelId {
    final $_column = $_itemColumn<String>('label_id')!;

    final manager = $$LabelsTableTableManager(
      $_db,
      $_db.labels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriptionLabelsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionLabelsTable> {
  $$SubscriptionLabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$LabelsTableFilterComposer get labelId {
    final $$LabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableFilterComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionLabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionLabelsTable> {
  $$SubscriptionLabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$LabelsTableOrderingComposer get labelId {
    final $$LabelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableOrderingComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionLabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionLabelsTable> {
  $$SubscriptionLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  $$LabelsTableAnnotationComposer get labelId {
    final $$LabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.labels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.labels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionLabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionLabelsTable,
          SubscriptionLabelRow,
          $$SubscriptionLabelsTableFilterComposer,
          $$SubscriptionLabelsTableOrderingComposer,
          $$SubscriptionLabelsTableAnnotationComposer,
          $$SubscriptionLabelsTableCreateCompanionBuilder,
          $$SubscriptionLabelsTableUpdateCompanionBuilder,
          (SubscriptionLabelRow, $$SubscriptionLabelsTableReferences),
          SubscriptionLabelRow,
          PrefetchHooks Function({bool subscriptionId, bool labelId})
        > {
  $$SubscriptionLabelsTableTableManager(
    _$AppDatabase db,
    $SubscriptionLabelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionLabelsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> subscriptionId = const Value.absent(),
                Value<String> labelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionLabelsCompanion(
                subscriptionId: subscriptionId,
                labelId: labelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subscriptionId,
                required String labelId,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionLabelsCompanion.insert(
                subscriptionId: subscriptionId,
                labelId: labelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubscriptionLabelsTable, SubscriptionLabelRow>(
                    table,
                  ),
                  $$SubscriptionLabelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriptionId = false, labelId = false}) {
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
                        referencedTable: $$SubscriptionLabelsTableReferences
                            ._subscriptionIdTable(db),
                        referencedColumn: $$SubscriptionLabelsTableReferences
                            ._subscriptionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (labelId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.labelId,
                        referencedTable: $$SubscriptionLabelsTableReferences
                            ._labelIdTable(db),
                        referencedColumn: $$SubscriptionLabelsTableReferences
                            ._labelIdTable(db)
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

typedef $$SubscriptionLabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionLabelsTable,
      SubscriptionLabelRow,
      $$SubscriptionLabelsTableFilterComposer,
      $$SubscriptionLabelsTableOrderingComposer,
      $$SubscriptionLabelsTableAnnotationComposer,
      $$SubscriptionLabelsTableCreateCompanionBuilder,
      $$SubscriptionLabelsTableUpdateCompanionBuilder,
      (SubscriptionLabelRow, $$SubscriptionLabelsTableReferences),
      SubscriptionLabelRow,
      PrefetchHooks Function({bool subscriptionId, bool labelId})
    >;
typedef $$PaymentMethodsTableCreateCompanionBuilder =
    PaymentMethodsCompanion Function({
      required String id,
      required String name,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$PaymentMethodsTableUpdateCompanionBuilder =
    PaymentMethodsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$PaymentMethodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentMethodsTable,
          PaymentMethodRow,
          $$PaymentMethodsTableFilterComposer,
          $$PaymentMethodsTableOrderingComposer,
          $$PaymentMethodsTableAnnotationComposer,
          $$PaymentMethodsTableCreateCompanionBuilder,
          $$PaymentMethodsTableUpdateCompanionBuilder,
          (
            PaymentMethodRow,
            BaseReferences<
              _$AppDatabase,
              $PaymentMethodsTable,
              PaymentMethodRow
            >,
          ),
          PaymentMethodRow,
          PrefetchHooks Function()
        > {
  $$PaymentMethodsTableTableManager(
    _$AppDatabase db,
    $PaymentMethodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentMethodsCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => PaymentMethodsCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentMethodsTable, PaymentMethodRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PaymentMethodsTable,
                    PaymentMethodRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentMethodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentMethodsTable,
      PaymentMethodRow,
      $$PaymentMethodsTableFilterComposer,
      $$PaymentMethodsTableOrderingComposer,
      $$PaymentMethodsTableAnnotationComposer,
      $$PaymentMethodsTableCreateCompanionBuilder,
      $$PaymentMethodsTableUpdateCompanionBuilder,
      (
        PaymentMethodRow,
        BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethodRow>,
      ),
      PaymentMethodRow,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  Value<String?> categoryId,
  required int amountMinor,
  required String currency,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String?> categoryId,
  Value<int> amountMinor,
  Value<String> currency,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
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

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
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
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
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

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
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
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> categoryId = const Value.absent(),
                required int amountMinor,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTable, BudgetRow>(table),
                  BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>(
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

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
      PrefetchHooks Function()
    >;
typedef $$DetectedChargesTableCreateCompanionBuilder =
    DetectedChargesCompanion Function({
      required String id,
      required String name,
      required int amountMinor,
      required String currency,
      required String date,
      required String source,
      Value<int?> cycleEvery,
      Value<String?> cycleUnit,
      Value<bool> isRenewal,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DetectedChargesTableUpdateCompanionBuilder =
    DetectedChargesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String> date,
      Value<String> source,
      Value<int?> cycleEvery,
      Value<String?> cycleUnit,
      Value<bool> isRenewal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DetectedChargesTableFilterComposer
    extends Composer<_$AppDatabase, $DetectedChargesTable> {
  $$DetectedChargesTableFilterComposer({
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

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
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

  ColumnFilters<bool> get isRenewal => $composableBuilder(
    column: $table.isRenewal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DetectedChargesTableOrderingComposer
    extends Composer<_$AppDatabase, $DetectedChargesTable> {
  $$DetectedChargesTableOrderingComposer({
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

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
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

  ColumnOrderings<bool> get isRenewal => $composableBuilder(
    column: $table.isRenewal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DetectedChargesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetectedChargesTable> {
  $$DetectedChargesTableAnnotationComposer({
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

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get cycleEvery => $composableBuilder(
    column: $table.cycleEvery,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cycleUnit =>
      $composableBuilder(column: $table.cycleUnit, builder: (column) => column);

  GeneratedColumn<bool> get isRenewal =>
      $composableBuilder(column: $table.isRenewal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DetectedChargesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DetectedChargesTable,
          DetectedChargeRow,
          $$DetectedChargesTableFilterComposer,
          $$DetectedChargesTableOrderingComposer,
          $$DetectedChargesTableAnnotationComposer,
          $$DetectedChargesTableCreateCompanionBuilder,
          $$DetectedChargesTableUpdateCompanionBuilder,
          (
            DetectedChargeRow,
            BaseReferences<
              _$AppDatabase,
              $DetectedChargesTable,
              DetectedChargeRow
            >,
          ),
          DetectedChargeRow,
          PrefetchHooks Function()
        > {
  $$DetectedChargesTableTableManager(
    _$AppDatabase db,
    $DetectedChargesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetectedChargesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DetectedChargesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DetectedChargesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int?> cycleEvery = const Value.absent(),
                Value<String?> cycleUnit = const Value.absent(),
                Value<bool> isRenewal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DetectedChargesCompanion(
                id: id,
                name: name,
                amountMinor: amountMinor,
                currency: currency,
                date: date,
                source: source,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                isRenewal: isRenewal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int amountMinor,
                required String currency,
                required String date,
                required String source,
                Value<int?> cycleEvery = const Value.absent(),
                Value<String?> cycleUnit = const Value.absent(),
                Value<bool> isRenewal = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DetectedChargesCompanion.insert(
                id: id,
                name: name,
                amountMinor: amountMinor,
                currency: currency,
                date: date,
                source: source,
                cycleEvery: cycleEvery,
                cycleUnit: cycleUnit,
                isRenewal: isRenewal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DetectedChargesTable, DetectedChargeRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DetectedChargesTable,
                    DetectedChargeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DetectedChargesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DetectedChargesTable,
      DetectedChargeRow,
      $$DetectedChargesTableFilterComposer,
      $$DetectedChargesTableOrderingComposer,
      $$DetectedChargesTableAnnotationComposer,
      $$DetectedChargesTableCreateCompanionBuilder,
      $$DetectedChargesTableUpdateCompanionBuilder,
      (
        DetectedChargeRow,
        BaseReferences<_$AppDatabase, $DetectedChargesTable, DetectedChargeRow>,
      ),
      DetectedChargeRow,
      PrefetchHooks Function()
    >;
typedef $$DismissedDetectionsTableCreateCompanionBuilder =
    DismissedDetectionsCompanion Function({
      required String key,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$DismissedDetectionsTableUpdateCompanionBuilder =
    DismissedDetectionsCompanion Function({
      Value<String> key,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DismissedDetectionsTableFilterComposer
    extends Composer<_$AppDatabase, $DismissedDetectionsTable> {
  $$DismissedDetectionsTableFilterComposer({
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DismissedDetectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DismissedDetectionsTable> {
  $$DismissedDetectionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DismissedDetectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DismissedDetectionsTable> {
  $$DismissedDetectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DismissedDetectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DismissedDetectionsTable,
          DismissedDetectionRow,
          $$DismissedDetectionsTableFilterComposer,
          $$DismissedDetectionsTableOrderingComposer,
          $$DismissedDetectionsTableAnnotationComposer,
          $$DismissedDetectionsTableCreateCompanionBuilder,
          $$DismissedDetectionsTableUpdateCompanionBuilder,
          (
            DismissedDetectionRow,
            BaseReferences<
              _$AppDatabase,
              $DismissedDetectionsTable,
              DismissedDetectionRow
            >,
          ),
          DismissedDetectionRow,
          PrefetchHooks Function()
        > {
  $$DismissedDetectionsTableTableManager(
    _$AppDatabase db,
    $DismissedDetectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DismissedDetectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DismissedDetectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DismissedDetectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DismissedDetectionsCompanion(
                key: key,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DismissedDetectionsCompanion.insert(
                key: key,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DismissedDetectionsTable, DismissedDetectionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DismissedDetectionsTable,
                    DismissedDetectionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DismissedDetectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DismissedDetectionsTable,
      DismissedDetectionRow,
      $$DismissedDetectionsTableFilterComposer,
      $$DismissedDetectionsTableOrderingComposer,
      $$DismissedDetectionsTableAnnotationComposer,
      $$DismissedDetectionsTableCreateCompanionBuilder,
      $$DismissedDetectionsTableUpdateCompanionBuilder,
      (
        DismissedDetectionRow,
        BaseReferences<
          _$AppDatabase,
          $DismissedDetectionsTable,
          DismissedDetectionRow
        >,
      ),
      DismissedDetectionRow,
      PrefetchHooks Function()
    >;
typedef $$PriceChangesTableCreateCompanionBuilder =
    PriceChangesCompanion Function({
      required String id,
      required String subscriptionId,
      required int oldPriceMinor,
      required int newPriceMinor,
      required String currency,
      Value<String?> oldCurrency,
      required String effectiveFrom,
      required String source,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PriceChangesTableUpdateCompanionBuilder =
    PriceChangesCompanion Function({
      Value<String> id,
      Value<String> subscriptionId,
      Value<int> oldPriceMinor,
      Value<int> newPriceMinor,
      Value<String> currency,
      Value<String?> oldCurrency,
      Value<String> effectiveFrom,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PriceChangesTableReferences
    extends BaseReferences<_$AppDatabase, $PriceChangesTable, PriceChangeRow> {
  $$PriceChangesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubscriptionsTable _subscriptionIdTable(_$AppDatabase db) => db
      .subscriptions
      .createAlias('price_changes__subscription_id__subscriptions__id');

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

class $$PriceChangesTableFilterComposer
    extends Composer<_$AppDatabase, $PriceChangesTable> {
  $$PriceChangesTableFilterComposer({
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

  ColumnFilters<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newPriceMinor => $composableBuilder(
    column: $table.newPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldCurrency => $composableBuilder(
    column: $table.oldCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$PriceChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceChangesTable> {
  $$PriceChangesTableOrderingComposer({
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

  ColumnOrderings<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newPriceMinor => $composableBuilder(
    column: $table.newPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldCurrency => $composableBuilder(
    column: $table.oldCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$PriceChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceChangesTable> {
  $$PriceChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get oldPriceMinor => $composableBuilder(
    column: $table.oldPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newPriceMinor => $composableBuilder(
    column: $table.newPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get oldCurrency => $composableBuilder(
    column: $table.oldCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

class $$PriceChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceChangesTable,
          PriceChangeRow,
          $$PriceChangesTableFilterComposer,
          $$PriceChangesTableOrderingComposer,
          $$PriceChangesTableAnnotationComposer,
          $$PriceChangesTableCreateCompanionBuilder,
          $$PriceChangesTableUpdateCompanionBuilder,
          (PriceChangeRow, $$PriceChangesTableReferences),
          PriceChangeRow,
          PrefetchHooks Function({bool subscriptionId})
        > {
  $$PriceChangesTableTableManager(_$AppDatabase db, $PriceChangesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subscriptionId = const Value.absent(),
                Value<int> oldPriceMinor = const Value.absent(),
                Value<int> newPriceMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> oldCurrency = const Value.absent(),
                Value<String> effectiveFrom = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PriceChangesCompanion(
                id: id,
                subscriptionId: subscriptionId,
                oldPriceMinor: oldPriceMinor,
                newPriceMinor: newPriceMinor,
                currency: currency,
                oldCurrency: oldCurrency,
                effectiveFrom: effectiveFrom,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subscriptionId,
                required int oldPriceMinor,
                required int newPriceMinor,
                required String currency,
                Value<String?> oldCurrency = const Value.absent(),
                required String effectiveFrom,
                required String source,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PriceChangesCompanion.insert(
                id: id,
                subscriptionId: subscriptionId,
                oldPriceMinor: oldPriceMinor,
                newPriceMinor: newPriceMinor,
                currency: currency,
                oldCurrency: oldCurrency,
                effectiveFrom: effectiveFrom,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PriceChangesTable, PriceChangeRow>(table),
                  $$PriceChangesTableReferences(db, table, e),
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
                        referencedTable: $$PriceChangesTableReferences
                            ._subscriptionIdTable(db),
                        referencedColumn: $$PriceChangesTableReferences
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

typedef $$PriceChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceChangesTable,
      PriceChangeRow,
      $$PriceChangesTableFilterComposer,
      $$PriceChangesTableOrderingComposer,
      $$PriceChangesTableAnnotationComposer,
      $$PriceChangesTableCreateCompanionBuilder,
      $$PriceChangesTableUpdateCompanionBuilder,
      (PriceChangeRow, $$PriceChangesTableReferences),
      PriceChangeRow,
      PrefetchHooks Function({bool subscriptionId})
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
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$LabelsTableTableManager get labels =>
      $$LabelsTableTableManager(_db, _db.labels);
  $$SubscriptionLabelsTableTableManager get subscriptionLabels =>
      $$SubscriptionLabelsTableTableManager(_db, _db.subscriptionLabels);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$DetectedChargesTableTableManager get detectedCharges =>
      $$DetectedChargesTableTableManager(_db, _db.detectedCharges);
  $$DismissedDetectionsTableTableManager get dismissedDetections =>
      $$DismissedDetectionsTableTableManager(_db, _db.dismissedDetections);
  $$PriceChangesTableTableManager get priceChanges =>
      $$PriceChangesTableTableManager(_db, _db.priceChanges);
}
