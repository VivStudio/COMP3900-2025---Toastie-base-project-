import 'package:json_annotation/json_annotation.dart';

part 'error_logs_entity.g.dart';

enum PageName {
  @JsonValue('authentication')
  authentication,

  @JsonValue('home')
  home,

  @JsonValue('magic')
  magic,

  @JsonValue('symptoms')
  symptoms,

  @JsonValue('medication')
  medication,

  @JsonValue('food')
  food,

  @JsonValue('stool')
  stool,

  @JsonValue('period')
  period,

  @JsonValue('weight')
  weight,

  @JsonValue('notes')
  notes,

  @JsonValue('insights')
  insights,

  @JsonValue('subscription')
  subscription,
}

@JsonSerializable(includeIfNull: false)
class ErrorLogsEntity {
  ErrorLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.page_name,
    this.error_message,
  });

  factory ErrorLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$ErrorLogsEntityFromJson(json);
  final String? user_id;
  final int? log_id;
  final int? date_time;
  final PageName? page_name;
  final String? error_message;

  Map<String, dynamic> toJson() => _$ErrorLogsEntityToJson(this);
}
