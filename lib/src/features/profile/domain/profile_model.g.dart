// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileCollection on Isar {
  IsarCollection<Profile> get profiles => this.collection();
}

const ProfileSchema = CollectionSchema(
  name: r'Profile',
  id: 1266279811925214857,
  properties: {
    r'appStreak': PropertySchema(
      id: 0,
      name: r'appStreak',
      type: IsarType.long,
    ),
    r'completedAchievements': PropertySchema(
      id: 1,
      name: r'completedAchievements',
      type: IsarType.stringList,
    ),
    r'customNotificationEnabled': PropertySchema(
      id: 2,
      name: r'customNotificationEnabled',
      type: IsarType.bool,
    ),
    r'customNotificationHour': PropertySchema(
      id: 3,
      name: r'customNotificationHour',
      type: IsarType.long,
    ),
    r'customNotificationMediaPath': PropertySchema(
      id: 4,
      name: r'customNotificationMediaPath',
      type: IsarType.string,
    ),
    r'customNotificationMessage': PropertySchema(
      id: 5,
      name: r'customNotificationMessage',
      type: IsarType.string,
    ),
    r'customNotificationMinute': PropertySchema(
      id: 6,
      name: r'customNotificationMinute',
      type: IsarType.long,
    ),
    r'dailyQuotesEnabled': PropertySchema(
      id: 7,
      name: r'dailyQuotesEnabled',
      type: IsarType.bool,
    ),
    r'isCustomNotificationVideo': PropertySchema(
      id: 8,
      name: r'isCustomNotificationVideo',
      type: IsarType.bool,
    ),
    r'isDarkMode': PropertySchema(
      id: 9,
      name: r'isDarkMode',
      type: IsarType.bool,
    ),
    r'lastAppOpenDate': PropertySchema(
      id: 10,
      name: r'lastAppOpenDate',
      type: IsarType.dateTime,
    ),
    r'level': PropertySchema(
      id: 11,
      name: r'level',
      type: IsarType.long,
    ),
    r'motivationHour': PropertySchema(
      id: 12,
      name: r'motivationHour',
      type: IsarType.long,
    ),
    r'motivationMinute': PropertySchema(
      id: 13,
      name: r'motivationMinute',
      type: IsarType.long,
    ),
    r'radarLabels': PropertySchema(
      id: 14,
      name: r'radarLabels',
      type: IsarType.stringList,
    ),
    r'radarValues': PropertySchema(
      id: 15,
      name: r'radarValues',
      type: IsarType.longList,
    ),
    r'totalHabitsCompleted': PropertySchema(
      id: 16,
      name: r'totalHabitsCompleted',
      type: IsarType.long,
    ),
    r'totalJournalEntries': PropertySchema(
      id: 17,
      name: r'totalJournalEntries',
      type: IsarType.long,
    ),
    r'totalRemindersSet': PropertySchema(
      id: 18,
      name: r'totalRemindersSet',
      type: IsarType.long,
    ),
    r'totalTodosCompleted': PropertySchema(
      id: 19,
      name: r'totalTodosCompleted',
      type: IsarType.long,
    ),
    r'username': PropertySchema(
      id: 20,
      name: r'username',
      type: IsarType.string,
    ),
    r'xp': PropertySchema(
      id: 21,
      name: r'xp',
      type: IsarType.long,
    )
  },
  estimateSize: _profileEstimateSize,
  serialize: _profileSerialize,
  deserialize: _profileDeserialize,
  deserializeProp: _profileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _profileGetId,
  getLinks: _profileGetLinks,
  attach: _profileAttach,
  version: '3.1.0+1',
);

