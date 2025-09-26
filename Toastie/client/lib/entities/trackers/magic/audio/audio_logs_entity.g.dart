// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_logs_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioLogsEntity _$AudioLogsEntityFromJson(Map<String, dynamic> json) =>
    AudioLogsEntity(
      user_id: json['user_id'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      audio_id: json['audio_id'] as String?,
    );

Map<String, dynamic> _$AudioLogsEntityToJson(AudioLogsEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.audio_id case final value?) 'audio_id': value,
    };
