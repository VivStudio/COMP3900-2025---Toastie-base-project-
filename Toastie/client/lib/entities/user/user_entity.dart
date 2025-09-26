import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

enum DeviceType {
  @JsonValue('ios')
  ios,

  @JsonValue('android')
  android,

  @JsonValue('other')
  other,
}

@JsonSerializable(includeIfNull: false)
class UserEntity {
  UserEntity({
    this.user_id,
    this.id,
    this.name,
    this.sign_up_date_time,
    this.device,
    this.version,
    this.photo_key,
    this.country_state,
    this.is_subscribed = false,
    this.first_subscription_date,
    this.last_time_used_the_app_date,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  final String? user_id;
  final int? id;
  final String? name;
  // Unix date time.
  final int? sign_up_date_time;
  final DeviceType? device;
  final String? version;
  final String? photo_key;
  final String? country_state;
  final bool is_subscribed;
  final int? first_subscription_date;
  final int? last_time_used_the_app_date;

  Map<String, dynamic> toJson() {
    return _$UserEntityToJson(this);
  }
}
