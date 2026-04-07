// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutSessionRecordCollection on Isar {
  IsarCollection<WorkoutSessionRecord> get workoutSessionRecords =>
      this.collection();
}

const WorkoutSessionRecordSchema = CollectionSchema(
  name: r'WorkoutSessionRecord',
  id: 6106439854413807696,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'planDayId': PropertySchema(
      id: 2,
      name: r'planDayId',
      type: IsarType.string,
    ),
    r'sessionDate': PropertySchema(
      id: 3,
      name: r'sessionDate',
      type: IsarType.dateTime,
    ),
    r'sessionStatus': PropertySchema(
      id: 4,
      name: r'sessionStatus',
      type: IsarType.byte,
      enumMap: _WorkoutSessionRecordsessionStatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _workoutSessionRecordEstimateSize,
  serialize: _workoutSessionRecordSerialize,
  deserialize: _workoutSessionRecordDeserialize,
  deserializeProp: _workoutSessionRecordDeserializeProp,
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
    r'planDayId': IndexSchema(
      id: -2438474117897233685,
      name: r'planDayId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planDayId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sessionDate': IndexSchema(
      id: 2006552208572811236,
      name: r'sessionDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sessionDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _workoutSessionRecordGetId,
  getLinks: _workoutSessionRecordGetLinks,
  attach: _workoutSessionRecordAttach,
  version: '3.1.0+1',
);

int _workoutSessionRecordEstimateSize(
  WorkoutSessionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.planDayId.length * 3;
  return bytesCount;
}

void _workoutSessionRecordSerialize(
  WorkoutSessionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.id);
  writer.writeString(offsets[2], object.planDayId);
  writer.writeDateTime(offsets[3], object.sessionDate);
  writer.writeByte(offsets[4], object.sessionStatus.index);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

WorkoutSessionRecord _workoutSessionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutSessionRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.isarId = id;
  object.planDayId = reader.readString(offsets[2]);
  object.sessionDate = reader.readDateTime(offsets[3]);
  object.sessionStatus = _WorkoutSessionRecordsessionStatusValueEnumMap[
          reader.readByteOrNull(offsets[4])] ??
      WorkoutSessionStatus.pending;
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _workoutSessionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_WorkoutSessionRecordsessionStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          WorkoutSessionStatus.pending) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WorkoutSessionRecordsessionStatusEnumValueMap = {
  'pending': 0,
  'inProgress': 1,
  'completed': 2,
  'skipped': 3,
};
const _WorkoutSessionRecordsessionStatusValueEnumMap = {
  0: WorkoutSessionStatus.pending,
  1: WorkoutSessionStatus.inProgress,
  2: WorkoutSessionStatus.completed,
  3: WorkoutSessionStatus.skipped,
};

Id _workoutSessionRecordGetId(WorkoutSessionRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _workoutSessionRecordGetLinks(
    WorkoutSessionRecord object) {
  return [];
}

void _workoutSessionRecordAttach(
    IsarCollection<dynamic> col, Id id, WorkoutSessionRecord object) {
  object.isarId = id;
}

extension WorkoutSessionRecordByIndex on IsarCollection<WorkoutSessionRecord> {
  Future<WorkoutSessionRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  WorkoutSessionRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<WorkoutSessionRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<WorkoutSessionRecord?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(WorkoutSessionRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(WorkoutSessionRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<WorkoutSessionRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<WorkoutSessionRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension WorkoutSessionRecordQueryWhereSort
    on QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QWhere> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhere>
      anySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sessionDate'),
      );
    });
  }
}

extension WorkoutSessionRecordQueryWhere
    on QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QWhereClause> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      planDayIdEqualTo(String planDayId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planDayId',
        value: [planDayId],
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      planDayIdNotEqualTo(String planDayId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planDayId',
              lower: [],
              upper: [planDayId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planDayId',
              lower: [planDayId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planDayId',
              lower: [planDayId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planDayId',
              lower: [],
              upper: [planDayId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      sessionDateEqualTo(DateTime sessionDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sessionDate',
        value: [sessionDate],
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      sessionDateNotEqualTo(DateTime sessionDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionDate',
              lower: [],
              upper: [sessionDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionDate',
              lower: [sessionDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionDate',
              lower: [sessionDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sessionDate',
              lower: [],
              upper: [sessionDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      sessionDateGreaterThan(
    DateTime sessionDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionDate',
        lower: [sessionDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      sessionDateLessThan(
    DateTime sessionDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionDate',
        lower: [],
        upper: [sessionDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterWhereClause>
      sessionDateBetween(
    DateTime lowerSessionDate,
    DateTime upperSessionDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sessionDate',
        lower: [lowerSessionDate],
        includeLower: includeLower,
        upper: [upperSessionDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WorkoutSessionRecordQueryFilter on QueryBuilder<WorkoutSessionRecord,
    WorkoutSessionRecord, QFilterCondition> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planDayId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
          QAfterFilterCondition>
      planDayIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planDayId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
          QAfterFilterCondition>
      planDayIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planDayId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planDayId',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> planDayIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planDayId',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionStatusEqualTo(WorkoutSessionStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionStatusGreaterThan(
    WorkoutSessionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionStatusLessThan(
    WorkoutSessionStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> sessionStatusBetween(
    WorkoutSessionStatus lower,
    WorkoutSessionStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WorkoutSessionRecordQueryObject on QueryBuilder<WorkoutSessionRecord,
    WorkoutSessionRecord, QFilterCondition> {}

extension WorkoutSessionRecordQueryLinks on QueryBuilder<WorkoutSessionRecord,
    WorkoutSessionRecord, QFilterCondition> {}

extension WorkoutSessionRecordQuerySortBy
    on QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QSortBy> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByPlanDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planDayId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByPlanDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planDayId', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortBySessionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionStatus', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortBySessionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionStatus', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WorkoutSessionRecordQuerySortThenBy
    on QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QSortThenBy> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByPlanDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planDayId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByPlanDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planDayId', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenBySessionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionStatus', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenBySessionStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionStatus', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WorkoutSessionRecordQueryWhereDistinct
    on QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct> {
  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctByPlanDayId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planDayId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionDate');
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctBySessionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionStatus');
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension WorkoutSessionRecordQueryProperty on QueryBuilder<
    WorkoutSessionRecord, WorkoutSessionRecord, QQueryProperty> {
  QueryBuilder<WorkoutSessionRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<WorkoutSessionRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WorkoutSessionRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkoutSessionRecord, String, QQueryOperations>
      planDayIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planDayId');
    });
  }

  QueryBuilder<WorkoutSessionRecord, DateTime, QQueryOperations>
      sessionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionDate');
    });
  }

  QueryBuilder<WorkoutSessionRecord, WorkoutSessionStatus, QQueryOperations>
      sessionStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionStatus');
    });
  }

  QueryBuilder<WorkoutSessionRecord, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
