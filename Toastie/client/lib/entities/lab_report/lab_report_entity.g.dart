// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_report_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabReportEntity _$LabReportEntityFromJson(Map<String, dynamic> json) =>
    LabReportEntity(
      id: (json['id'] as num?)?.toInt(),
      user_id: json['user_id'] as String?,
      date_time: (json['date_time'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$ReportTypeEnumMap, json['type']),
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      summary: json['summary'] as String?,
      photo_ids: (json['photo_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      referred_by: json['referred_by'] as String?,
      examined_by: json['examined_by'] as String?,
    );

Map<String, dynamic> _$LabReportEntityToJson(LabReportEntity instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (_$ReportTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.name case final value?) 'name': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.summary case final value?) 'summary': value,
      if (instance.photo_ids case final value?) 'photo_ids': value,
      if (instance.referred_by case final value?) 'referred_by': value,
      if (instance.examined_by case final value?) 'examined_by': value,
    };

const _$ReportTypeEnumMap = {
  ReportType.imaging: 'imaging',
  ReportType.lab: 'lab',
  ReportType.other: 'other',
};
