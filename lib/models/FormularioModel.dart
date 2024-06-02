// Classe modelo para representar os dados do formulário
class FormularioData {
  final String nome;
  final String sobrenome;
  final String idGestor;
  final String email;
  final String senha;
  final String userType;

  FormularioData({
    required this.nome,
    required this.sobrenome,
    required this.idGestor,
    required this.email,
    required this.senha,
    required this.userType,
  });
}