import 'package:json_annotation/json_annotation.dart';

part 'symptom_logs_entity.g.dart';

enum SymptomSeverity {
  @JsonValue('mild')
  mild,

  @JsonValue('moderate')
  moderate,

  @JsonValue('severe')
  severe,

  @JsonValue('unbearable')
  unbearable,
}

@JsonSerializable()
class SymptomDetails {
  SymptomDetails({
    required this.name,
    this.symptom_id = null,
  });

  factory SymptomDetails.fromJson(Map<String, dynamic> json) =>
      _$SymptomDetailsFromJson(json);

  final int? symptom_id;
  final String name;

  Map<String, dynamic> toJson() {
    return _$SymptomDetailsToJson(this);
  }

  @override
  String toString() {
    return 'SymptomDetails symptom_id:$symptom_id, name:$name';
  }
}

@JsonSerializable(includeIfNull: false)
class SymptomLogsEntity {
  SymptomLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.details,
    this.severity,
  });

  factory SymptomLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$SymptomLogsEntityFromJson(json);

  final String? user_id;
  final int? log_id;
  int? date_time;
  SymptomDetails? details;
  SymptomSeverity? severity;

  Map<String, dynamic> toJson() {
    return _$SymptomLogsEntityToJson(this);
  }

  void update({
    int? date_time,
    SymptomDetails? details,
    SymptomSeverity? severity,
  }) {
    if (date_time != null) this.date_time = date_time;
    if (details != null) this.details = details;
    if (severity != null) this.severity = severity;
  }

  @override
  String toString() {
    return 'SymptomLogsEntity details:{$details}, severity:$severity, dateTime:$date_time';
  }
}
