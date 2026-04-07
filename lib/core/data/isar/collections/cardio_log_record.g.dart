// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardio_log_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardioLogRecordCollection on Isar {
  IsarCollection<CardioLogRecord> get cardioLogRecords => this.collection();
}

const CardioLogRecordSchema = CollectionSchema(
  name: r'CardioLogRecord',
  id: -3951314176483571620,
  properties: {
    r'averageHeartRate': PropertySchema(
      id: 0,
      name: r'averageHeartRate',
      type: IsarType.long,
    ),
    r'calories': PropertySchema(
      id: 1,
      name: r'calories',
      type: IsarType.long,
    ),
    r'cardioType': PropertySchema(
      id: 2,
      name: r'cardioType',
      type: IsarType.string,
    ),
    r'distance': PropertySchema(
      id: 3,
      name: r'distance',
      type: IsarType.double,
    ),
    r'durationMinutes': PropertySchema(
      id: 4,
      name: r'durationMinutes',
      type: IsarType.long,
    ),
    r'exerciseTemplateId': PropertySchema(
      id: 5,
      name: r'exerciseTemplateId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.string,
    ),
    r'incline': PropertySchema(
      id: 7,
      name: r'incline',
      type: IsarType.double,
    ),
    r'source': PropertySchema(
      id: 8,
      name: r'source',
      type: IsarType.byte,
      enumMap: _CardioLogRecordsourceEnumValueMap,
    ),
    r'workoutSessionId': PropertySchema(
      id: 9,
      name: r'workoutSessionId',
      type: IsarType.string,
    )
  },
  estimateSize: _cardioLogRecordEstimateSize,
  serialize: _cardioLogRecordSerialize,
  deserialize: _cardioLogRecordDeserialize,
  deserializeProp: _cardioLogRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workoutSessionId': IndexSchema(
      id: 4885970055233737365,
      name: r'workoutSessionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workoutSessionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'exerciseTemplateId': IndexSchema(
      id: 4487856677418974640,
      name: r'exerciseTemplateId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'exerciseTemplateId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cardioLogRecordGetId,
  getLinks: _cardioLogRecordGetLinks,
  attach: _cardioLogRecordAttach,
  version: '3.1.0+1',
);

int _cardioLogRecordEstimateSize(
  CardioLogRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardioType.length * 3;
  bytesCount += 3 + object.exerciseTemplateId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.workoutSessionId.length * 3;
  return bytesCount;
}

void _cardioLogRecordSerialize(
  CardioLogRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.averageHeartRate);
  writer.writeLong(offsets[1], object.calories);
  writer.writeString(offsets[2], object.cardioType);
  writer.writeDouble(offsets[3], object.distance);
  writer.writeLong(offsets[4], object.durationMinutes);
  writer.writeString(offsets[5], object.exerciseTemplateId);
  writer.writeString(offsets[6], object.id);
  writer.writeDouble(offsets[7], object.incline);
  writer.writeByte(offsets[8], object.source.index);
  writer.writeString(offsets[9], object.workoutSessionId);
}

CardioLogRecord _cardioLogRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardioLogRecord();
  object.averageHeartRate = reader.readLongOrNull(offsets[0]);
  object.calories = reader.readLongOrNull(offsets[1]);
  object.cardioType = reader.readString(offsets[2]);
  object.distance = reader.readDoubleOrNull(offsets[3]);
  object.durationMinutes = reader.readLong(offsets[4]);
  object.exerciseTemplateId = reader.readString(offsets[5]);
  object.id = reader.readString(offsets[6]);
  object.incline = reader.readDoubleOrNull(offsets[7]);
  object.isarId = id;
  object.source =
      _CardioLogRecordsourceValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          CardioSource.manual;
  object.workoutSessionId = reader.readString(offsets[9]);
  return object;
}

P _cardioLogRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (_CardioLogRecordsourceValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CardioSource.manual) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CardioLogRecordsourceEnumValueMap = {
  'manual': 0,
  'imported': 1,
};
const _CardioLogRecordsourceValueEnumMap = {
  0: CardioSource.manual,
  1: CardioSource.imported,
};

