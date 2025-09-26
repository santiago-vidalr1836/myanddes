import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mi_anddes_mobile_app/constants.dart';
import 'package:mi_anddes_mobile_app/repository/tool_repository.dart';
import 'package:mi_anddes_mobile_app/service/auth_service.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';

import '../model/tool.dart';

class ToolService {
  late ToolRepository _toolRepository;
  ToolService() {
    _toolRepository = ToolRepository();
  }
  Future<void> listRemote() async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse("${Constants.baseUri}/tools");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Tool> tools =
          List<Tool>.from(body.map((model) => Tool.fromJson(model)));
      await _toolRepository.deleteAll();
      await _toolRepository.addAll(tools);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<List<Tool>?> list() async {
    return _toolRepository.findAll();
  }
}
