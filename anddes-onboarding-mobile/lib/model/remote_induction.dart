import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class RemoteInduction extends MapeableEntity {
  int id;
  String? description;

  RemoteInduction({required this.id, this.description});

  static fromJson(Map<String, dynamic> json) => RemoteInduction(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String?);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'description': description};

  @override
  Map<String, Object?> toTableMap() {
    return {'id': id, 'description': description};
  }

  @override
  int getId() {
    return id;
  }
}
