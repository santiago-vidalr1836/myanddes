import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class ELearningContentCardOption extends MapeableEntityWithParentId {
  int id;
  String? description;
  bool? correct;
  bool? checked;

  ELearningContentCardOption(
      {required this.id, this.description, this.correct,this.checked});

  static fromJson(Map<String, dynamic> json) => ELearningContentCardOption(
        id: (json['id'] as num).toInt(),
        description: json['description'] as String?,
        correct: json['correct'] as bool?,
        checked: json['checked'] as bool?
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'description': description,
        'correct': correct,
        'checked':checked??false
      };

  @override
  Map<String, Object?> toTableMap(int parentId) {
    return {
      'id': id,
      'description': description,
      'correct': correct!=null && correct!?1:0,
      'checked':checked!=null && checked!?1:0,
      'elearning_content_card_id': parentId
    };
  }

  @override
  int getId() {
    return id;
  }
}
