import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';

class User extends MapeableEntity {
  int? id;
  String? email;
  String? givenName;
  String? familyName;
  bool? onItinerary;
  String? nickname;
  List<String>? hobbies;
  String? image;

  User(
      {this.id,
      this.email,
      this.givenName,
      this.familyName,
      this.onItinerary,
      this.nickname,
      this.hobbies,
      this.image});

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        email = json["email"],
        givenName = json["givenName"],
        familyName = json["familyName"],
        onItinerary = json["onItinerary"],
        nickname = json["nickname"],
        image = json["image"],
        hobbies = (json['hobbies'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList();

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "givenName": givenName,
      "familyName": familyName,
      "onItinerary": onItinerary,
      "nickname": nickname,
      "image": image,
      'hobbies': hobbies?.map((e) => e.toString()).toList()
    };
  }

  @override
  Map<String, dynamic> toTableMap() {
    return {
      "id": id,
      "email": email,
      "givenName": givenName,
      "familyName": familyName,
      "image": image,
      "nickname" : nickname,
      "onItinerary": onItinerary!=null && onItinerary!?1:0,
      'hobbies': hobbies?.map((e) => e.toString()).toList()
    };
  }

  @override
  int getId() {
    return id!;
  }
}
