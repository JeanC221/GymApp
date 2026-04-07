// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strength_template_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStrengthTemplateRecordCollection on Isar {
  IsarCollection<StrengthTemplateRecord> get strengthTemplateRecords =>
      this.collection();
}

const StrengthTemplateRecordSchema = CollectionSchema(
  name: r'StrengthTemplateRecord',
  id: -3330029165460019632,
  properties: {
    r'exerciseTemplateId': PropertySchema(
      id: 0,
      name: r'exerciseTemplateId',
      type: IsarType.string,
    ),
    r'targetReps': PropertySchema(
      id: 1,
      name: r'targetReps',
      type: IsarType.long,
    ),
    r'targetSets': PropertySchema(
      id: 2,
      name: r'targetSets',
      type: IsarType.long,
    )
  },
  estimateSize: _strengthTemplateRecordEstimateSize,
  serialize: _strengthTemplateRecordSerialize,
  deserialize: _strengthTemplateRecordDeserialize,
  deserializeProp: _strengthTemplateRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'exerciseTemplateId': IndexSchema(
      id: 4487856677418974640,
      name: r'exerciseTemplateId',
      unique: true,
      replace: true,
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
  getId: _strengthTemplateRecordGetId,
  getLinks: _strengthTemplateRecordGetLinks,
  attach: _strengthTemplateRecordAttach,
  version: '3.1.0+1',
);

int _strengthTemplateRecordEstimateSize(
  StrengthTemplateRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciseTemplateId.length * 3;
  return bytesCount;
}

void _strengthTemplateRecordSerialize(
  StrengthTemplateRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.exerciseTemplateId);
  writer.writeLong(offsets[1], object.targetReps);
  writer.writeLong(offsets[2], object.targetSets);
}

StrengthTemplateRecord _strengthTemplateRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StrengthTemplateRecord();
  object.exerciseTemplateId = reader.readString(offsets[0]);
  object.isarId = id;
  object.targetReps = reader.readLong(offsets[1]);
  object.targetSets = reader.readLong(offsets[2]);
  return object;
}

P _strengthTemplateRecordDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _strengthTemplateRecordGetId(StrengthTemplateRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _strengthTemplateRecordGetLinks(
    StrengthTemplateRecord object) {
  return [];
}

void _strengthTemplateRecordAttach(
    IsarCollection<dynamic> col, Id id, StrengthTemplateRecord object) {
  object.isarId = id;
}

extension StrengthTemplateRecordByIndex
    on IsarCollection<StrengthTemplateRecord> {
  Future<StrengthTemplateRecord?> getByExerciseTemplateId(
      String exerciseTemplateId) {
    return getByIndex(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  StrengthTemplateRecord? getByExerciseTemplateIdSync(
      String exerciseTemplateId) {
    return getByIndexSync(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  Future<bool> deleteByExerciseTemplateId(String exerciseTemplateId) {
    return deleteByIndex(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  bool deleteByExerciseTemplateIdSync(String exerciseTemplateId) {
    return deleteByIndexSync(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  Future<List<StrengthTemplateRecord?>> getAllByExerciseTemplateId(
      List<String> exerciseTemplateIdValues) {
    final values = exerciseTemplateIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'exerciseTemplateId', values);
  }

  List<StrengthTemplateRecord?> getAllByExerciseTemplateIdSync(
      List<String> exerciseTemplateIdValues) {
    final values = exerciseTemplateIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'exerciseTemplateId', values);
  }

  Future<int> deleteAllByExerciseTemplateId(
      List<String> exerciseTemplateIdValues) {
    final values = exerciseTemplateIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'exerciseTemplateId', values);
  }

  int deleteAllByExerciseTemplateIdSync(List<String> exerciseTemplateIdValues) {
    final values = exerciseTemplateIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'exerciseTemplateId', values);
  }

  Future<Id> putByExerciseTemplateId(StrengthTemplateRecord object) {
    return putByIndex(r'exerciseTemplateId', object);
  }

  Id putByExerciseTemplateIdSync(StrengthTemplateRecord object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'exerciseTemplateId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExerciseTemplateId(
      List<StrengthTemplateRecord> objects) {
    return putAllByIndex(r'exerciseTemplateId', objects);
  }

  List<Id> putAllByExerciseTemplateIdSync(List<StrengthTemplateRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'exerciseTemplateId', objects,
        saveLinks: saveLinks);
  }
}

extension StrengthTemplateRecordQueryWhereSort
    on QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QWhere> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StrengthTemplateRecordQueryWhere on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QWhereClause> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterWhereClause> exerciseTemplateIdEqualTo(String exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseTemplateId',
        value: [exerciseTemplateId],
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
          QAfterWhereClause>
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

extension StrengthTemplateRecordQueryFilter on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QFilterCondition> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> exerciseTemplateIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> exerciseTemplateIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
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

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetRepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetRepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetRepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetReps',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetRepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetSetsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetSetsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetSetsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord,
      QAfterFilterCondition> targetSetsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StrengthTemplateRecordQueryObject on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QFilterCondition> {}

extension StrengthTemplateRecordQueryLinks on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QFilterCondition> {}

extension StrengthTemplateRecordQuerySortBy
    on QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QSortBy> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByTargetRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.desc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      sortByTargetSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.desc);
    });
  }
}

extension StrengthTemplateRecordQuerySortThenBy on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QSortThenBy> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByTargetRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.desc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.asc);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QAfterSortBy>
      thenByTargetSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.desc);
    });
  }
}

extension StrengthTemplateRecordQueryWhereDistinct
    on QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QDistinct> {
  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QDistinct>
      distinctByExerciseTemplateId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseTemplateId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QDistinct>
      distinctByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetReps');
    });
  }

  QueryBuilder<StrengthTemplateRecord, StrengthTemplateRecord, QDistinct>
      distinctByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetSets');
    });
  }
}

extension StrengthTemplateRecordQueryProperty on QueryBuilder<
    StrengthTemplateRecord, StrengthTemplateRecord, QQueryProperty> {
  QueryBuilder<StrengthTemplateRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<StrengthTemplateRecord, String, QQueryOperations>
      exerciseTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseTemplateId');
    });
  }

  QueryBuilder<StrengthTemplateRecord, int, QQueryOperations>
      targetRepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetReps');
    });
  }

  QueryBuilder<StrengthTemplateRecord, int, QQueryOperations>
      targetSetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetSets');
    });
  }
}
