import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

import '../model/tool.dart';

class ToolRepository extends BaseRepository<Tool> {
  @override
  String tableName = 'tools';

  @override
  List<Tool>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'description': description as String,
            'link': link as String,
            'cover': cover as String?,
          } in map)
        Tool(
            id: id,
            name: name,
            description: description,
            link: link,
            cover: cover),
    ];
  }

  @override
  Tool? mapQueryToEntity(List<Map<String, Object?>> map) {
    Tool? tool;
    for (final {
          'id': id as int,
          'name': name as String,
          'description': description as String,
          'link': link as String,
          'cover': cover as String?,
        } in map) {
      tool = Tool(
          id: id,
          name: name,
          description: description,
          link: link,
          cover: cover);
    }
    return tool;
  }
}
