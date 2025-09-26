// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientDetails _$IngredientDetailsFromJson(Map<String, dynamic> json) =>
    IngredientDetails(
      log_id: (json['log_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$IngredientDetailsToJson(IngredientDetails instance) =>
    <String, dynamic>{
      'log_id': instance.log_id,
      'name': instance.name,
    };

MealLogEntity _$MealLogEntityFromJson(Map<String, dynamic> json) =>
    MealLogEntity(
      user_id: json['user_id'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      date_time: (json['date_time'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$MealTypeEnumMap, json['type']),
      name: json['name'] as String?,
      ingredient_details: (json['ingredient_details'] as List<dynamic>?)
          ?.map((e) => IngredientDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      dish_ids: (json['dish_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      photo_ids: (json['photo_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MealLogEntityToJson(MealLogEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.log_id case final value?) 'log_id': value,
      if (instance.date_time case final value?) 'date_time': value,
      if (_$MealTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.name case final value?) 'name': value,
      if (instance.ingredient_details case final value?)
        'ingredient_details': value,
      if (instance.dish_ids case final value?) 'dish_ids': value,
      if (instance.photo_ids case final value?) 'photo_ids': value,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};
