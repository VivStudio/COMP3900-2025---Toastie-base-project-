import 'package:json_annotation/json_annotation.dart';

part 'note_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class NoteLogsEntity {
  NoteLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.note,
  });

  factory NoteLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$NoteLogsEntityFromJson(json);

  final String? user_id;
  final int? log_id;
  int? date_time;
  String? note;

  Map<String, dynamic> toJson() {
    return _$NoteLogsEntityToJson(this);
  }
}
