// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardio_template_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardioTemplateRecordCollection on Isar {
  IsarCollection<CardioTemplateRecord> get cardioTemplateRecords =>
      this.collection();
}

const CardioTemplateRecordSchema = CollectionSchema(
  name: r'CardioTemplateRecord',
  id: 3986805988617228358,
  properties: {
    r'cardioType': PropertySchema(
      id: 0,
      name: r'cardioType',
      type: IsarType.string,
    ),
    r'defaultDurationMinutes': PropertySchema(
      id: 1,
      name: r'defaultDurationMinutes',
      type: IsarType.long,
    ),
    r'defaultIncline': PropertySchema(
      id: 2,
      name: r'defaultIncline',
      type: IsarType.double,
    ),
    r'exerciseTemplateId': PropertySchema(
      id: 3,
      name: r'exerciseTemplateId',
      type: IsarType.string,
    )
  },
  estimateSize: _cardioTemplateRecordEstimateSize,
  serialize: _cardioTemplateRecordSerialize,
  deserialize: _cardioTemplateRecordDeserialize,
  deserializeProp: _cardioTemplateRecordDeserializeProp,
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
  getId: _cardioTemplateRecordGetId,
  getLinks: _cardioTemplateRecordGetLinks,
  attach: _cardioTemplateRecordAttach,
  version: '3.1.0+1',
);

int _cardioTemplateRecordEstimateSize(
  CardioTemplateRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardioType.length * 3;
  bytesCount += 3 + object.exerciseTemplateId.length * 3;
  return bytesCount;
}

void _cardioTemplateRecordSerialize(
  CardioTemplateRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cardioType);
  writer.writeLong(offsets[1], object.defaultDurationMinutes);
  writer.writeDouble(offsets[2], object.defaultIncline);
  writer.writeString(offsets[3], object.exerciseTemplateId);
}

CardioTemplateRecord _cardioTemplateRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardioTemplateRecord();
  object.cardioType = reader.readString(offsets[0]);
  object.defaultDurationMinutes = reader.readLongOrNull(offsets[1]);
  object.defaultIncline = reader.readDoubleOrNull(offsets[2]);
  object.exerciseTemplateId = reader.readString(offsets[3]);
  object.isarId = id;
  return object;
}

P _cardioTemplateRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cardioTemplateRecordGetId(CardioTemplateRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cardioTemplateRecordGetLinks(
    CardioTemplateRecord object) {
  return [];
}

void _cardioTemplateRecordAttach(
    IsarCollection<dynamic> col, Id id, CardioTemplateRecord object) {
  object.isarId = id;
}

extension CardioTemplateRecordByIndex on IsarCollection<CardioTemplateRecord> {
  Future<CardioTemplateRecord?> getByExerciseTemplateId(
      String exerciseTemplateId) {
    return getByIndex(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  CardioTemplateRecord? getByExerciseTemplateIdSync(String exerciseTemplateId) {
    return getByIndexSync(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  Future<bool> deleteByExerciseTemplateId(String exerciseTemplateId) {
    return deleteByIndex(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  bool deleteByExerciseTemplateIdSync(String exerciseTemplateId) {
    return deleteByIndexSync(r'exerciseTemplateId', [exerciseTemplateId]);
  }

  Future<List<CardioTemplateRecord?>> getAllByExerciseTemplateId(
      List<String> exerciseTemplateIdValues) {
    final values = exerciseTemplateIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'exerciseTemplateId', values);
  }

  List<CardioTemplateRecord?> getAllByExerciseTemplateIdSync(
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

  Future<Id> putByExerciseTemplateId(CardioTemplateRecord object) {
    return putByIndex(r'exerciseTemplateId', object);
  }

  Id putByExerciseTemplateIdSync(CardioTemplateRecord object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'exerciseTemplateId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByExerciseTemplateId(
      List<CardioTemplateRecord> objects) {
    return putAllByIndex(r'exerciseTemplateId', objects);
  }

  List<Id> putAllByExerciseTemplateIdSync(List<CardioTemplateRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'exerciseTemplateId', objects,
        saveLinks: saveLinks);
  }
}

extension CardioTemplateRecordQueryWhereSort
    on QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QWhere> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardioTemplateRecordQueryWhere
    on QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QWhereClause> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
      exerciseTemplateIdEqualTo(String exerciseTemplateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'exerciseTemplateId',
        value: [exerciseTemplateId],
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterWhereClause>
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

extension CardioTemplateRecordQueryFilter on QueryBuilder<CardioTemplateRecord,
    CardioTemplateRecord, QFilterCondition> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeEqualTo(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeGreaterThan(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeLessThan(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeBetween(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeStartsWith(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeEndsWith(
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
          QAfterFilterCondition>
      cardioTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cardioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
          QAfterFilterCondition>
      cardioTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cardioType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardioType',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> cardioTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cardioType',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultDurationMinutes',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultDurationMinutes',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultDurationMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultIncline',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultIncline',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultIncline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultIncline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultIncline',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> defaultInclineBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultIncline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> exerciseTemplateIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> exerciseTemplateIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exerciseTemplateId',
        value: '',
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord,
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
}

extension CardioTemplateRecordQueryObject on QueryBuilder<CardioTemplateRecord,
    CardioTemplateRecord, QFilterCondition> {}

extension CardioTemplateRecordQueryLinks on QueryBuilder<CardioTemplateRecord,
    CardioTemplateRecord, QFilterCondition> {}

extension CardioTemplateRecordQuerySortBy
    on QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QSortBy> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByCardioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByCardioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByDefaultDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByDefaultDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByDefaultIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultIncline', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByDefaultInclineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultIncline', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      sortByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }
}

extension CardioTemplateRecordQuerySortThenBy
    on QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QSortThenBy> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByCardioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByCardioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardioType', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByDefaultDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByDefaultDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByDefaultIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultIncline', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByDefaultInclineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultIncline', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByExerciseTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByExerciseTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseTemplateId', Sort.desc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension CardioTemplateRecordQueryWhereDistinct
    on QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QDistinct> {
  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QDistinct>
      distinctByCardioType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardioType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QDistinct>
      distinctByDefaultDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultDurationMinutes');
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QDistinct>
      distinctByDefaultIncline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultIncline');
    });
  }

  QueryBuilder<CardioTemplateRecord, CardioTemplateRecord, QDistinct>
      distinctByExerciseTemplateId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseTemplateId',
          caseSensitive: caseSensitive);
    });
  }
}

extension CardioTemplateRecordQueryProperty on QueryBuilder<
    CardioTemplateRecord, CardioTemplateRecord, QQueryProperty> {
  QueryBuilder<CardioTemplateRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CardioTemplateRecord, String, QQueryOperations>
      cardioTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardioType');
    });
  }

  QueryBuilder<CardioTemplateRecord, int?, QQueryOperations>
      defaultDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultDurationMinutes');
    });
  }

  QueryBuilder<CardioTemplateRecord, double?, QQueryOperations>
      defaultInclineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultIncline');
    });
  }

  QueryBuilder<CardioTemplateRecord, String, QQueryOperations>
      exerciseTemplateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseTemplateId');
    });
  }
}