int _profileEstimateSize(
  Profile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedAchievements.length * 3;
  {
    for (var i = 0; i < object.completedAchievements.length; i++) {
      final value = object.completedAchievements[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.customNotificationMediaPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.customNotificationMessage.length * 3;
  bytesCount += 3 + object.radarLabels.length * 3;
  {
    for (var i = 0; i < object.radarLabels.length; i++) {
      final value = object.radarLabels[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.radarValues.length * 8;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _profileSerialize(
  Profile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appStreak);
  writer.writeStringList(offsets[1], object.completedAchievements);
  writer.writeBool(offsets[2], object.customNotificationEnabled);
  writer.writeLong(offsets[3], object.customNotificationHour);
  writer.writeString(offsets[4], object.customNotificationMediaPath);
  writer.writeString(offsets[5], object.customNotificationMessage);
  writer.writeLong(offsets[6], object.customNotificationMinute);
  writer.writeBool(offsets[7], object.dailyQuotesEnabled);
  writer.writeBool(offsets[8], object.isCustomNotificationVideo);
  writer.writeBool(offsets[9], object.isDarkMode);
  writer.writeDateTime(offsets[10], object.lastAppOpenDate);
  writer.writeLong(offsets[11], object.level);
  writer.writeLong(offsets[12], object.motivationHour);
  writer.writeLong(offsets[13], object.motivationMinute);
  writer.writeStringList(offsets[14], object.radarLabels);
  writer.writeLongList(offsets[15], object.radarValues);
  writer.writeLong(offsets[16], object.totalHabitsCompleted);
  writer.writeLong(offsets[17], object.totalJournalEntries);
  writer.writeLong(offsets[18], object.totalRemindersSet);
  writer.writeLong(offsets[19], object.totalTodosCompleted);
  writer.writeString(offsets[20], object.username);
  writer.writeLong(offsets[21], object.xp);
}

Profile _profileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Profile();
  object.appStreak = reader.readLong(offsets[0]);
  object.completedAchievements = reader.readStringList(offsets[1]) ?? [];
  object.customNotificationEnabled = reader.readBool(offsets[2]);
  object.customNotificationHour = reader.readLong(offsets[3]);
  object.customNotificationMediaPath = reader.readStringOrNull(offsets[4]);
  object.customNotificationMessage = reader.readString(offsets[5]);
  object.customNotificationMinute = reader.readLong(offsets[6]);
  object.dailyQuotesEnabled = reader.readBool(offsets[7]);
  object.id = id;
  object.isCustomNotificationVideo = reader.readBool(offsets[8]);
  object.isDarkMode = reader.readBool(offsets[9]);
  object.lastAppOpenDate = reader.readDateTimeOrNull(offsets[10]);
  object.level = reader.readLong(offsets[11]);
  object.motivationHour = reader.readLong(offsets[12]);
  object.motivationMinute = reader.readLong(offsets[13]);
  object.radarLabels = reader.readStringList(offsets[14]) ?? [];
  object.radarValues = reader.readLongList(offsets[15]) ?? [];
  object.totalHabitsCompleted = reader.readLong(offsets[16]);
  object.totalJournalEntries = reader.readLong(offsets[17]);
  object.totalRemindersSet = reader.readLong(offsets[18]);
  object.totalTodosCompleted = reader.readLong(offsets[19]);
  object.username = reader.readString(offsets[20]);
  object.xp = reader.readLong(offsets[21]);
  return object;
}

P _profileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readStringList(offset) ?? []) as P;
    case 15:
      return (reader.readLongList(offset) ?? []) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileGetId(Profile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileGetLinks(Profile object) {
  return [];
}

void _profileAttach(IsarCollection<dynamic> col, Id id, Profile object) {
  object.id = id;
}

extension ProfileQueryWhereSort on QueryBuilder<Profile, Profile, QWhere> {
  QueryBuilder<Profile, Profile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileQueryWhere on QueryBuilder<Profile, Profile, QWhereClause> {
  QueryBuilder<Profile, Profile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProfileQueryFilter
    on QueryBuilder<Profile, Profile, QFilterCondition> {
  QueryBuilder<Profile, Profile, QAfterFilterCondition> appStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> appStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> appStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> appStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAchievements',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'completedAchievements',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'completedAchievements',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAchievements',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'completedAchievements',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      completedAchievementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedAchievements',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customNotificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customNotificationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customNotificationHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'customNotificationMediaPath',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'customNotificationMediaPath',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customNotificationMediaPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customNotificationMediaPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customNotificationMediaPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationMediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMediaPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customNotificationMediaPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customNotificationMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customNotificationMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customNotificationMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customNotificationMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customNotificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customNotificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customNotificationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      customNotificationMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customNotificationMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      dailyQuotesEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuotesEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      isCustomNotificationVideoEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustomNotificationVideo',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> isDarkModeEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDarkMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      lastAppOpenDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAppOpenDate',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      lastAppOpenDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAppOpenDate',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> lastAppOpenDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAppOpenDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      lastAppOpenDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAppOpenDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> lastAppOpenDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAppOpenDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> lastAppOpenDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAppOpenDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> levelEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> motivationHourEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motivationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      motivationHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'motivationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> motivationHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'motivationHour',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> motivationHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'motivationHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> motivationMinuteEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'motivationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      motivationMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'motivationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      motivationMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'motivationMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> motivationMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'motivationMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radarLabels',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'radarLabels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'radarLabels',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radarLabels',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'radarLabels',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> radarLabelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarLabelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarLabels',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radarValues',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radarValues',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radarValues',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radarValues',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> radarValuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      radarValuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'radarValues',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalHabitsCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalHabitsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalHabitsCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalHabitsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalHabitsCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalHabitsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalHabitsCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalHabitsCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalJournalEntriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalJournalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalJournalEntriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalJournalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalJournalEntriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalJournalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalJournalEntriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalJournalEntries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalRemindersSetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRemindersSet',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalRemindersSetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRemindersSet',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalRemindersSetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRemindersSet',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalRemindersSetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRemindersSet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalTodosCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTodosCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalTodosCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTodosCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalTodosCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTodosCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition>
      totalTodosCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTodosCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> xpEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> xpGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> xpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'xp',
        value: value,
      ));
    });
  }

  QueryBuilder<Profile, Profile, QAfterFilterCondition> xpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'xp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProfileQueryObject
    on QueryBuilder<Profile, Profile, QFilterCondition> {}

extension ProfileQueryLinks
    on QueryBuilder<Profile, Profile, QFilterCondition> {}

extension ProfileQuerySortBy on QueryBuilder<Profile, Profile, QSortBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy> sortByAppStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appStreak', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByAppStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appStreak', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationEnabled', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationEnabled', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByCustomNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationHour', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationHour', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMediaPath', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMediaPath', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMessage', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMessage', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMinute', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByCustomNotificationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMinute', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByDailyQuotesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuotesEnabled', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByDailyQuotesEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuotesEnabled', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByIsCustomNotificationVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomNotificationVideo', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByIsCustomNotificationVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomNotificationVideo', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByLastAppOpenDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAppOpenDate', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByLastAppOpenDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAppOpenDate', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMotivationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationHour', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMotivationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationHour', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMotivationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationMinute', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByMotivationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationMinute', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalHabitsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHabitsCompleted', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      sortByTotalHabitsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHabitsCompleted', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJournalEntries', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalJournalEntriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJournalEntries', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalRemindersSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRemindersSet', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalRemindersSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRemindersSet', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalTodosCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTodosCompleted', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByTotalTodosCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTodosCompleted', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> sortByXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.desc);
    });
  }
}

