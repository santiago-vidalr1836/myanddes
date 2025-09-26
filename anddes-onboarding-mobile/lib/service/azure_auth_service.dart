import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mi_anddes_mobile_app/model/azure_response.dart';
import 'package:pkce/pkce.dart';

import '../constants.dart';

const _formUrlEncodedContentType = "application/x-www-form-urlencoded";

class AzureAuthService {
  final PkcePair pkcePair;
  AzureAuthService({required this.pkcePair});

  /// Refresh token: This method also returns a new refresh token [AzureTokenResponse]
  static Future<AzureTokenResponse?> refreshTokens(
      {required String refreshToken}) async {
    final uri =
        Uri.parse("${Constants.tenantUrl}/${Constants.userGetTokenUrlEnding}");

    final response = await http.post(uri, body: {
      'grant_type': Constants.refreshToken,
      'scope': Constants.defaultScopes,
      'client_id': Constants.clientId,
      'refresh_token': refreshToken,
    }, headers: {
      "Content-Type": _formUrlEncodedContentType
    });

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      //log("refreshTokens.body=${response.body}");
      final body = jsonDecode(response.body);
      return AzureTokenResponse.fromJson(body);
    } else {
      return null;
    }
  }

  /// Get Access, Id and refresh token, check its response: [AzureTokenResponse]
  Future<AzureTokenResponse?> getAllTokens({required String authCode}) async {
    final uri =
        Uri.parse("${Constants.tenantUrl}/${Constants.userGetTokenUrlEnding}");
    //log("uri=${uri.toString()}");
    final response = await http.post(uri, body: {
      'scope': Constants.defaultScopes,
      'grant_type': Constants.defaultGrantType,
      'code': authCode,
      'client_id': Constants.clientId,
      'code_verifier': pkcePair.codeVerifier,
      'redirect_uri': Constants.redirectUrl,
    }, headers: {
      "Content-Type": _formUrlEncodedContentType
    });
    //log("getAllTokens.response.statusCode=${response.statusCode}");
    //log("getAllTokens.body=${response.body}");
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return AzureTokenResponse.fromJson(body);
    } else {
      return null;
    }
  }
}
