import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FuncionarioRepository {
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net/Employee'; // URL base da API

  Future<void> cadastrarFuncionario(
      String firstName,
      String lastName,
      String administratorId,
      String email,
      String password,
      String confirmPassword,
      File? image,
      String token,
      ) async {
    final url = Uri.parse(_baseUrl);

    var request = http.MultipartRequest('POST', url);
    request.fields['administratorId'] = administratorId;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['confirmPassword'] = confirmPassword;
    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;
    request.fields['userType'] = 'Admin'; // ou outro tipo de usuário
    request.headers['Authorization'] = 'Bearer $token'; // Autenticação com token

    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Funcionário cadastrado com sucesso!');
      } else {
        final responseString = await response.stream.bytesToString();
        final errorData = jsonDecode(responseString);
        throw Exception('Erro ao cadastrar funcionário: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
