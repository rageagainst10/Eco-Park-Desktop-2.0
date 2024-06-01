import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecoparkdesktop/models/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../services/storage_service.dart'; // Importe seu UserModel

class AuthRepository {
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net/'; // Substitua pela URL da sua API
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

        final jwt = JWT.decode(token);//Decodifica o Token
        // Salvar o UserRole no StorageService
        await _storageService.saveUserRole(jwt.payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']);

        //tratamento de erro para caso o usuário autenticado seja do tipo Client ou System

        return UserModel.fromJson(data); // Crie um método fromJson no UserModel
      } else {
        // Lide com erros de autenticação (401, etc.)
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro desconhecido no login');
      }
    } catch (e) {
      // Lide com erros de rede ou outros erros
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
