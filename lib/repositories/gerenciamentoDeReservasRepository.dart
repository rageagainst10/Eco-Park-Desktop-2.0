import 'package:ecoparkdesktop/models/LocationModel.dart'; // Importe o LocationModel
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ParkingSpaceModel.dart';
import '../services/storage_service.dart';

class ReservaRepository {
  final StorageService _storageService;
  final String _baseUrl = 'https://apim-dev-ecopark-api.azure-api.net/Location/';

  ReservaRepository(this._storageService);

  Future<List<LocationModel>> getLocations() async {
    final StorageService _storageService = GetIt.I<StorageService>();
    final url = Uri.parse(_baseUrl + 'list');
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
        body: jsonEncode({'locationIds': [], 'includeParkingSpaces': true}),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((locationJson) => LocationModel.fromJson(locationJson))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Erro ao obter localizações da API: ${errorData['error'] ??
                'Erro desconhecido'}');
      }
    }catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }

  Future<void> salvarAlteracoes(Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl + 'updateParkingSpaces');
    final token = await _storageService.getToken();

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
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Dados salvos com sucesso!');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erro ao salvar alterações: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}
