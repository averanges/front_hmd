class AuthRequest {
  final String idToken;
  final String? authCode;

  AuthRequest({required this.idToken, this.authCode});

  Map<String, dynamic> toJson() {
    var json = {
      'id_token': idToken,
    };
    if (authCode != null) {
      json['auth_code'] = authCode!;
    }
    return json;
  }
}
