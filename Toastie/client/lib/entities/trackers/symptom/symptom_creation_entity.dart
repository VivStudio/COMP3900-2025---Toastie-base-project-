import 'package:json_annotation/json_annotation.dart';

part 'symptom_creation_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class SymptomCreationEntity {
  SymptomCreationEntity({
    this.id,
    this.symptom_id,
    this.name,
    this.date_time,
    this.backfilled,
  });

  factory SymptomCreationEntity.fromJson(Map<String, dynamic> json) =>
      _$SymptomCreationEntityFromJson(json);

  final int? id;
  final int? symptom_id;
  final String? name;
  final int? date_time;
  final bool? backfilled;

  Map<String, dynamic> toJson() {
    return _$SymptomCreationEntityToJson(this);
  }

  @override
  String toString() {
    return 'SymptomsEntity id:$id, symptom_id:$symptom_id name:$name date_time:$date_time backfilled:$backfilled';
  }
}
