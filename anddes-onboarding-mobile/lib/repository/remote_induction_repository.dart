import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

import '../model/remote_induction.dart';

class RemoteInductionRepository extends BaseRepository<RemoteInduction> {
  @override
  String tableName = 'remote_induction';

  @override
  List<RemoteInduction>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {'id': id as int, 'description': description as String} in map)
        RemoteInduction(id: id, description: description)
    ];
  }

  @override
  RemoteInduction? mapQueryToEntity(List<Map<String, Object?>> map) {
    RemoteInduction? remoteInduction;
    for (final {'id': id as int, 'description': description as String} in map) {
      remoteInduction = RemoteInduction(id: id, description: description);
    }
    return remoteInduction;
  }
}
