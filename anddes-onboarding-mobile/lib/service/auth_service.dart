import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';
import '../model/token.dart';
import 'azure_auth_service.dart';

class AuthService {
  void saveAccessToken(Token token) async {
    //log("saveAccessToken token.value=${token.value}");
    //log("saveAccessToken token.expirationTime=${token.expirationTime}");
    const storage = FlutterSecureStorage();
    await storage.write(key: Constants.accessToken, value: token.value);
    await storage.write(
        key: Constants.refreshTokenExpiresIn,
        value: "${token.expirationTime!}");
  }

  void saveRefreshToken(Token token) async {
    //log("saveRefreshToken token.value=${token.value}");
    const storage = FlutterSecureStorage();
    await storage.write(key: Constants.refreshToken, value: token.value);
  }

  /*
  * These method read from secure storage the token. If the token is invalid by date, it will try to refresh
  * the token and save it an return it
  * */
  Future<Token?> getAccessToken() async {
    const storage = FlutterSecureStorage();
    var accessTokenValue = await storage.read(key: Constants.accessToken);
    var expirationTime =
        await storage.read(key: Constants.refreshTokenExpiresIn);

    if (accessTokenValue != null && expirationTime != null) {
      var token = Token(
          type: TokenType.accessToken,
          value: accessTokenValue,
          expirationTime: int.parse(expirationTime));
      if (token.isValid()) {
        return token;
      } else {
        var refreshToken = await getRefreshToken();
        if (refreshToken != null) {
          var azureTokenResponse = await AzureAuthService.refreshTokens(
              refreshToken: refreshToken.value);
          if (azureTokenResponse != null) {
            if (azureTokenResponse.refreshToken != null) {
              saveRefreshToken(Token(
                  type: TokenType.refreshToken,
                  value: azureTokenResponse.refreshToken!));
            }
            if (azureTokenResponse.accessToken != null) {
              var newToken = Token(
                  type: TokenType.accessToken,
                  value: azureTokenResponse.accessToken!,
                  expirationTime: azureTokenResponse.refreshTokenExpireTime!);
              saveAccessToken(newToken);
              return newToken;
            }
          }
        }
      }
    }
    return null;
  }

  Future<Token?> getRefreshToken() async {
    const storage = FlutterSecureStorage();
    var refreshToken = await storage.read(key: Constants.refreshToken);
    if (refreshToken != null) {
      return Token(type: TokenType.refreshToken, value: refreshToken);
    } else {
      return null;
    }
  }
}
