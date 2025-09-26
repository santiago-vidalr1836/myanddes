import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mi_anddes_mobile_app/model/user.dart';
import 'package:mi_anddes_mobile_app/service/auth_service.dart';
import 'package:mi_anddes_mobile_app/utils/exception/not_found_user_exception.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ProfileService {
  Future getRemote() async {
    final uri = Uri.parse("${Constants.baseUri}/profile");
    var accessToken = await AuthService().getAccessToken();
    final response = await http.get(uri, headers: {
      "Content-Type": 'application/json',
      "Authorization": "Bearer ${accessToken?.value ?? ""}"
    });
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      var user = User.fromJson(body);
      SharedPreferences sharedUser = await SharedPreferences.getInstance();
      await sharedUser.setString('user', jsonEncode(user.toJson()));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }else if (response.statusCode == 404) {
      throw NotFoundUserException();
    }
  }

  Future<User?> get() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String? json = sharedUser.getString('user');
    if (json != null) {
      Map<String, dynamic> userMap = jsonDecode(json);
      return User.fromJson(userMap);
    } else {
      return null;
    }
  }

  void updateProfile(User user, String nickname, String? hobbies, File? image) async{

    if(image != null){
      uploadImage(image).then((urlImage) => updateProfileEndpoint(user,nickname,hobbies,urlImage));
    }else{
      updateProfileEndpoint(user, nickname, hobbies, null);
    }
  }
  Future<void> updateProfileEndpoint(User user, String nickname, String? hobbies,String? image) async{
    //log("image=$image");

    user.nickname = nickname;
    user.image = image;
    user.hobbies = hobbies!=null?hobbies.split(","):[];

    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    await sharedUser.setString('user', jsonEncode(user.toJson()));

    final uri = Uri.parse("${Constants.baseUri}/profile");
    var accessToken = await AuthService().getAccessToken();
    final response = await http.put(uri, headers: {
      "Content-Type": 'application/json',
      "Authorization": "Bearer ${accessToken?.value ?? ""}"
    },body: jsonEncode({"userId":user.id,"nickname":nickname,"image":image,"hobbies":hobbies!=null?hobbies.split(","):[]}));
    if (response.statusCode == 200 && response.body.isNotEmpty) {
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }
  Future<String> uploadImage(File image) async{
    var accessToken = await AuthService().getAccessToken();
    var request = http.MultipartRequest('POST', Uri.parse("${Constants.baseUri}/files"))
              ..files.add(await http.MultipartFile.fromBytes('file',
              File(image.path).readAsBytesSync(),filename: image.uri.pathSegments.last));

    request.headers["Authorization"]="Bearer ${accessToken?.value ?? ""}";

    var response = await request.send();
    if (response.statusCode == 200){
      Map<String,dynamic>? valueMap;
      Completer<String> completer=Completer();
      response.stream.transform(utf8.decoder).listen((value) {valueMap = jsonDecode(value);}).onDone((){
        completer.complete(valueMap!.entries.first.value);
      });
      return completer.future;
    }
    return "";
  }
}
