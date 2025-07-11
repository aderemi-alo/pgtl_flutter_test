import 'user.dart';

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class LoginResponse {
  final bool success;
  final String? token;
  final String? error;
  final User? user;

  const LoginResponse({
    required this.success,
    this.token,
    this.error,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      token: json['token'],
      error: json['error'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
