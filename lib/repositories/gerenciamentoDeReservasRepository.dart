import 'package:ecoparkdesktop/models/LocationModel.dart'; // Importe o LocationModel
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ParkingSpaceModel.dart';
import '../services/storage_service.dart';

class ReservaRepository {
  final StorageService _storageService;
  final String _baseUrl = 'https://wa-dev-ecopark-api.azurewebsites.net';

  ReservaRepository(this._storageService);

  Future<List<LocationModel>> getLocations() async {
    final StorageService _storageService = GetIt.I<StorageService>();
    final url = Uri.parse(_baseUrl + '/Location/list');
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

  Future<void> salvarAlteracoes(ParkingSpaceModel vaga) async {
    final url = Uri.parse('$_baseUrl/ParkingSpace?id=${vaga.id}');
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
          'floor': vaga.floor,
          'parkingSpaceName': vaga.name,
          'parkingSpaceType': _getParkingSpaceType(vaga.type),
          'isOccupied': vaga.isOccupied,
        }),
      );

      if (response.statusCode != 201) {
        if (response.statusCode == 403) {
          final  errorData = response.reasonPhrase;
          throw Exception(errorData ?? 'Erro desconhecido');
        }
        else{
          final  errorData = jsonDecode(response.body);
          throw Exception('Erro ao salvar alterações: ${errorData['message'] ?? 'Erro desconhecido'}');
        }
      }

    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }

  int _getParkingSpaceType(String tipo) {
    switch (tipo) {
      case 'Electric': return 0;
      case 'Combustion': return 1;
      default: return 2; // Other
    }
  }
}
