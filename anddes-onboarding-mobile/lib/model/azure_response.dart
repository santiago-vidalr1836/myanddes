import '../constants.dart';

class AzureTokenResponse {
  final String? idToken;
  final String? refreshToken;
  final String? accessToken;
  final int? refreshTokenExpireTime;

  AzureTokenResponse(
      {this.idToken,
      this.accessToken,
      this.refreshToken,
      this.refreshTokenExpireTime});

  // Casts types to whatever is required, if fails returns nulls
  static T? _castType<T>(x) => x is T ? x : null;

  static int? _getExpirationTimeInSecondsSinceEpoch(dynamic secondsFromNow) {
    var secondsFromNowCastedToInt = _castType<int>(secondsFromNow);
    if (secondsFromNowCastedToInt != null) {
      int milliseconds = DateTime.now().millisecondsSinceEpoch +
          (secondsFromNowCastedToInt * 1000);
      return milliseconds ~/ 1000;
    }
    return null;
  }

  AzureTokenResponse.fromJson(Map<String, dynamic> json)
      : idToken = json[Constants.idToken],
        accessToken = json[Constants.accessToken],
        refreshToken = json[Constants.refreshToken],
        refreshTokenExpireTime =
            _getExpirationTimeInSecondsSinceEpoch(json[Constants.expiresIn]);
}
