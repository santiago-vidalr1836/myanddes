import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

part 'service.g.dart';

@JsonSerializable(explicitToJson: true)
class Service extends MapeableEntity {
  int id;
  String? name;
  String? description;
  String? icon;
  List<ServiceDetail>? details;
  int? position;
  Service(
      {required this.id, this.name, this.description, this.icon, this.details,this.position});

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  Map<String, Object?> toTableMap() {
    return {'id': id, 'name': name, 'description': description, 'icon': icon,'position':position};
  }

  @override
  int getId() {
    return id;
  }
}

@JsonSerializable(explicitToJson: true)
class ServiceDetail extends MapeableEntityWithParentId {
  int id;
  String? description;
  String? title;
  bool? hidden;
  String? icon;


  ServiceDetail({required this.id, this.description, this.title,this.icon,this.hidden});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailToJson(this);

  @override
  Map<String, Object?> toTableMap(int serviceId) {
    return {
      'id': id,
      'description': description,
      'title': title,
      'service_id': serviceId,
      'hidden': hidden!=null && hidden!?1:0,
      'icon':icon
    };
  }

  @override
  int getId() {
    return id;
  }
}
