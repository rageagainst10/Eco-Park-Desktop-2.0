import 'package:ecoparkdesktop/main.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
  import 'dart:convert';

import '../services/storage_service.dart';

// Classe modelo para representar os dados do formulário
class FormularioData {
  final String reservationGraceInMinutes;
  final String reservationFeeRate;
  final String name;
  final String address;
  final String cancellationFeeRate;
  final String hourlyParkingRate;

  FormularioData({
    required this.reservationGraceInMinutes,
    required this.reservationFeeRate,
    required this.name,
    required this.address,
    required this.cancellationFeeRate,
    required this.hourlyParkingRate,
  });
}

class LocalizacaoCadastro extends StatefulWidget {
  const LocalizacaoCadastro({Key? key}) : super(key: key);

  @override
  State<LocalizacaoCadastro> createState() => _LocalizacaoCadastroState();
}

class _LocalizacaoCadastroState extends State<LocalizacaoCadastro> {

  Future<String?> _getToken() async {
    return await _storageService.getToken();
  }

  final StorageService _storageService = getIt<StorageService>();
  final TextEditingController _tempoLRController = TextEditingController();
  final TextEditingController _taxaReservaController = TextEditingController();
  final TextEditingController _nomeLocalizacaoController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _taxaCancelamentoController = TextEditingController();
  final TextEditingController _taxaCustoPorHoraController = TextEditingController();

Future _enviarDadosParaAPI() async {
  // Criar uma instância do modelo de dados com os valores dos campos de texto
  FormularioData data = FormularioData(
    reservationGraceInMinutes: _tempoLRController.text,
    reservationFeeRate: _taxaReservaController.text,
    name: _nomeLocalizacaoController.text,
    address: _enderecoController.text,
    cancellationFeeRate: _taxaCancelamentoController.text,
    hourlyParkingRate: _taxaCustoPorHoraController.text,
  );

  final token = await _storageService.getToken();

 final response = await http.post(
    Uri.parse("https://wa-dev-ecopark-api.azurewebsites.net/Location"),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json', // Define o tipo de conteúdo como JSON
    },
    body: jsonEncode({
      'name': data.name,
      'address': data.address,
      'reservationGraceInMinutes': int.parse(data.reservationGraceInMinutes),
      'cancellationFeeRate': double.parse(data.cancellationFeeRate),
      'reservationFeeRate': double.parse(data.reservationFeeRate),
      'hourlyParkingRate': double.parse(data.hourlyParkingRate),
    }),
  );

  if (response.statusCode == 200) {
    // Sucesso
    print('Dados enviados com sucesso');
  } else {
    // Falha
    print('Falha ao enviar dados: ${response.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBarPersonalizado(
        text: 'Cadastro de Localizaçâo', // Passando o texto desejado para o AppBarPersonalizado
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF8DCBC8),
              ),
              child: Text(
                'Outras Páginas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Gerenciamento de Reservas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDeReserva()),
                );
              },
            ),
            ListTile(
              title: Text('Gerenciamento de Premios'),
              onTap: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDePremios()),
                );
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF8DCBC8),
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Localização",
                style: TextStyle(
                  color: Color(0xFF8DCBC8),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tempo LR',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        controller: _tempoLRController,
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Taxa de reserva',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        controller: _taxaReservaController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Nome localização',
                controller: _nomeLocalizacaoController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Endereço',
                controller: _enderecoController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Taxa de cancelamento',
                controller: _taxaCancelamentoController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Taxa custo por hora',
                controller: _taxaCustoPorHoraController,
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: TextButton(
                  onPressed: () {
                    _enviarDadosParaAPI();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GerenciamentoDeReserva()),
                    );
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: Color(0xFF8DCBC8),
                        width: 2.0,
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Color(0xFF8DCBC8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


