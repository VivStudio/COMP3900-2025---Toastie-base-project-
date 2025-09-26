// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_logs_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteLogsEntity _$NoteLogsEntityFromJson(Map<String, dynamic> json) =>
    NoteLogsEntity(
      user_id: json['user_id'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$NoteLogsEntityToJson(NoteLogsEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.note case final value?) 'note': value,
    };
