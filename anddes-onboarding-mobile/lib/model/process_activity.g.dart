// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessActivity _$ProcessActivityFromJson(Map<String, dynamic> json) =>
    ProcessActivity(
      id: (json['id'] as num).toInt(),
      activity: json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      completed: json['completed'] as bool?,
      completionDate: json['completionDate'] == null
          ? null
          : DateTime.parse(json['completionDate'] as String),
    );

Map<String, dynamic> _$ProcessActivityToJson(ProcessActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activity': instance.activity?.toJson(),
      'completed': instance.completed,
      'completionDate': instance.completionDate?.toIso8601String(),
    };