extension ProfileQuerySortThenBy
    on QueryBuilder<Profile, Profile, QSortThenBy> {
  QueryBuilder<Profile, Profile, QAfterSortBy> thenByAppStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appStreak', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByAppStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appStreak', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationEnabled', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationEnabled', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByCustomNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationHour', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationHour', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMediaPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMediaPath', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMediaPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMediaPath', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMessage', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMessage', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMinute', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByCustomNotificationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customNotificationMinute', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByDailyQuotesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuotesEnabled', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByDailyQuotesEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuotesEnabled', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByIsCustomNotificationVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomNotificationVideo', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByIsCustomNotificationVideoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomNotificationVideo', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByLastAppOpenDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAppOpenDate', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByLastAppOpenDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAppOpenDate', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMotivationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationHour', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMotivationHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationHour', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMotivationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationMinute', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByMotivationMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'motivationMinute', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalHabitsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHabitsCompleted', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy>
      thenByTotalHabitsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalHabitsCompleted', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJournalEntries', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalJournalEntriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalJournalEntries', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalRemindersSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRemindersSet', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalRemindersSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRemindersSet', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalTodosCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTodosCompleted', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByTotalTodosCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTodosCompleted', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.asc);
    });
  }

  QueryBuilder<Profile, Profile, QAfterSortBy> thenByXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xp', Sort.desc);
    });
  }
}

