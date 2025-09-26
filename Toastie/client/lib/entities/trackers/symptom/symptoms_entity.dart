import 'package:json_annotation/json_annotation.dart';

part 'symptoms_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class SymptomsEntity {
  SymptomsEntity({
    this.id,
    this.name,
    this.aliases,
  });

  factory SymptomsEntity.fromJson(Map<String, dynamic> json) =>
      _$SymptomsEntityFromJson(json);

  final int? id;
  final String? name;
  final List<String>? aliases;

  Map<String, dynamic> toJson() {
    return _$SymptomsEntityToJson(this);
  }

  @override
  String toString() {
    return 'SymptomsEntity id:$id, name:$name aliases:$aliases';
  }
}
