import 'package:mi_anddes_mobile_app/model/team_member.dart';
import 'package:mi_anddes_mobile_app/utils/repository/base_repository.dart';

class TeamMemberRepository extends BaseRepository<TeamMember> {
  @override
  String tableName = 'team_member';
  @override
  var defaultOrderBy="dateCreated";

  @override
  List<TeamMember>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
            'id': id as int,
            'dni': dni as String?,
            'image': image as String?,
            'fullname': fullname as String?,
            'job': job as String?,
            'email': email as String?,
            'onItinerary': onItinerary as int?,
            'hobbies': hobbies as String?,
            'roles': roles as String?,
          } in map)
        TeamMember(
            id: id,
            dni: dni,
            image: image,
            fullname: fullname,
            job: job,
            email: email,
            onItinerary: onItinerary == 1,
            hobbies: hobbies!=null && hobbies.trim().isNotEmpty?hobbies.split(","):[],
            roles: roles?.split(",")),
    ];
  }

  @override
  TeamMember? mapQueryToEntity(List<Map<String, Object?>> map) {
    TeamMember? teamMember;
    for (final {
          'id': id as int,
          'dni': dni as String?,
          'image': image as String?,
          'fullname': fullname as String?,
          'job': job as String?,
          'email': email as String?,
          'onItinerary': onItinerary as int?,
          'hobbies': hobbies as String?,
          'roles': roles as String?,
        } in map) {
      teamMember = TeamMember(
          id: id,
          dni: dni,
          image: image,
          fullname: fullname,
          job: job,
          email: email,
          onItinerary: onItinerary == 1,
          hobbies: hobbies!=null && hobbies.trim().isNotEmpty?hobbies.split(","):[],
          roles: roles?.split(","));
    }
    return teamMember;
  }
}
