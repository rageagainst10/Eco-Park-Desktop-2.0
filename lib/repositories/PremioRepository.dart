import 'dart:convert';
import 'package:ecoparkdesktop/models/PremioModel.dart';
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:http/http.dart' as http;

class PremioRepository {
  final StorageService _storageService;
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net/Reward/';

  PremioRepository(this._storageService);

  Future<List<PremioModel>> getPremios(String locationId) async {
    final url = Uri.parse(_baseUrl + 'list');
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'locationId': locationId}), // Passa o locationId no body
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((premioJson) => PremioModel.fromJson(premioJson)).toList();
    } else {
      throw Exception('Erro ao obter prêmios da API: ${response.body}');
    }
  }
}
