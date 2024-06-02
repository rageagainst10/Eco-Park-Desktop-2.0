import 'dart:convert';
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:http/http.dart' as http;

import '../models/UserModel.dart';

class UsuarioRepository {
  final StorageService _storageService;
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net/Employee'; // URL base da API

  UsuarioRepository(this._storageService);

  Future<void> atualizarDadosUsuario(UserModel usuario) async {
    final url = Uri.parse(_baseUrl);
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          if (usuario.firstName != null) 'firstName': usuario.firstName,
          if (usuario.lastName != null) 'lastName': usuario.lastName,
          if (usuario.email != null) 'email': usuario.email,
          if (usuario.password != null) 'password': usuario.password,
          if (usuario.userType != null) 'userType': usuario.userType,
        }),
      );

      if (response.statusCode == 201) {
        print('Dados do usuário atualizados com sucesso!');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erro ao atualizar dados do usuário: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
