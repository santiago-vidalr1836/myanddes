import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class TeamMember extends MapeableEntity {
  int id;
  String? dni;
  String? image;
  String? fullname;
  String? job;

  String? email;
  bool? onItinerary;
  List<String>? hobbies;
  List<String>? roles;
  TeamMember(
      {required this.id,
      this.dni,
      this.image,
      this.fullname,
      this.job,
      this.email,
      this.hobbies,
      this.roles,
      this.onItinerary});

  get isBoss => roles?.contains('Jefe a Cargo');

  static fromJson(Map<String, dynamic> json) => TeamMember(
        id: (json['id'] as num).toInt(),
        dni: json['dni'] as String?,
        image: json['image'] as String?,
        fullname: json['fullname'] as String?,
        job: json['job'] as String?,
        email: json['email'] as String?,
        onItinerary: json['onItinerary'] as bool?,
        hobbies: (json['hobbies'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        roles:
            (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'dni': dni,
        'image': image,
        'fullname': fullname,
        'job': job,
        'email': email,
        'onItinerary': onItinerary,
        'hobbies': hobbies?.map((e) => e.toString()).toList(),
        'roles': roles?.map((e) => e.toString()).toList(),
      };

  @override
  Map<String, Object?> toTableMap() {
    return {
      'id': id,
      'dni': dni,
      'image': image,
      'fullname': fullname,
      'job': job,
      'email': email,
      'onItinerary': onItinerary!=null && onItinerary!?1:0,
      'hobbies': hobbies?.join(","),
      'roles': roles?.join(","),
      'dateCreated' : DateTime.now().toIso8601String()
    };
  }

  @override
  int getId() {
    return id;
  }
}
