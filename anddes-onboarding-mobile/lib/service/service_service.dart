import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mi_anddes_mobile_app/model/service.dart';
import 'package:mi_anddes_mobile_app/repository/service_repository.dart';
import 'package:mi_anddes_mobile_app/utils/exception/unauthorized_exception.dart';

import '../constants.dart';
import 'auth_service.dart';

class ServiceService {
  late ServiceRepository _serviceRepository;
  ServiceService() {
    _serviceRepository = ServiceRepository();
  }
  Future<void> listRemote() async {
    var accessToken = await AuthService().getAccessToken();
    final uri = Uri.parse("${Constants.baseUri}/services");
    final response = await http.get(uri,
        headers: {"Authorization": "Bearer ${accessToken?.value ?? ""}"});
    if (response.statusCode == 200) {
      log(utf8.decode(response.bodyBytes));
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Service> services =
          List<Service>.from(body.map((model) => Service.fromJson(model)));
      await _serviceRepository.deleteAll();
      await _serviceRepository.addAll(services);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
  }

  Future<List<Service>> list() async {
    return _serviceRepository.findAll();
  }
}
