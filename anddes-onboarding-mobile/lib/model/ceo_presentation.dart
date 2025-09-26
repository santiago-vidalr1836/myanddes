import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class CEOPresentation extends MapeableEntity {
  int id;
  String? urlVideo;
  String? urlPoster;

  CEOPresentation({required this.id, this.urlVideo, this.urlPoster});

  static fromJson(Map<String, dynamic> json) => CEOPresentation(
        id: (json['id'] as num).toInt(),
        urlVideo: json['urlVideo'] as String?,
        urlPoster: json['urlPoster'] as String?,
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'urlVideo': urlVideo, 'urlPoster': urlPoster};

  @override
  Map<String, Object?> toTableMap() {
    return {'id': id, 'urlVideo': urlVideo, 'urlPoster': urlPoster};
  }

  @override
  int getId() {
    return id;
  }
}
