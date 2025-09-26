// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => ServiceDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

ServiceDetail _$ServiceDetailFromJson(Map<String, dynamic> json) =>
    ServiceDetail(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String?,
      title: json['title'] as String?,
      icon: json['icon'] as String?,
      hidden: json['hidden'] as bool?,
    );

Map<String, dynamic> _$ServiceDetailToJson(ServiceDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'hidden': instance.hidden,
      'icon': instance.icon,
    };
