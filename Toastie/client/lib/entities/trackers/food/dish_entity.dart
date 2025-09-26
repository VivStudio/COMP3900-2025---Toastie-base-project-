import 'package:json_annotation/json_annotation.dart';

part 'dish_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class DishEntity {
  DishEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.name,
    this.summary,
    this.ingredient_ids,
  });

  factory DishEntity.fromJson(Map<String, dynamic> json) =>
      _$DishEntityFromJson(json);
  final String? user_id;
  final int? log_id;
  int? date_time;
  String? name;
  String? summary;
  List<int>? ingredient_ids;

  Map<String, dynamic> toJson() {
    return _$DishEntityToJson(this);
  }
}
