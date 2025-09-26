import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class Tool extends MapeableEntity {
  int id;
  String? name;
  String? description;
  String? link;
  String? cover;

  Tool({required this.id, this.name, this.description, this.link, this.cover});

  Tool.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        link = json["link"],
        cover = json["cover"];

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'link': link,
      'cover': cover
    };
  }

  @override
  String toString() {
    return 'Tool{id: $id, name: $name, description: $description, link: $link , cover $cover}';
  }

  @override
  int getId() {
    return id;
  }
}
