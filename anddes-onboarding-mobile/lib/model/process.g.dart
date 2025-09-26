// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Process _$ProcessFromJson(Map<String, dynamic> json) => Process(
      id: (json['id'] as num).toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      status: (json['status'] as num?)?.toInt(),
      results:
          (json['results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      finished: json['finished'] as bool?,
      delayed: json['delayed'] as bool?,
      welcomed: json['welcomed'] as bool?,
      hourOnsite: json['hourOnsite'] as String?,
      placeOnsite: json['placeOnsite'] as String?,
      hourRemote: json['hourRemote'] as String?,
      linkRemote: json['linkRemote'] as String?,
    );

Map<String, dynamic> _$ProcessToJson(Process instance) => <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate?.toIso8601String(),
      'status': instance.status,
      'results': instance.results,
      'finished': instance.finished,
      'delayed': instance.delayed,
      'welcomed': instance.welcomed,
      'hourOnsite': instance.hourOnsite,
      'placeOnsite': instance.placeOnsite,
      'hourRemote': instance.hourRemote,
      'linkRemote': instance.linkRemote,
    };
