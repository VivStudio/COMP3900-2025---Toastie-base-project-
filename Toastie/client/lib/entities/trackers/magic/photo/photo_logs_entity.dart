import 'package:json_annotation/json_annotation.dart';

part 'photo_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class PhotoLogsEntity {
  PhotoLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.photo_id,
  });

  factory PhotoLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$PhotoLogsEntityFromJson(json);
  String? user_id;
  int? log_id;
  int? date_time;
  String? photo_id;

  Map<String, dynamic> toJson() {
    return _$PhotoLogsEntityToJson(this);
  }
}
