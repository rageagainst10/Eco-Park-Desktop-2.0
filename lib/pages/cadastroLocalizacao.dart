import 'package:ecoparkdesktop/main.dart';
import 'package:ecoparkdesktop/pages/AtribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/cadastroFuncionario.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/LocationCadastroModel.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

// Classe modelo para representar os dados do formulário

class CadastroDeLocalizacao extends StatefulWidget {
  const CadastroDeLocalizacao({Key? key}) : super(key: key);

  @override
  State<CadastroDeLocalizacao> createState() => _CadastroDeLocalizacaoState();
}

class _CadastroDeLocalizacaoState extends State<CadastroDeLocalizacao> {
  Future<String?> _getToken() async {
    return await _storageService.getToken();
  }

  final StorageService _storageService = getIt<StorageService>();
  final AuthService _authService =
  getIt<AuthService>(); // Obter instância do AuthService

  String? _userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Carrega o papel do usuário ao iniciar a tela
  }
  Future<void> _getUserRole() async {
    try {
      final userRole = await _storageService.getUserRole();
      setState(() {
        _userRole = userRole;
      });
    } catch (e) {
      // Tratar erro ao obter o papel do usuário
      setState(() {
      });
      print('Erro ao obter papel do usuário: $e');
    }
  }


  final TextEditingController _tempoLRController = TextEditingController();
  final TextEditingController _taxaReservaController = TextEditingController();
  final TextEditingController _nomeLocalizacaoController =
      TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _taxaCancelamentoController =
      TextEditingController();
  final TextEditingController _taxaCustoPorHoraController =
      TextEditingController();

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

    final token = await _getToken();

    final response = await http.post(
      Uri.parse("https://wa-dev-ecopark-api.azurewebsites.net/Location"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type':
            'application/json', // Define o tipo de conteúdo como JSON
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
        text:
            'Cadastro de Localizaçâo', // Passando o texto desejado para o AppBarPersonalizado
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
                  MaterialPageRoute(
                      builder: (context) => GerenciamentoDeReserva()),
                );
              },
            ),
            ListTile(
              title: Text('Gerenciamento de Premios'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => GerenciamentoDePremios()),
                );
              },
            ),
            FutureBuilder<String?>(
              future: _storageService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Indicador de carregamento
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
                } else {
                  _userRole = snapshot.data; // Atribui o papel do usuário
                  return _userRole != 'PlatformAdministrator'
                      ? ListTile(
                    title: Text('Cadastro de Funcionario'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CadastroDeFuncionario()),
                      );
                    },
                  )
                      : Container();
                }
              },
            ),//Insert Funcionario
            ListTile(
              title: Text('Atribuir Permissão'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AtribuirPermissao()),
                );
              },
            ),
            ListTile(
              title: Text('Atualizar Dados'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AtualizarDados()),
                );
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () async {
                await _authService.logout();
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
                      MaterialPageRoute(
                          builder: (context) => GerenciamentoDeReserva()),
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
