import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';

import '../utils/mapeable_entity.dart';

@JsonSerializable(explicitToJson: true)
class ProcessActivityContentCard extends MapeableEntity {
  int id;
  ELearningContentCard card;
  ELearningContentCardOption? answer;
  DateTime? readMobileDate;
  DateTime? readDateServer;
  int? points;

  ProcessActivityContentCard(
      {required this.id, required this.card, this.answer, this.readMobileDate,this.readDateServer,this.points});

  static fromJson(Map<String, dynamic> json) => ProcessActivityContentCard(
      id: (json['id'] as num).toInt(),
      card: json['card'] == null
          ? null
          : ELearningContentCard.fromJson(json['card'] as Map<String, dynamic>),
      answer: json['answer'] == null
          ? null
          : ELearningContentCardOption.fromJson(json['answer'] as Map<String, dynamic>),
      readMobileDate: json['readMobileDate']==null?null :DateTime.parse(json['readMobileDate']),
      readDateServer: json['readDateServer'] ==null?null :DateTime.parse(json['readDateServer']),
      points: json['points'] as int?);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'card': card.toJson(),
    'answer':answer?.toJson(),
    'readMobileDate': readMobileDate?.toIso8601String(),
    'readDateServer': readDateServer?.toIso8601String(),
    'points': points
  };

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id
    };
  }

  @override
  int getId() {
    return id;
  }
}
