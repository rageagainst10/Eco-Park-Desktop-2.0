class Funcionario {
  final String firstName;
  final String lastName;
  final String id;
  final String email;
  final String userType;
  final String imageUrl;

  Funcionario({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.email,
    required this.userType,
    required this.imageUrl,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userType: json['userType'],
      imageUrl: json['imageUrl'],
    );
  }
}