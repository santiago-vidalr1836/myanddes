import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class PendingProcessActivity extends MapeableEntity{
  int id;
  int processActivityId;
  bool send;
  PendingProcessActivity({required this.id,required this.processActivityId,required this.send});

  @override
  int getId() {
    return id;
  }
  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'process_activity_id': processActivityId,
      'send': send?1:0
    };
  }
}
