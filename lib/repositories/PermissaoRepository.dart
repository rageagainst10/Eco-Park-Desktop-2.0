import 'dart:convert';
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:http/http.dart' as http;

class PermissaoRepository {
  final StorageService _storageService;
  final String _baseUrl = 'https://apim-dev-ecopark-api.azure-api.net/Employee'; // URL base da API

  PermissaoRepository(this._storageService);

  Future<void> atribuirLocalizacao(String employeeId, String locationId) async {
    final url = Uri.parse(_baseUrl + '/GroupAccess').replace(queryParameters: {
      'EmployeeId': employeeId,
      'LocationId': locationId,
    });
    final token = await _storageService.getToken();

    if (token == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Ocp-Apim-Subscription-Key': 'SUA_CHAVE_DE_ASSINATURA',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Permissão atribuída com sucesso!');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Erro ao atribuir permissão: ${errorData['error'] ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      throw Exception('Erro na comunicação com a API: $e');
    }
  }
}