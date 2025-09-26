import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';


@JsonSerializable(explicitToJson: true)
class ProcessActivityContentCardAnswer extends MapeableEntity{
  int id;
  int? processId;
  int? processActivityId;
  int? processActivityContentId;
  DateTime? readDateMobile;
  ELearningContentCardOption? answer;
  bool sent;

  ProcessActivityContentCardAnswer({required this.id,this.processId,this.processActivityId,this.processActivityContentId, required this.readDateMobile,required this.answer,required this.sent});

  static fromJson(Map<String, dynamic> json) => ProcessActivityContentCardAnswer(
    id: json['id'] as int,
    readDateMobile: json['readDateMobile'] as DateTime?,
    answer: json['answer'] == null ? null
      : ELearningContentCardOption.fromJson(json['answer'] as Map<String, dynamic>),
    sent: false
  );
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id':id,
    'readDateMobile': readDateMobile,
    'answer': answer?.toJson()
  };

  @override
  int getId() {
    return id;
  }

  @override
  Map<String, dynamic> toTableMap() {
    return {
      'id':id,
      'processId': processId,
      'processActivityId': processActivityId,
      'processActivityContentId': processActivityContentId,
      'eLearningContentCardOption': answer?.id,
      'readDateMobile': readDateMobile?.toIso8601String(),
      'sent':sent?1:0
    };
  }
}
