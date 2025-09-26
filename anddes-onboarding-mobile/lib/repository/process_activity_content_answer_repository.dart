import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:mi_anddes_mobile_app/model/process_activity_content_card_answer.dart';

import '../utils/repository/base_repository.dart';

class ProcessActivityContentCardAnswerRepository extends BaseRepository<ProcessActivityContentCardAnswer>{
  @override
  String tableName="process_activity_content_card_answer";

  @override
  List<ProcessActivityContentCardAnswer>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
      'id' : id as int,
      'processId': processId as int?,
      'processActivityId': processActivityId as int?,
      'processActivityContentId': processActivityContentId as int?,
      'readDateMobile': readDateMobile as String?,
      'answer': answer as int?,
      'sent': sent as int?
      } in map)
        ProcessActivityContentCardAnswer(
            id:id,
            processId: processId,
            processActivityId: processActivityId,
            processActivityContentId: processActivityContentId,
            readDateMobile: readDateMobile!=null?DateTime.tryParse(readDateMobile):null,
            answer: answer!=null?ELearningContentCardOption(id:answer):null,
            sent: sent==1),
    ];
  }

  @override
  ProcessActivityContentCardAnswer? mapQueryToEntity(List<Map<String, Object?>> map) {
    ProcessActivityContentCardAnswer? processActivityContentCardAnswer;
      for (final {
      'id' : id as int,
      'processId': processId as int?,
      'processActivityId': processActivityId as int?,
      'processActivityContentId': processActivityContentId as int?,
      'readDateMobile': readDateMobile as String?,
      'answer': answer as int?,
      'sent': sent as int?
      } in map) {
        processActivityContentCardAnswer = ProcessActivityContentCardAnswer(
            id: id,
            processId: processId,
            processActivityId: processActivityId,
            processActivityContentId: processActivityContentId,
            readDateMobile: readDateMobile != null ? DateTime.tryParse(
                readDateMobile) : null,
            answer: answer != null
                ? ELearningContentCardOption(id: answer)
                : null,
            sent: sent == 1)
        ;
      }
      return processActivityContentCardAnswer;
  }

}
