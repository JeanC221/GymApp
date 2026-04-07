// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_day_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanDayRecordCollection on Isar {
  IsarCollection<PlanDayRecord> get planDayRecords => this.collection();
}

const PlanDayRecordSchema = CollectionSchema(
  name: r'PlanDayRecord',
  id: 2482475535284917059,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.string,
    ),
    r'orderIndex': PropertySchema(
      id: 1,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'routineName': PropertySchema(
      id: 2,
      name: r'routineName',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.byte,
      enumMap: _PlanDayRecordtypeEnumValueMap,
    ),
    r'weekday': PropertySchema(
      id: 4,
      name: r'weekday',
      type: IsarType.byte,
      enumMap: _PlanDayRecordweekdayEnumValueMap,
    ),
    r'weeklyPlanId': PropertySchema(
      id: 5,
      name: r'weeklyPlanId',
      type: IsarType.string,
    )
  },
  estimateSize: _planDayRecordEstimateSize,
  serialize: _planDayRecordSerialize,
  deserialize: _planDayRecordDeserialize,
  deserializeProp: _planDayRecordDeserializeProp,
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
    r'weeklyPlanId': IndexSchema(
      id: -5364825725739234276,
      name: r'weeklyPlanId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weeklyPlanId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'weekday': IndexSchema(
      id: 4342737135278800718,
      name: r'weekday',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weekday',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _planDayRecordGetId,
  getLinks: _planDayRecordGetLinks,
  attach: _planDayRecordAttach,
  version: '3.1.0+1',
);

int _planDayRecordEstimateSize(
  PlanDayRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.routineName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.weeklyPlanId.length * 3;
  return bytesCount;
}

void _planDayRecordSerialize(
  PlanDayRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.id);
  writer.writeLong(offsets[1], object.orderIndex);
  writer.writeString(offsets[2], object.routineName);
  writer.writeByte(offsets[3], object.type.index);
  writer.writeByte(offsets[4], object.weekday.index);
  writer.writeString(offsets[5], object.weeklyPlanId);
}

PlanDayRecord _planDayRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanDayRecord();
  object.id = reader.readString(offsets[0]);
  object.isarId = id;
  object.orderIndex = reader.readLong(offsets[1]);
  object.routineName = reader.readStringOrNull(offsets[2]);
  object.type =
      _PlanDayRecordtypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
          PlanDayType.training;
  object.weekday =
      _PlanDayRecordweekdayValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          Weekday.monday;
  object.weeklyPlanId = reader.readString(offsets[5]);
  return object;
}

P _planDayRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (_PlanDayRecordtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          PlanDayType.training) as P;
    case 4:
      return (_PlanDayRecordweekdayValueEnumMap[
              reader.readByteOrNull(offset)] ??
          Weekday.monday) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PlanDayRecordtypeEnumValueMap = {
  'training': 0,
  'rest': 1,
};
const _PlanDayRecordtypeValueEnumMap = {
  0: PlanDayType.training,
  1: PlanDayType.rest,
};
const _PlanDayRecordweekdayEnumValueMap = {
  'monday': 0,
  'tuesday': 1,
  'wednesday': 2,
  'thursday': 3,
  'friday': 4,
  'saturday': 5,
  'sunday': 6,
};
const _PlanDayRecordweekdayValueEnumMap = {
  0: Weekday.monday,
  1: Weekday.tuesday,
  2: Weekday.wednesday,
  3: Weekday.thursday,
  4: Weekday.friday,
  5: Weekday.saturday,
  6: Weekday.sunday,
};

Id _planDayRecordGetId(PlanDayRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _planDayRecordGetLinks(PlanDayRecord object) {
  return [];
}

void _planDayRecordAttach(
    IsarCollection<dynamic> col, Id id, PlanDayRecord object) {
  object.isarId = id;
}

extension PlanDayRecordByIndex on IsarCollection<PlanDayRecord> {
  Future<PlanDayRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  PlanDayRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<PlanDayRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<PlanDayRecord?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(PlanDayRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(PlanDayRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<PlanDayRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<PlanDayRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension PlanDayRecordQueryWhereSort
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QWhere> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhere> anyWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekday'),
      );
    });
  }
}

