// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_logs_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoLogsEntity _$PhotoLogsEntityFromJson(Map<String, dynamic> json) =>
    PhotoLogsEntity(
      user_id: json['user_id'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      photo_id: json['photo_id'] as String?,
    );

Map<String, dynamic> _$PhotoLogsEntityToJson(PhotoLogsEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.photo_id case final value?) 'photo_id': value,
    };
