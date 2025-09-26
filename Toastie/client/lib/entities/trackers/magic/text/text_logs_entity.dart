import 'package:json_annotation/json_annotation.dart';

part 'text_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class TextLogsEntity {
  TextLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.text,
  });

  factory TextLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$TextLogsEntityFromJson(json);
  String? user_id;
  int? log_id;
  int? date_time;
  String? text;

  Map<String, dynamic> toJson() {
    return _$TextLogsEntityToJson(this);
  }
}
