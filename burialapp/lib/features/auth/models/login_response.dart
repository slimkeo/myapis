/// Matches `data` from POST /auth/verify-otp
class LoginResponse {
  final String token;
  final int expiresIn;
  final Map<String, dynamic>? member;

  LoginResponse({
    required this.token,
    required this.expiresIn,
    this.member,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token']?.toString() ?? '',
      expiresIn: int.tryParse(json['expires_in'].toString()) ?? 0,
      member: json['member'] is Map
          ? Map<String, dynamic>.from(json['member'] as Map)
          : null,
    );
  }
}
