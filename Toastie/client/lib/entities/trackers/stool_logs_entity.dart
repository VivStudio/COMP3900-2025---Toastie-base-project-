import 'package:json_annotation/json_annotation.dart';

part 'stool_logs_entity.g.dart';

enum BristolScale {
  @JsonValue('type1')
  type1,

  @JsonValue('type2')
  type2,

  @JsonValue('type3')
  type3,

  @JsonValue('type4')
  type4,

  @JsonValue('type5')
  type5,

  @JsonValue('type6')
  type6,

  @JsonValue('type7')
  type7,
}

@JsonSerializable(includeIfNull: false)
class StoolLogsEntity {
  StoolLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.severity,
  });

  factory StoolLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$StoolLogsEntityFromJson(json);

  final String? user_id;
  final int? log_id;
  int? date_time;
  BristolScale? severity;

  Map<String, dynamic> toJson() {
    return _$StoolLogsEntityToJson(this);
  }

  void update({int? date_time, String? name, BristolScale? severity}) {
    if (date_time != null) this.date_time = date_time;
    if (severity != null) this.severity = severity;
  }

  @override
  String toString() {
    return 'StoolLogsEntity log_id:$log_id, date_time:$date_time severity:$severity';
  }
}
