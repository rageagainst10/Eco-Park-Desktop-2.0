import 'dart:convert';

class UserModel {
  final String email;
  final String token; // Exemplo de outras propriedades que a API pode retornar
  // ... outras propriedades

  UserModel({required this.email, required this.token}); // Construtor

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      token: json['token']
    );
  }
}
