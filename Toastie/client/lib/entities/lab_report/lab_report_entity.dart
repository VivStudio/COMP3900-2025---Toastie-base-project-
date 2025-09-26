import 'package:json_annotation/json_annotation.dart';

part 'lab_report_entity.g.dart';

enum ReportType {
  @JsonValue('imaging')
  imaging,

  @JsonValue('lab')
  lab,

  @JsonValue('other')
  other,
}

// A structure to store reminder info
@JsonSerializable(includeIfNull: false)
class LabReportEntity {
  LabReportEntity({
    this.id,
    this.user_id,
    this.date_time,
    this.type,
    this.name,
    this.notes,
    this.summary,
    this.photo_ids,
    this.referred_by,
    this.examined_by,
  });

  factory LabReportEntity.fromJson(Map<String, dynamic> json) =>
      _$LabReportEntityFromJson(json);

  int? id;
  String? user_id;
  int? date_time;
  ReportType? type;
  String? name;
  String? notes;
  String? summary;
  List<String>? photo_ids;
  String? referred_by;
  String? examined_by;

  void update({
    int? date_time,
    ReportType? type,
    String? name,
    String? notes,
    String? summary,
    List<String>? photo_ids,
    String? referred_by,
    String? examined_by,
  }) {
    if (date_time != null) this.date_time = date_time;
    if (type != null) this.type = type;
    if (name != null) this.name = name;
    if (notes != null) this.notes = notes;
    if (summary != null) this.summary = summary;
    if (photo_ids != null) this.photo_ids = photo_ids;
    if (referred_by != null) this.referred_by = referred_by;
    if (examined_by != null) this.examined_by = examined_by;
  }

  Map<String, dynamic> toJson() {
    return _$LabReportEntityToJson(this);
  }
}
