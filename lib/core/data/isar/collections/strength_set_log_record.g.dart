// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strength_set_log_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStrengthSetLogRecordCollection on Isar {
  IsarCollection<StrengthSetLogRecord> get strengthSetLogRecords =>
      this.collection();
}

const StrengthSetLogRecordSchema = CollectionSchema(
  name: r'StrengthSetLogRecord',
  id: 8759995600113421673,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'exerciseTemplateId': PropertySchema(
      id: 1,
      name: r'exerciseTemplateId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'isCompleted': PropertySchema(
      id: 3,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'performedReps': PropertySchema(
      id: 4,
      name: r'performedReps',
      type: IsarType.long,
    ),
    r'performedWeight': PropertySchema(
      id: 5,
      name: r'performedWeight',
      type: IsarType.double,
    ),
    r'setIndex': PropertySchema(
      id: 6,
      name: r'setIndex',
      type: IsarType.long,
    ),
    r'workoutSessionId': PropertySchema(
      id: 7,
      name: r'workoutSessionId',
      type: IsarType.string,
    )
  },
  estimateSize: _strengthSetLogRecordEstimateSize,
  serialize: _strengthSetLogRecordSerialize,
  deserialize: _strengthSetLogRecordDeserialize,
  deserializeProp: _strengthSetLogRecordDeserializeProp,
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
    ),
    r'setIndex': IndexSchema(
      id: 3171703815277461603,
      name: r'setIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'setIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'completedAt': IndexSchema(
      id: -3156591011457686752,
      name: r'completedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'completedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _strengthSetLogRecordGetId,
  getLinks: _strengthSetLogRecordGetLinks,
  attach: _strengthSetLogRecordAttach,
  version: '3.1.0+1',
);

int _strengthSetLogRecordEstimateSize(
  StrengthSetLogRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseTemplateId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.workoutSessionId.length * 3;
  return bytesCount;
}

void _strengthSetLogRecordSerialize(
  StrengthSetLogRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.exerciseTemplateId);
  writer.writeString(offsets[2], object.id);
  writer.writeBool(offsets[3], object.isCompleted);
  writer.writeLong(offsets[4], object.performedReps);
  writer.writeDouble(offsets[5], object.performedWeight);
  writer.writeLong(offsets[6], object.setIndex);
  writer.writeString(offsets[7], object.workoutSessionId);
}

StrengthSetLogRecord _strengthSetLogRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StrengthSetLogRecord();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.exerciseTemplateId = reader.readString(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isCompleted = reader.readBool(offsets[3]);
  object.isarId = id;
  object.performedReps = reader.readLongOrNull(offsets[4]);
  object.performedWeight = reader.readDoubleOrNull(offsets[5]);
  object.setIndex = reader.readLong(offsets[6]);
  object.workoutSessionId = reader.readString(offsets[7]);
  return object;
}

P _strengthSetLogRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _strengthSetLogRecordGetId(StrengthSetLogRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _strengthSetLogRecordGetLinks(
    StrengthSetLogRecord object) {
  return [];
}

void _strengthSetLogRecordAttach(
    IsarCollection<dynamic> col, Id id, StrengthSetLogRecord object) {
  object.isarId = id;
}

extension StrengthSetLogRecordByIndex on IsarCollection<StrengthSetLogRecord> {
  Future<StrengthSetLogRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  StrengthSetLogRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<StrengthSetLogRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<StrengthSetLogRecord?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(StrengthSetLogRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(StrengthSetLogRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<StrengthSetLogRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<StrengthSetLogRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension StrengthSetLogRecordQueryWhereSort
    on QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QWhere> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhere>
      anySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'setIndex'),
      );
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhere>
      anyCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'completedAt'),
      );
    });
  }
}

