import 'package:json_annotation/json_annotation.dart';

part 'analytics_entity.g.dart';

enum PageName {
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
}

enum SubpageName {
  @JsonValue('search')
  search,

  @JsonValue('summary')
  summary,
}

@JsonSerializable(includeIfNull: false)
class AnalyticsEntity {
  AnalyticsEntity({
    this.user_id,
    this.event_id,
    this.date_time,
    this.event_name,
    this.page_name,
    this.subpage_name,
  });

  factory AnalyticsEntity.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEntityFromJson(json);
  final String? user_id;
  final int? event_id;
  final int? date_time;
  final String? event_name;
  final PageName? page_name;
  final SubpageName? subpage_name;

  Map<String, dynamic> toJson() => _$AnalyticsEntityToJson(this);
}
