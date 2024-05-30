import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ecoparkdesktop/models/FuncionarioModel.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../services/storage_service.dart';

class FuncionarioRepository {
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net/Employee'; // URL base da API
  final StorageService _storageService;

  FuncionarioRepository(this._storageService);

  Future<List<Funcionario>> getFuncionarios() async {
    final StorageService _storageService = GetIt.I<StorageService>();
    final url = Uri.parse(_baseUrl + '/list');
    final token = await _storageService.getToken(); // Obter o token do StorageService

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
        return data.map((funcionarioJson) => Funcionario.fromJson(funcionarioJson))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Erro ao obter os funcionarios da API: ${errorData['error'] ??
                'Erro desconhecido'}');
      }
    }catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }

  Future<void> cadastrarFuncionario(
      String firstName,
      String lastName,
      String administratorId,
      String email,
      String password,
      File? image,
      ) async {
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final List<Funcionario> funcionarios = await getFuncionarios();
    final String administratorId = funcionarios.first.id; //primeiro membro da lista é o proprio usuário



    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';




    FormData formData = FormData.fromMap({
      'administratorId': administratorId,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'userType': 'Employee', // ou outro tipo de usuário
      if (image != null) 'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
    });

    try {
      final response = await dio.post(_baseUrl, data: formData);
      if (response.statusCode == 200) {
        print('Funcionário cadastrado com sucesso!');
      } else {
        throw Exception('Erro ao cadastrar funcionário: ${response.data['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }


}
