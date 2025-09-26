import 'package:json_annotation/json_annotation.dart';

part 'period_logs_entity.g.dart';

enum PeriodFlow {
  @JsonValue('spotting')
  spotting,

  @JsonValue('light')
  light,

  @JsonValue('medium')
  medium,

  @JsonValue('heavy')
  heavy,
}

extension PeriodFlowExtension on PeriodFlow {
  String get jsonValue {
    switch (this) {
      case PeriodFlow.spotting:
        return 'spotting';
      case PeriodFlow.light:
        return 'light';
      case PeriodFlow.medium:
        return 'medium';
      case PeriodFlow.heavy:
        return 'heavy';
    }
  }
}

@JsonSerializable(includeIfNull: false)
class PeriodLogsEntity {
  PeriodLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.severity,
    this.period_id,
  });

  factory PeriodLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$PeriodLogsEntityFromJson(json);

  final String? user_id;
  final int? log_id;
  int? date_time;
  PeriodFlow? severity;
  int? period_id;

  Map<String, dynamic> toJson() {
    return _$PeriodLogsEntityToJson(this);
  }
}