extension StrengthSetLogRecordQueryWhere
    on QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QWhereClause> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      workoutSessionIdEqualTo(String workoutSessionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workoutSessionId',
        value: [workoutSessionId],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      exerciseTemplateIdEqualTo(String exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseTemplateId',
        value: [exerciseTemplateId],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      setIndexEqualTo(int setIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'setIndex',
        value: [setIndex],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      setIndexNotEqualTo(int setIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setIndex',
              lower: [],
              upper: [setIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setIndex',
              lower: [setIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setIndex',
              lower: [setIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'setIndex',
              lower: [],
              upper: [setIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      setIndexGreaterThan(
    int setIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'setIndex',
        lower: [setIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      setIndexLessThan(
    int setIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'setIndex',
        lower: [],
        upper: [setIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      setIndexBetween(
    int lowerSetIndex,
    int upperSetIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'setIndex',
        lower: [lowerSetIndex],
        includeLower: includeLower,
        upper: [upperSetIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtEqualTo(DateTime? completedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'completedAt',
        value: [completedAt],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtNotEqualTo(DateTime? completedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [completedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'completedAt',
              lower: [],
              upper: [completedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtGreaterThan(
    DateTime? completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [completedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtLessThan(
    DateTime? completedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [],
        upper: [completedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterWhereClause>
      completedAtBetween(
    DateTime? lowerCompletedAt,
    DateTime? upperCompletedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'completedAt',
        lower: [lowerCompletedAt],
        includeLower: includeLower,
        upper: [upperCompletedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StrengthSetLogRecordQueryFilter on QueryBuilder<StrengthSetLogRecord,
    StrengthSetLogRecord, QFilterCondition> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdEqualTo(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdGreaterThan(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdLessThan(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdBetween(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdStartsWith(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdEndsWith(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
          QAfterFilterCondition>
      exerciseTemplateIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exerciseTemplateId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
          QAfterFilterCondition>
      exerciseTemplateIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exerciseTemplateId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> exerciseTemplateIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'performedReps',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'performedReps',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performedReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performedReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performedReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedRepsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performedReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'performedWeight',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'performedWeight',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'performedWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'performedWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'performedWeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> performedWeightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'performedWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> setIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> setIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> setIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> setIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdEqualTo(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdGreaterThan(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdLessThan(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdBetween(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdStartsWith(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdEndsWith(
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

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
          QAfterFilterCondition>
      workoutSessionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutSessionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
          QAfterFilterCondition>
      workoutSessionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutSessionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutSessionId',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord,
      QAfterFilterCondition> workoutSessionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutSessionId',
        value: '',
      ));
    });
  }
}

extension StrengthSetLogRecordQueryObject on QueryBuilder<StrengthSetLogRecord,
    StrengthSetLogRecord, QFilterCondition> {}

extension StrengthSetLogRecordQueryLinks on QueryBuilder<StrengthSetLogRecord,
    StrengthSetLogRecord, QFilterCondition> {}

extension StrengthSetLogRecordQuerySortBy
    on QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QSortBy> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByPerformedReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedReps', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByPerformedRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedReps', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByPerformedWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedWeight', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByPerformedWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedWeight', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortBySetIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      sortByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension StrengthSetLogRecordQuerySortThenBy
    on QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QSortThenBy> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByPerformedReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedReps', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByPerformedRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedReps', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByPerformedWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedWeight', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByPerformedWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'performedWeight', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenBySetIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.desc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByWorkoutSessionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.asc);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QAfterSortBy>
      thenByWorkoutSessionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutSessionId', Sort.desc);
    });
  }
}

extension StrengthSetLogRecordQueryWhereDistinct
    on QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct> {
  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByExerciseTemplateId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseTemplateId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByPerformedReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performedReps');
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByPerformedWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'performedWeight');
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setIndex');
    });
  }

  QueryBuilder<StrengthSetLogRecord, StrengthSetLogRecord, QDistinct>
      distinctByWorkoutSessionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutSessionId',
          caseSensitive: caseSensitive);
    });
  }
}

extension StrengthSetLogRecordQueryProperty on QueryBuilder<
    StrengthSetLogRecord, StrengthSetLogRecord, QQueryProperty> {
  QueryBuilder<StrengthSetLogRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<StrengthSetLogRecord, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<StrengthSetLogRecord, String, QQueryOperations>
      exerciseTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseTemplateId');
    });
  }

  QueryBuilder<StrengthSetLogRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StrengthSetLogRecord, bool, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<StrengthSetLogRecord, int?, QQueryOperations>
      performedRepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performedReps');
    });
  }

  QueryBuilder<StrengthSetLogRecord, double?, QQueryOperations>
      performedWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'performedWeight');
    });
  }

  QueryBuilder<StrengthSetLogRecord, int, QQueryOperations> setIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setIndex');
    });
  }

  QueryBuilder<StrengthSetLogRecord, String, QQueryOperations>
      workoutSessionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutSessionId');
    });
  }
}
