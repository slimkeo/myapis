class LoginResponse {
  final String token;
  final String userId;
  final String email;
  final String name;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'userId': userId, 'email': email, 'name': name};
  }
}
