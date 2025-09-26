// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientEntity _$IngredientEntityFromJson(Map<String, dynamic> json) =>
    IngredientEntity(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      aliases:
          (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$IngredientEntityToJson(IngredientEntity instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.aliases case final value?) 'aliases': value,
    };
