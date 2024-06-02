import 'package:ecoparkdesktop/models/FuncionarioModel.dart';
import 'package:ecoparkdesktop/models/LocationModel.dart';
import 'package:ecoparkdesktop/repositories/GerenciamentoDeReservasRepository.dart';
import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:get_it/get_it.dart';

import '../main.dart';
import '../repositories/PermissaoRepository.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'cadastroFuncionario.dart';
import 'package:ecoparkdesktop/repositories/FuncionarioRepository.dart';

class AtribuirPermissao extends StatefulWidget {
  const AtribuirPermissao({Key? key}) : super(key: key);

  @override
  State<AtribuirPermissao> createState() => _AtribuirPermissaoState();
}

class _AtribuirPermissaoState extends State<AtribuirPermissao> {
  final StorageService _storageService = GetIt.I<StorageService>();
  final AuthService _authService =
  getIt<AuthService>(); // Obter instância do AuthService

  final PermissaoRepository _permissaoRepository = PermissaoRepository(GetIt.I<StorageService>());

  String? _userRole;

  late List<Funcionario> _funcionarios;
  late List<LocationModel> _localizacoes;

  String? _selectedFuncionarioId; // ID do funcionário selecionado
  String? _selectedLocationId;    // ID da localização selecionada

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Carrega o papel do usuário ao iniciar a tela
    _carregarFuncionariosELocalizacoes();
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

  Future<void> _carregarFuncionariosELocalizacoes() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      final todosFuncionarios  = await FuncionarioRepository(_storageService).getFuncionarios();
      final funcionarios = todosFuncionarios.sublist(1); // Exclui o primeiro elemento da lista
      setState(() {
        _funcionarios = funcionarios;
      });

      final localizacoes = await ReservaRepository(_storageService).getLocations();
      setState(() {
        _localizacoes = localizacoes;
      });

      // e preencher as listas _funcionarios e _localizacoes
    } catch (e) {
      // Tratar erro
      print('Erro ao carregar funcionários e localizações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPersonalizado(
        text: 'Atribuir Permissão',
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
              title: const Text('Gerenciamento de Reservas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GerenciamentoDeReserva(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Gerenciamento de Prêmios'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GerenciamentoDePremios(),
                  ),
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
                  return _userRole != 'Employee' && _userRole != 'PlatformAdministrator'
                      ? ListTile(
                    title: Text('Cadastro de Localização'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CadastroDeLocalizacao()),
                      );
                    },
                  )
                      : Container();
                }
              },
            ),//Insert Location
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
              title: const Text('Atualizar Dados'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AtualizarDados(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Sair'),
              onTap: () async {
                await _authService.logout();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF8DCBC8),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: const Text('Selecionar Funcionario'),
                value: _selectedFuncionarioId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFuncionarioId = newValue;
                  });
                },
                items: _funcionarios.map((funcionario) {
                  return DropdownMenuItem<String>(
                    value: funcionario.id,
                    child: Text(funcionario.firstName),
                  );
                }).toList(),
              ),
              const SizedBox(
                  height: 20), // Adiciona espaçamento entre os DropdownButtons
              DropdownButton<String>(
                hint: const Text('Selecionar Localização'),
                value: _selectedLocationId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocationId = newValue;
                  });
                },
                items: _localizacoes.map((localizacao) {
                  return DropdownMenuItem<String>(
                    value: localizacao.id,
                    child: Text(localizacao.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                width: 250,
                child: TextButton(
                  onPressed: () async {
                    if (_selectedFuncionarioId != null && _selectedLocationId != null) {
                      try {
                        await _permissaoRepository.atribuirLocalizacao(_selectedFuncionarioId!, _selectedLocationId!);

                        // Encontra o funcionário pelo ID
                        final funcionarioSelecionado = _funcionarios.firstWhere((f) => f.id == _selectedFuncionarioId);
                        // Encontra a localização pelo ID
                        final localizacaoSelecionada = _localizacoes.firstWhere((l) => l.id == _selectedLocationId);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Localização ${localizacaoSelecionada.name} atribuída a ${funcionarioSelecionado.firstName} ${funcionarioSelecionado.lastName}',
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, selecione o funcionário e a localização.')),
                      );
                    }
                  },
                  child: const Text(
                    'Atribuir Localização',
                    style: TextStyle(
                      color: Color(0xFF8DCBC8),
                    ),
                  ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AtribuirPermissao(),
  ));
}
