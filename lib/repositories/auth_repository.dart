import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecoparkdesktop/models/user_model.dart';

import '../sevices/storage_service.dart'; // Importe seu UserModel

class AuthRepository {
  final String _baseUrl = 'https://apim-dev-ecopark-api.azure-api.net/'; // Substitua pela URL da sua API
  final StorageService _storageService;
  AuthRepository(this._storageService);

  Future<void> saveToken(String token) async {
    await _storageService.saveToken(token);
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  Future<UserModel> login(String email, String senha) async {
    final url = Uri.parse(_baseUrl + 'Login'); // Endpoint de login da sua API

    try {
      final response = await http.put(
        url,
        body: jsonEncode({'email': email, 'password': senha}), // Adapte aos parâmetros da sua API
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String token = data['token'];

        await _storageService.saveToken(token);

        return UserModel.fromJson(data); // Crie um método fromJson no UserModel
      } else {
        // Lide com erros de autenticação (401, etc.)
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Erro desconhecido no login');
      }
    } catch (e) {
      // Lide com erros de rede ou outros erros
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
