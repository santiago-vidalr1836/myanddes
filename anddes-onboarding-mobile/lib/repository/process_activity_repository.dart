import 'package:mi_anddes_mobile_app/model/activity.dart';
import 'package:mi_anddes_mobile_app/model/process_activity.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class ProcessActivityRepository extends BaseRepository<ProcessActivity> {
  @override
  String tableName = 'processes_activities';

  @override
  List<ProcessActivity>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'activity_id': activity_id as int,
            'activity_code': activity_code as String,
            'activity_name': activity_name as String,
            'activity_parent': activity_parent as String,
            'activity_parent_code': activity_parentCode as String,
            'activity_manual': activity_manual as int,
            'completed': completed as int,
            'completionDate': completionDate as String?
          } in map)
        ProcessActivity(
            id: id,
            completed: completed == 1,
            completionDate: completionDate != null
                ? DateTime.tryParse(completionDate)
                : null,
            activity: Activity(
                id: activity_id,
                code: activity_code,
                name: activity_name,
                parent: activity_parent,
                parentCode: activity_parentCode,
                manual: activity_manual == 1)),
    ];
  }

  @override
  ProcessActivity? mapQueryToEntity(List<Map<String, Object?>> map) {
    ProcessActivity? processActivity;
    for (final {
          'id': id as int,
          'activity_id': activity_id as int,
          'activity_code': activity_code as String,
          'activity_name': activity_name as String,
          'activity_parent': activity_parent as String,
          'activity_parent_code': activity_parentCode as String,
          'activity_manual': activity_manual as int,
          'completed': completed as int,
          'completionDate': completionDate as String
        } in map) {
      processActivity = ProcessActivity(
          id: id,
          completed: completed == 1,
          completionDate: DateTime.tryParse(completionDate),
          activity: Activity(
              id: activity_id,
              code: activity_code,
              name: activity_name,
              parent: activity_parent,
              parentCode: activity_parentCode,
              manual: activity_manual == 1));
    }
    return processActivity;
  }

  Future<List<ProcessActivity>?> findByActivityCode(String activityCode) async {
    return super.findByFilters('activity_code = ?', [activityCode]);
  }
}
