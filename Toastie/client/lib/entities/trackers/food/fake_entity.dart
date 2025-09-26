import 'package:json_annotation/json_annotation.dart';

part 'fake_entity.g.dart';

class IngredientDetails {
  IngredientDetails({required this.log_id, required this.name});

  final int log_id;
  final String name;
}

@JsonSerializable(includeIfNull: false)
class FakeEntity {
  FakeEntity({
    this.log_id,
    this.ingredient_details,
  });

  factory FakeEntity.fromJson(Map<String, dynamic> json) =>
      _$FakeEntityFromJson(json);

  final int? log_id;
  List<Map<String, dynamic>>? ingredient_details;

  Map<String, dynamic> toJson() {
    return _$FakeEntityToJson(this);
  }
}
