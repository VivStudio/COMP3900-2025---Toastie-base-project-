// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_logs_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodLogsEntity _$PeriodLogsEntityFromJson(Map<String, dynamic> json) =>
    PeriodLogsEntity(
      user_id: json['user_id'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      severity: $enumDecodeNullable(_$PeriodFlowEnumMap, json['severity']),
      period_id: (json['period_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PeriodLogsEntityToJson(PeriodLogsEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (_$PeriodFlowEnumMap[instance.severity] case final value?)
        'severity': value,
      if (instance.period_id case final value?) 'period_id': value,
    };

const _$PeriodFlowEnumMap = {
  PeriodFlow.spotting: 'spotting',
  PeriodFlow.light: 'light',
  PeriodFlow.medium: 'medium',
  PeriodFlow.heavy: 'heavy',
};
