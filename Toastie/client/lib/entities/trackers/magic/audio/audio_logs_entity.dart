import 'package:json_annotation/json_annotation.dart';

part 'audio_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class AudioLogsEntity {
  AudioLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.audio_id,
  });

  factory AudioLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$AudioLogsEntityFromJson(json);
  String? user_id;
  int? log_id;
  int? date_time;
  String? audio_id;

  Map<String, dynamic> toJson() {
    return _$AudioLogsEntityToJson(this);
  }
}