extension ProfileQueryWhereDistinct
    on QueryBuilder<Profile, Profile, QDistinct> {
  QueryBuilder<Profile, Profile, QDistinct> distinctByAppStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appStreak');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByCompletedAchievements() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAchievements');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct>
      distinctByCustomNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNotificationEnabled');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByCustomNotificationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNotificationHour');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct>
      distinctByCustomNotificationMediaPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNotificationMediaPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByCustomNotificationMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNotificationMessage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct>
      distinctByCustomNotificationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customNotificationMinute');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByDailyQuotesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyQuotesEnabled');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct>
      distinctByIsCustomNotificationVideo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustomNotificationVideo');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDarkMode');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByLastAppOpenDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAppOpenDate');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByMotivationHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'motivationHour');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByMotivationMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'motivationMinute');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByRadarLabels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radarLabels');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByRadarValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radarValues');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByTotalHabitsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalHabitsCompleted');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByTotalJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalJournalEntries');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByTotalRemindersSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRemindersSet');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByTotalTodosCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTodosCompleted');
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Profile, Profile, QDistinct> distinctByXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xp');
    });
  }
}

extension ProfileQueryProperty
    on QueryBuilder<Profile, Profile, QQueryProperty> {
  QueryBuilder<Profile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> appStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appStreak');
    });
  }

  QueryBuilder<Profile, List<String>, QQueryOperations>
      completedAchievementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAchievements');
    });
  }

  QueryBuilder<Profile, bool, QQueryOperations>
      customNotificationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNotificationEnabled');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations>
      customNotificationHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNotificationHour');
    });
  }

  QueryBuilder<Profile, String?, QQueryOperations>
      customNotificationMediaPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNotificationMediaPath');
    });
  }

  QueryBuilder<Profile, String, QQueryOperations>
      customNotificationMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNotificationMessage');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations>
      customNotificationMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customNotificationMinute');
    });
  }

  QueryBuilder<Profile, bool, QQueryOperations> dailyQuotesEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyQuotesEnabled');
    });
  }

  QueryBuilder<Profile, bool, QQueryOperations>
      isCustomNotificationVideoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustomNotificationVideo');
    });
  }

  QueryBuilder<Profile, bool, QQueryOperations> isDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDarkMode');
    });
  }

  QueryBuilder<Profile, DateTime?, QQueryOperations> lastAppOpenDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAppOpenDate');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> motivationHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'motivationHour');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> motivationMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'motivationMinute');
    });
  }

  QueryBuilder<Profile, List<String>, QQueryOperations> radarLabelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radarLabels');
    });
  }

  QueryBuilder<Profile, List<int>, QQueryOperations> radarValuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radarValues');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> totalHabitsCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalHabitsCompleted');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> totalJournalEntriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalJournalEntries');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> totalRemindersSetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRemindersSet');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> totalTodosCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTodosCompleted');
    });
  }

  QueryBuilder<Profile, String, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }

  QueryBuilder<Profile, int, QQueryOperations> xpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xp');
    });
  }
}
