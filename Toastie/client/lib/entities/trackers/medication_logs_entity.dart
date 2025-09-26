import 'package:json_annotation/json_annotation.dart';

part 'medication_logs_entity.g.dart';

@JsonSerializable(includeIfNull: false)
class MedicationLogsEntity {
  MedicationLogsEntity({
    this.user_id,
    this.log_id,
    this.date_time,
    this.name,
    this.dose,
    this.quantity,
    this.schedule_id,
  });

  factory MedicationLogsEntity.fromJson(Map<String, dynamic> json) =>
      _$MedicationLogsEntityFromJson(json);
  String? user_id;
  int? log_id;
  int? date_time;
  String? name;
  String? dose;
  double? quantity;
  int? schedule_id;

  void update({
    int? date_time,
    String? name,
    String? dose,
    double? quantity,
    // Schedule ID should never be modified directly in the repositories. This is only for loading the UI.
    int? schedule_id,
  }) {
    if (date_time != null) this.date_time = date_time;
    if (name != null) this.name = name;
    if (dose != null) this.dose = dose;
    if (quantity != null) this.quantity = quantity;
    if (schedule_id != null) this.schedule_id = schedule_id;
  }

  Map<String, dynamic> toJson() {
    return _$MedicationLogsEntityToJson(this);
  }
}
