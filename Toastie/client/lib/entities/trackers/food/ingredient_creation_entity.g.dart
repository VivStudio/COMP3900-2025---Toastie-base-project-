// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_creation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientCreationEntity _$IngredientCreationEntityFromJson(
        Map<String, dynamic> json) =>
    IngredientCreationEntity(
      id: (json['id'] as num?)?.toInt(),
      ingredient_id: (json['ingredient_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      date_time: (json['date_time'] as num?)?.toInt(),
      backfilled: json['backfilled'] as bool? ?? false,
    );

Map<String, dynamic> _$IngredientCreationEntityToJson(
        IngredientCreationEntity instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.ingredient_id case final value?) 'ingredient_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (instance.backfilled case final value?) 'backfilled': value,
    };
