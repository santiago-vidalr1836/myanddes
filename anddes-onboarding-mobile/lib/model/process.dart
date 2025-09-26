import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

part 'process.g.dart';

@JsonSerializable(explicitToJson: true)
class Process extends MapeableEntity {
  int id;
  DateTime? startDate;
  int? status;
  List<String>? results;

  bool? finished;
  bool? delayed;
  bool? welcomed;
  String? hourOnsite;
  String? placeOnsite;
  String? hourRemote;
  String? linkRemote;

  Process(
      {required this.id,
      this.startDate,
      this.status,
      this.results,
      this.finished,
      this.delayed,
      this.welcomed,
      this.hourOnsite,
      this.placeOnsite,
      this.hourRemote,
      this.linkRemote});

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessToJson(this);

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'startDate': startDate?.toIso8601String(),
      'status': status,
      'finished': finished!=null && finished!?1:0,
      'delayed': delayed!=null && delayed!?1:0,
      'welcomed': welcomed!=null && welcomed!?1:0,
      'hourOnsite': hourOnsite,
      'placeOnsite': placeOnsite,
      'hourRemote': hourRemote,
      'linkRemote': linkRemote
    };
  }

  @override
  int getId() {
    return id;
  }
}
