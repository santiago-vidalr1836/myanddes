import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity {
  int id;
  String? code;
  String? name;
  String? parent;
  String? parentCode;
  bool? manual;

  Activity(
      {required this.id,
      this.code,
      this.name,
      this.parent,
      this.parentCode,
      this.manual});

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'code': code,
      'parent': parent,
      'parentCode': parentCode,
      'manual': (manual!= null && manual!)?1:0
    };
  }
}
