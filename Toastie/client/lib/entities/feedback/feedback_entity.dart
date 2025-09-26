import 'package:json_annotation/json_annotation.dart';

part 'feedback_entity.g.dart';

enum FeedbackType {
  @JsonValue('bug')
  bug,

  @JsonValue('featureRequest')
  featureRequest,

  @JsonValue('general')
  general,
}

@JsonSerializable(includeIfNull: false)
class FeedbackEntity {
  FeedbackEntity({
    this.id,
    this.date_time,
    this.type,
    this.details,
    this.contact,
  });

  factory FeedbackEntity.fromJson(Map<String, dynamic> json) =>
      _$FeedbackEntityFromJson(json);

  final int? id;
  int? date_time;
  final FeedbackType? type;
  final String? details;
  final String? contact;

  Map<String, dynamic> toJson() {
    return _$FeedbackEntityToJson(this);
  }

  @override
  String toString() {
    return 'FeedbackEntity id:$id, dateTime:$date_time, type:$type details:$details, contact:$contact';
  }
}