extension PlanDayRecordQueryWhere
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QWhereClause> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> idNotEqualTo(
      String id) {
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
      weeklyPlanIdEqualTo(String weeklyPlanId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weeklyPlanId',
        value: [weeklyPlanId],
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
      weeklyPlanIdNotEqualTo(String weeklyPlanId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weeklyPlanId',
              lower: [],
              upper: [weeklyPlanId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weeklyPlanId',
              lower: [weeklyPlanId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weeklyPlanId',
              lower: [weeklyPlanId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weeklyPlanId',
              lower: [],
              upper: [weeklyPlanId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> weekdayEqualTo(
      Weekday weekday) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekday',
        value: [weekday],
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
      weekdayNotEqualTo(Weekday weekday) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekday',
              lower: [],
              upper: [weekday],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekday',
              lower: [weekday],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekday',
              lower: [weekday],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekday',
              lower: [],
              upper: [weekday],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause>
      weekdayGreaterThan(
    Weekday weekday, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekday',
        lower: [weekday],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> weekdayLessThan(
    Weekday weekday, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekday',
        lower: [],
        upper: [weekday],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterWhereClause> weekdayBetween(
    Weekday lowerWeekday,
    Weekday upperWeekday, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekday',
        lower: [lowerWeekday],
        includeLower: includeLower,
        upper: [upperWeekday],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlanDayRecordQueryFilter
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QFilterCondition> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
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

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'routineName',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'routineName',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routineName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'routineName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'routineName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      routineNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'routineName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> typeEqualTo(
      PlanDayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      typeGreaterThan(
    PlanDayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      typeLessThan(
    PlanDayType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition> typeBetween(
    PlanDayType lower,
    PlanDayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weekdayEqualTo(Weekday value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weekdayGreaterThan(
    Weekday value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weekdayLessThan(
    Weekday value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekday',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weekdayBetween(
    Weekday lower,
    Weekday upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeklyPlanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weeklyPlanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weeklyPlanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeklyPlanId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterFilterCondition>
      weeklyPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weeklyPlanId',
        value: '',
      ));
    });
  }
}

extension PlanDayRecordQueryObject
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QFilterCondition> {}

extension PlanDayRecordQueryLinks
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QFilterCondition> {}

extension PlanDayRecordQuerySortBy
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QSortBy> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByRoutineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineName', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      sortByRoutineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineName', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> sortByWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      sortByWeeklyPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPlanId', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      sortByWeeklyPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPlanId', Sort.desc);
    });
  }
}

extension PlanDayRecordQuerySortThenBy
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QSortThenBy> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByRoutineName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineName', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      thenByRoutineNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineName', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy> thenByWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.desc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      thenByWeeklyPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPlanId', Sort.asc);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QAfterSortBy>
      thenByWeeklyPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklyPlanId', Sort.desc);
    });
  }
}

extension PlanDayRecordQueryWhereDistinct
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> {
  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctByRoutineName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routineName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekday');
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayRecord, QDistinct> distinctByWeeklyPlanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklyPlanId', caseSensitive: caseSensitive);
    });
  }
}

extension PlanDayRecordQueryProperty
    on QueryBuilder<PlanDayRecord, PlanDayRecord, QQueryProperty> {
  QueryBuilder<PlanDayRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PlanDayRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlanDayRecord, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<PlanDayRecord, String?, QQueryOperations> routineNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routineName');
    });
  }

  QueryBuilder<PlanDayRecord, PlanDayType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<PlanDayRecord, Weekday, QQueryOperations> weekdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekday');
    });
  }

  QueryBuilder<PlanDayRecord, String, QQueryOperations> weeklyPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklyPlanId');
    });
  }
}
