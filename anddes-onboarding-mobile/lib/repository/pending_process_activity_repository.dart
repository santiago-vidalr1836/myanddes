import 'package:mi_anddes_mobile_app/model/pending_process_activity.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class PendingProcessActivityRepository extends BaseRepository<PendingProcessActivity> {
  @override
  String tableName = 'pending_processes_activities';

  @override
  List<PendingProcessActivity>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {'id': id as int, 'process_activity_id': processActivityId as int, 'send': send as int} in map)
        PendingProcessActivity(id: id, processActivityId: processActivityId,send:send==1)
    ];
  }

  @override
  PendingProcessActivity? mapQueryToEntity(List<Map<String, Object?>> map) {
    PendingProcessActivity? pendingProcessActivity;
    for (final {'id': id as int, 'process_activity_id': processActivityId as int, 'send': send as int} in map) {
      pendingProcessActivity = PendingProcessActivity(id: id, processActivityId: processActivityId,send:send==1);
    }
    return pendingProcessActivity;
  }
}