Id _cardioLogRecordGetId(CardioLogRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cardioLogRecordGetLinks(CardioLogRecord object) {
  return [];
}

void _cardioLogRecordAttach(
    IsarCollection<dynamic> col, Id id, CardioLogRecord object) {
  object.isarId = id;
}

extension CardioLogRecordByIndex on IsarCollection<CardioLogRecord> {
  Future<CardioLogRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  CardioLogRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<CardioLogRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<CardioLogRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(CardioLogRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(CardioLogRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<CardioLogRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<CardioLogRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension CardioLogRecordQueryWhereSort
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QWhere> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardioLogRecordQueryWhere
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QWhereClause> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      workoutSessionIdEqualTo(String workoutSessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workoutSessionId',
        value: [workoutSessionId],
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      workoutSessionIdNotEqualTo(String workoutSessionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [],
              upper: [workoutSessionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [workoutSessionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [workoutSessionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workoutSessionId',
              lower: [],
              upper: [workoutSessionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      exerciseTemplateIdEqualTo(String exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseTemplateId',
        value: [exerciseTemplateId],
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterWhereClause>
      exerciseTemplateIdNotEqualTo(String exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [],
              upper: [exerciseTemplateId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [exerciseTemplateId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [exerciseTemplateId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'exerciseTemplateId',
              lower: [],
              upper: [exerciseTemplateId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CardioLogRecordQueryFilter
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QFilterCondition> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'averageHeartRate',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'averageHeartRate',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageHeartRate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageHeartRate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageHeartRate',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      averageHeartRateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageHeartRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calories',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calories',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      caloriesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cardioType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cardioType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardioType',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      cardioTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cardioType',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      distanceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      durationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      durationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      durationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      durationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseTemplateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseTemplateId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      exerciseTemplateIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'incline',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'incline',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      inclineBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      sourceEqualTo(CardioSource value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      sourceGreaterThan(
    CardioSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      sourceLessThan(
    CardioSource value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      sourceBetween(
    CardioSource lower,
    CardioSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutSessionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutSessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutSessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterFilterCondition>
      workoutSessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutSessionId',
        value: '',
      ));
    });
  }
}

extension CardioLogRecordQueryObject
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QFilterCondition> {}

extension CardioLogRecordQueryLinks
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QFilterCondition> {}

extension CardioLogRecordQuerySortBy
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QSortBy> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByAverageHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageHeartRate', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByAverageHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageHeartRate', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByCardioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByCardioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> sortByIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incline', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByInclineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incline', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      sortByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension CardioLogRecordQuerySortThenBy
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QSortThenBy> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByAverageHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageHeartRate', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByAverageHeartRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageHeartRate', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByCardioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByCardioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> thenByIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incline', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByInclineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incline', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QAfterSortBy>
      thenByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension CardioLogRecordQueryWhereDistinct
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct> {
  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByAverageHeartRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageHeartRate');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByCardioType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardioType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distance');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutes');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByExerciseTemplateId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseTemplateId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incline');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct> distinctBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source');
    });
  }

  QueryBuilder<CardioLogRecord, CardioLogRecord, QDistinct>
      distinctByWorkoutSessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutSessionId',
          caseSensitive: caseSensitive);
    });
  }
}

extension CardioLogRecordQueryProperty
    on QueryBuilder<CardioLogRecord, CardioLogRecord, QQueryProperty> {
  QueryBuilder<CardioLogRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CardioLogRecord, int?, QQueryOperations>
      averageHeartRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageHeartRate');
    });
  }

  QueryBuilder<CardioLogRecord, int?, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<CardioLogRecord, String, QQueryOperations> cardioTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardioType');
    });
  }

  QueryBuilder<CardioLogRecord, double?, QQueryOperations> distanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distance');
    });
  }

  QueryBuilder<CardioLogRecord, int, QQueryOperations>
      durationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutes');
    });
  }

  QueryBuilder<CardioLogRecord, String, QQueryOperations>
      exerciseTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseTemplateId');
    });
  }

  QueryBuilder<CardioLogRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardioLogRecord, double?, QQueryOperations> inclineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incline');
    });
  }

  QueryBuilder<CardioLogRecord, CardioSource, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<CardioLogRecord, String, QQueryOperations>
      workoutSessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutSessionId');
    });
  }
}
