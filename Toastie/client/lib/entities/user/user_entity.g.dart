// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      user_id: json['user_id'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      sign_up_date_time: (json['sign_up_date_time'] as num?)?.toInt(),
      device: $enumDecodeNullable(_$DeviceTypeEnumMap, json['device']),
      version: json['version'] as String?,
      photo_key: json['photo_key'] as String?,
      country_state: json['country_state'] as String?,
      is_subscribed: json['is_subscribed'] as bool? ?? false,
      first_subscription_date:
          (json['first_subscription_date'] as num?)?.toInt(),
      last_time_used_the_app_date:
          (json['last_time_used_the_app_date'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      if (instance.user_id case final value?) 'user_id': value,
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.sign_up_date_time case final value?)
        'sign_up_date_time': value,
      if (_$DeviceTypeEnumMap[instance.device] case final value?)
        'device': value,
      if (instance.version case final value?) 'version': value,
      if (instance.photo_key case final value?) 'photo_key': value,
      if (instance.country_state case final value?) 'country_state': value,
      'is_subscribed': instance.is_subscribed,
      if (instance.first_subscription_date case final value?)
        'first_subscription_date': value,
      if (instance.last_time_used_the_app_date case final value?)
        'last_time_used_the_app_date': value,
    };

const _$DeviceTypeEnumMap = {
  DeviceType.ios: 'ios',
  DeviceType.android: 'android',
  DeviceType.other: 'other',
};
