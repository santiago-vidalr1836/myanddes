import 'package:json_annotation/json_annotation.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_card.dart';

import '../utils/mapeable_entity.dart';

@JsonSerializable(explicitToJson: true)
class ProcessActivityContent extends MapeableEntity {
  int id;
  ELearningContent content;
  double? result;
  double? progress;
  List<ProcessActivityContentCard> cards;

  ProcessActivityContent(
      {required this.id, required this.content, this.result, this.progress,required this.cards});

  static fromJson(Map<String, dynamic> json) => ProcessActivityContent(
      id: (json['id'] as num).toInt(),
      content: json['content'] == null
          ? null
          : ELearningContent.fromJson(json['content'] as Map<String, dynamic>),
      result: json['result'] as double?,
      progress: json['progress'] as double?,
      cards: (json['cards'] as List<dynamic>).map((e) =>
      ProcessActivityContentCard.fromJson(e as Map<String, dynamic>)
      as ProcessActivityContentCard)
          .toList());

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'content': content.toJson(),
    'result':result,
    'progress': progress,
    'cards': cards.map((e) => e.toJson()).toList()
  };

  @override
  int getId() {
    return id;
  }

  @override
  Map<String, dynamic> toTableMap() {
    return {
      'id': id
    };
  }
}
