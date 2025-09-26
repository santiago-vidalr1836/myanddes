import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

import 'elearning_content_card.dart';

class ELearningContent extends MapeableEntity {
  int id;
  String? name;
  String? image;
  List<ELearningContentCard>? cards;
  bool? started;
  bool? finished;
  int? progress;
  int? result;
  bool? sent;
  int? position;

  ELearningContent(
      {required this.id,
      this.name,
      this.image,
      this.cards,
      this.finished,
      this.started,
      this.progress,
      this.result,
      this.sent,
      this.position});

  static fromJson(Map<String, dynamic> json) => ELearningContent(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      finished: json['finished']!=null ? json['finished'] as bool? : false,
      started: json['started']!=null ? json['started'] as bool? : false,
      progress: json['progress']!=null ? json['progress'] as int? : 0,
      result: json['result']!=null ? json['result'] as int? : 0,
      sent: json['sent']!=null ? json['sent'] as bool? : false,
      position: json['position']!=null?json['position'] as int?:null,
      cards: (json['cards'] as List<dynamic>?)
          ?.map((e) => ELearningContentCard.fromJson(e as Map<String, dynamic>)
              as ELearningContentCard)
          .toList());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'image': image,
        'finished': finished,
        'started': started??false,
        'progress':progress??0,
        'result':result??0,
        'sent':sent??false,
        'position':position,
        'cards': cards?.map((c) => c.toJson()).toList(),
      };

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'finished': finished!=null && finished!?1:0,
      'started': started!=null && started!?1:0,
      'progress':progress??0,
      'result':result??0,
      'position':position,
      'sent':sent!=null && sent!?1:0
    };
  }

  @override
  int getId() {
    return id;
  }
}
