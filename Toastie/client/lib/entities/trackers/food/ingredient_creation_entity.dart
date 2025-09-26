import 'package:json_annotation/json_annotation.dart';

part 'ingredient_creation_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class IngredientCreationEntity {
  IngredientCreationEntity({
    this.id,
    this.ingredient_id,
    this.name,
    this.date_time,
    this.backfilled = false,
  });

  factory IngredientCreationEntity.fromJson(Map<String, dynamic> json) =>
      _$IngredientCreationEntityFromJson(json);
  final int? id;
  final int? ingredient_id;
  String? name;
  int? date_time;
  bool? backfilled;

  Map<String, dynamic> toJson() {
    return _$IngredientCreationEntityToJson(this);
  }
}
