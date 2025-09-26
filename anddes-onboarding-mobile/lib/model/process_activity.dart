import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

import 'activity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'process_activity.g.dart';

@JsonSerializable(explicitToJson: true)
class ProcessActivity extends MapeableEntity {
  int id;
  Activity? activity;
  bool? completed;
  DateTime? completionDate;

  ProcessActivity(
      {required this.id, this.activity, this.completed, this.completionDate});

  factory ProcessActivity.fromJson(Map<String, dynamic> json) =>
      _$ProcessActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessActivityToJson(this);

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'activity_id': activity!.id,
      'activity_code': activity?.code,
      'activity_name': activity?.name,
      'activity_parent': activity?.parent,
      'activity_parent_code': activity?.parentCode,
      'activity_manual': activity!=null && activity!.manual!=null && activity!.manual!?1:0 ,
      'completed': completed!=null && completed!?1:0,
      'completionDate': completionDate?.toIso8601String()
    };
  }

  @override
  int getId() {
    return id;
  }
}
