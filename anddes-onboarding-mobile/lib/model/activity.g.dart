// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      parent: json['parent'] as String?,
      parentCode: json['parentCode'] as String?,
      manual: json['manual'] as bool?,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'parent': instance.parent,
      'parentCode': instance.parentCode,
      'manual': instance.manual,
    };
