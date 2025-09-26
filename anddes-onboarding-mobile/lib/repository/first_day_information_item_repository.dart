import 'package:mi_anddes_mobile_app/model/first_day_information_item.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class FirstDayInformationItemRepository
    extends BaseRepository<FirstDayInformationItem> {
  @override
  String tableName = "first_day_information_item";

  @override
  List<FirstDayInformationItem>? mapQueryToEntities(
      List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'title': title as String?,
            'description': description as String?,
            'body': body as String?,
            'addFromServices': addFromServices as int?,
            'type': type as String?,
            'icon': icon as String?
          } in map)
        FirstDayInformationItem(
            id: id,
            title: title,
            description: description,
            body: body,
            addFromServices: addFromServices == 1,
            type: type,
            icon: icon)
    ];
  }

  @override
  FirstDayInformationItem? mapQueryToEntity(List<Map<String, Object?>> map) {
    FirstDayInformationItem? firstDayInformationItem;
    for (final {
          'id': id as int,
          'title': title as String?,
          'description': description as String?,
          'body': body as String?,
          'addFromServices': addFromServices as int?,
          'type': type as String?,
          'icon': icon as String?
        } in map) {
      firstDayInformationItem = FirstDayInformationItem(
          id: id,
          title: title,
          description: description,
          body: body,
          addFromServices: addFromServices == 1,
          type: type,
          icon: icon);
    }
    return firstDayInformationItem;
  }
}
