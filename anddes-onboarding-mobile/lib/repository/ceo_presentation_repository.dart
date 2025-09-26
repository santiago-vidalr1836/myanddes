import 'package:mi_anddes_mobile_app/model/ceo_presentation.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class CEOPresentationRepository extends BaseRepository<CEOPresentation> {
  @override
  String tableName = 'ceo_presentation';

  @override
  List<CEOPresentation> mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'urlVideo': urlVideo as String,
            'urlPoster': urlPoster as String,
          } in map)
        CEOPresentation(id: id, urlVideo: urlVideo, urlPoster: urlPoster)
    ];
  }

  @override
  CEOPresentation? mapQueryToEntity(List<Map<String, Object?>> map) {
    CEOPresentation? ceoPresentation;
    for (final {
          'id': id as int,
          'urlVideo': urlVideo as String,
          'urlPoster': urlPoster as String?,
        } in map) {
      ceoPresentation =
          CEOPresentation(id: id, urlVideo: urlVideo, urlPoster: urlPoster);
    }
    return ceoPresentation;
  }
}
