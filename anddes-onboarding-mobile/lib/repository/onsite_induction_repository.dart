import 'package:mi_anddes_mobile_app/model/onsite_induction.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class OnsiteInductionRepository extends BaseRepository<OnsiteInduction> {
  @override
  String tableName = 'onsite_induction';

  @override
  List<OnsiteInduction>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {'id': id as int, 'description': description as String} in map)
        OnsiteInduction(id: id, description: description)
    ];
  }

  @override
  OnsiteInduction? mapQueryToEntity(List<Map<String, Object?>> map) {
    OnsiteInduction? onsiteInduction;
    for (final {'id': id as int, 'description': description as String} in map) {
      onsiteInduction = OnsiteInduction(id: id, description: description);
    }
    return onsiteInduction;
  }
}
