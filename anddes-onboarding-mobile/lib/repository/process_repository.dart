import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

import '../model/process.dart';

class ProcessRepository extends BaseRepository<Process> {
  @override
  String tableName = 'processes';

  @override
  List<Process>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'startDate': startDate as String,
            'status': status as int,
            'finished': finished as int,
            'delayed': delayed as int,
            'welcomed': welcomed as int,
            'hourOnsite': hourOnsite as String,
            'placeOnsite': placeOnsite as String,
            'hourRemote': hourRemote as String,
            'linkRemote': linkRemote as String
          } in map)
        Process(
            id: id,
            startDate: DateTime.tryParse(startDate),
            status: status,
            finished: finished == 1,
            delayed: delayed == 1,
            welcomed: welcomed == 1,
            hourOnsite: hourOnsite,
            placeOnsite: placeOnsite,
            hourRemote: hourRemote,
            linkRemote: linkRemote),
    ];
  }

  @override
  Process? mapQueryToEntity(List<Map<String, Object?>> map) {
    Process? process;
    for (final {
          'id': id as int,
          'startDate': startDate as String,
          'status': status as int,
          'finished': finished as int,
          'delayed': delayed as int,
          'welcomed': welcomed as int,
          'hourOnsite': hourOnsite as String,
          'placeOnsite': placeOnsite as String,
          'hourRemote': hourRemote as String,
          'linkRemote': linkRemote as String
        } in map) {
      process = Process(
          id: id,
          startDate: DateTime.tryParse(startDate),
          status: status,
          finished: finished == 1,
          delayed: delayed == 1,
          welcomed: welcomed == 1,
          hourOnsite: hourOnsite,
          placeOnsite: placeOnsite,
          hourRemote: hourRemote,
          linkRemote: linkRemote);
    }
    return process;
  }
}
