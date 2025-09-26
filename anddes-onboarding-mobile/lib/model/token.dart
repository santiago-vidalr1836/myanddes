
import '../constants.dart';

enum TokenType {
  accessToken,
  idToken,
  refreshToken,
}

extension TokenTypeExtension on TokenType {
  String get name {
    switch (this) {
      case TokenType.accessToken:
        return Constants.accessToken;
      case TokenType.refreshToken:
        return Constants.refreshToken;
      case TokenType.idToken:
        return Constants.idToken;
    }
  }
}

class Token {
  final String value;
  final TokenType type;
  final int? expirationTime;

  Token({required this.type, this.expirationTime, required this.value});

  static Map<String, dynamic> toJson(Token token) => {
        'value': token.value,
        'expirationTime': token.expirationTime,
        'type': token.type.name
      };

  Token.fromJson(Map<String, dynamic> json)
      : value = json["value"],
        type = json["type"],
        expirationTime = json["expirationTime"];

  bool isValid() {
    if (expirationTime != null) {
      //log("isValid expirationTime=$expirationTime");
      //log("isValid (DateTime.now().millisecondsSinceEpoch ~/ 1000)=${(DateTime.now().millisecondsSinceEpoch ~/ 1000)}");
      //log("isValid (DateTime.now().millisecondsSinceEpoch ~/ 1000)-60=${(DateTime.now().millisecondsSinceEpoch ~/ 1000) - 60}");
      //log("isValid =${(DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60 < expirationTime!}");

      return (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 60 <
          expirationTime!;
    } else {
      return false;
    }
  }
}
