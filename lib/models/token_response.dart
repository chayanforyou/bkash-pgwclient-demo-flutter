class TokenResponse {
  String statusCode;
  String statusMessage;
  String idToken;
  String tokenType;
  int expiresIn;
  String refreshToken;

  TokenResponse(
    this.statusCode,
    this.statusMessage,
    this.idToken,
    this.tokenType,
    this.expiresIn,
    this.refreshToken,
  );

  TokenResponse.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'] as String? ?? '',
        statusMessage = json['statusMessage'] as String? ?? '',
        idToken = json['id_token'] as String? ?? '',
        tokenType = json['token_type'] as String? ?? '',
        expiresIn = json['expires_in'] as int? ?? 0,
        refreshToken = json['refresh_token'] as String? ?? '';

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'id_token': idToken,
        'token_type': tokenType,
        'expires_in': expiresIn,
        'refresh_token': refreshToken,
      };
}
