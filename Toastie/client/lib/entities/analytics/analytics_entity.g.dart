// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsEntity _$AnalyticsEntityFromJson(Map<String, dynamic> json) =>
    AnalyticsEntity(
      user_id: json['user_id'] as String?,
      event_id: (json['event_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      event_name: json['event_name'] as String?,
      page_name: $enumDecodeNullable(_$PageNameEnumMap, json['page_name']),
      subpage_name:
          $enumDecodeNullable(_$SubpageNameEnumMap, json['subpage_name']),
    );

Map<String, dynamic> _$AnalyticsEntityToJson(AnalyticsEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.event_id case final value?) 'event_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.event_name case final value?) 'event_name': value,
      if (_$PageNameEnumMap[instance.page_name] case final value?)
        'page_name': value,
      if (_$SubpageNameEnumMap[instance.subpage_name] case final value?)
        'subpage_name': value,
    };

const _$PageNameEnumMap = {
  PageName.home: 'home',
  PageName.magic: 'magic',
  PageName.symptoms: 'symptoms',
  PageName.medication: 'medication',
  PageName.food: 'food',
  PageName.stool: 'stool',
  PageName.period: 'period',
  PageName.weight: 'weight',
  PageName.notes: 'notes',
};

const _$SubpageNameEnumMap = {
  SubpageName.search: 'search',
  SubpageName.summary: 'summary',
};
