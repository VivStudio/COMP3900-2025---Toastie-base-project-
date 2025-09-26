import 'package:json_annotation/json_annotation.dart';

part 'meal_log_entity.g.dart';

enum MealType {
  @JsonValue('breakfast')
  breakfast,

  @JsonValue('lunch')
  lunch,

  @JsonValue('dinner')
  dinner,

  @JsonValue('snack')
  snack,
}

@JsonSerializable()
class IngredientDetails {
  IngredientDetails({
    required this.log_id,
    required this.name,
  });

  factory IngredientDetails.fromJson(Map<String, dynamic> json) =>
      _$IngredientDetailsFromJson(json);

  final int log_id;
  final String name;

  Map<String, dynamic> toJson() {
    return _$IngredientDetailsToJson(this);
  }

  @override
  String toString() {
    return 'IngredientDetails log_id:$log_id, name:$name';
  }
}

@JsonSerializable(includeIfNull: false)
class MealLogEntity {
  MealLogEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.type,
    this.name,
    this.ingredient_details,
    this.dish_ids,
    this.photo_ids,
  });

  factory MealLogEntity.fromJson(Map<String, dynamic> json) =>
      _$MealLogEntityFromJson(json);
  final String? user_id;
  final int? log_id;
  int? date_time;
  MealType? type;
  String? name;
  List<IngredientDetails>? ingredient_details;
  List<int>? dish_ids;
  // Currently, this supports a list of photo_ids, but the implementation is limited to handling single photo uploads, storage, modification, and display. Refactoring will be necessary to fully support multiple photo_ids if required in the future.
  List<String>? photo_ids;

  Map<String, dynamic> toJson() {
    return _$MealLogEntityToJson(this);
  }

  void update({
    int? date_time,
    MealType? type,
    String? name,
    List<IngredientDetails>? ingredient_details,
    List<int>? dish_ids,
    List<String>? photo_ids,
  }) {
    if (date_time != null) this.date_time = date_time;
    if (type != null) this.type = type;
    if (name != null) this.name = name;
    if (ingredient_details != null)
      this.ingredient_details = ingredient_details;
    if (dish_ids != null) this.dish_ids = dish_ids;
    if (photo_ids != null) this.photo_ids = photo_ids;
  }

  @override
  String toString() {
    return 'MealLogEntity log_id:$log_id date_time:$date_time type:$type name:$name ingredient_details:$ingredient_details dish_ids:$dish_ids photo_ids:$photo_ids';
  }
}
