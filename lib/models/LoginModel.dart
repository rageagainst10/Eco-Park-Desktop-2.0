class LoginModel {
  final String email;
  final String token; // Exemplo de outras propriedades que a API pode retornar
  // ... outras propriedades

  LoginModel({required this.email, required this.token}); // Construtor

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'],
      token: json['token']
    );
  }
}
