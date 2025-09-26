import 'package:json_annotation/json_annotation.dart';

part 'ingredient_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class IngredientEntity {
  IngredientEntity({
    this.id,
    this.name,
    this.aliases,
  });

  factory IngredientEntity.fromJson(Map<String, dynamic> json) =>
      _$IngredientEntityFromJson(json);
  final int? id;
  String? name;
  List<String>? aliases;

  Map<String, dynamic> toJson() {
    return _$IngredientEntityToJson(this);
  }

  @override
  String toString() {
    return 'IngredientEntity id:$id name:$name, aliases:$aliases';
  }
}
