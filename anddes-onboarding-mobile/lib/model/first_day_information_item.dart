import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class FirstDayInformationItem extends MapeableEntity {
  int id;
  String? title;
  String? description;
  String? body;
  bool? addFromServices;
  String? type;
  String? icon;

  FirstDayInformationItem(
      {required this.id,
      this.title,
      this.description,
      this.body,
      this.addFromServices,
      this.type,
      this.icon});

  static fromJson(Map<String, dynamic> json) => FirstDayInformationItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      body: json['body'] as String?,
      addFromServices: json['addFromServices'] as bool?,
      type: json['type'] as String?,
      icon: json['icon'] as String?);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'body': body,
        'addFromServices': addFromServices,
        'type': type,
        'icon': icon
      };

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'body': body,
      'addFromServices': addFromServices!=null && addFromServices!?1:0,
      'type': type,
      'icon': icon
    };
  }

  @override
  int getId() {
    return id;
  }
}
