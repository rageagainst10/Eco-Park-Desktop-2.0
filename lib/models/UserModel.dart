class UserModel {
  String? firstName;     // Nome (opcional, pode ser atualizado)
  String? lastName;      // Sobrenome (opcional, pode ser atualizado)
  String? email;        // Email (opcional, pode ser atualizado)
  String? password;     // Senha (opcional, pode ser atualizado)
  int? userType;      // Tipo de usuário (opcional, pode ser atualizado)

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.userType,
  });

  // Construtor fromJson (para criar o modelo a partir do JSON da API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userType: json['userType'],
      // A senha geralmente não é retornada pela API
    );
  }

  // Método toJson (para converter o modelo em JSON para enviar para a API)
  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (userType != null) 'userType': userType,
    };
  }
}
