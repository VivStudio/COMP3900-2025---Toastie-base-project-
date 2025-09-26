// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_creation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SymptomCreationEntity _$SymptomCreationEntityFromJson(
        Map<String, dynamic> json) =>
    SymptomCreationEntity(
      id: (json['id'] as num?)?.toInt(),
      symptom_id: (json['symptom_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      date_time: (json['date_time'] as num?)?.toInt(),
      backfilled: json['backfilled'] as bool?,
    );

Map<String, dynamic> _$SymptomCreationEntityToJson(
        SymptomCreationEntity instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.symptom_id case final value?) 'symptom_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.backfilled case final value?) 'backfilled': value,
    };
