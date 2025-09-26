// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FakeEntity _$FakeEntityFromJson(Map<String, dynamic> json) => FakeEntity(
      log_id: (json['log_id'] as num?)?.toInt(),
      ingredient_details: (json['ingredient_details'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$FakeEntityToJson(FakeEntity instance) =>
    <String, dynamic>{
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.ingredient_details case final value?)
        'ingredient_details': value,
    };
