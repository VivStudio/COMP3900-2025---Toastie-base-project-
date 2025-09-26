import 'package:json_annotation/json_annotation.dart';

part 'weight_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class WeightLogsEntity {
  WeightLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.weight,
  });

  factory WeightLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$WeightLogsEntityFromJson(json);
  final String? user_id;
  final int? log_id;
  int? date_time;
  double? weight;

  Map<String, dynamic> toJson() {
    return _$WeightLogsEntityToJson(this);
  }
}
