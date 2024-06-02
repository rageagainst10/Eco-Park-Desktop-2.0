import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:ecoparkdesktop/models/FuncionarioModel.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../services/storage_service.dart';

class FuncionarioRepository {
  final String _baseUrl =
      'https://wa-dev-ecopark-api.azurewebsites.net/Employee'; // URL base da API
  final StorageService _storageService;

  FuncionarioRepository(this._storageService);

  Future<List<Funcionario>> getFuncionarios() async {
    final StorageService _storageService = GetIt.I<StorageService>();
    final url = Uri.parse(_baseUrl + '/list');
    final token =
        await _storageService.getToken(); // Obter o token do StorageService

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'employeeIds': []}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((funcionarioJson) => Funcionario.fromJson(funcionarioJson))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Erro ao obter os funcionarios da API: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }

  Future<void> cadastrarFuncionario(
      String firstName,
      String lastName,
      String administratorId,
      String email,
      String password,
      Uint8List? imageData,
      String? mimeType,
      String? imageName,
      String userType
      ) async {
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final List<Funcionario> funcionarios = await getFuncionarios();
    final String administratorId =
        funcionarios.first.id; //primeiro membro da lista é o proprio usuário

    final url = Uri.parse(_baseUrl).replace(queryParameters: {
      'administratorId': administratorId,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'userType': userType,
    });

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    if (imageData != null) {
      String? filename = imageName;

      var multipartFile = http.MultipartFile.fromBytes(
        'image', // Nome do campo para a imagem
        imageData,
        filename: filename, // Ou o nome original do arquivo
        contentType: MediaType.parse(mimeType ?? 'image/jpeg'),
      );
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Funcionário cadastrado com sucesso!');
      } else {
        final responseString = await response.stream.bytesToString();
        final errorData = jsonDecode(responseString);
        throw Exception(
            'Erro ao cadastrar funcionário: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
