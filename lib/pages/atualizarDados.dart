import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/pages/atribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:get_it/get_it.dart';

import '../main.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'cadastroFuncionario.dart';

class AtualizarDados extends StatefulWidget {
  const AtualizarDados({Key? key}) : super(key: key);

  @override
  State<AtualizarDados> createState() => _AtualizarDadosState();
}

class _AtualizarDadosState extends State<AtualizarDados> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  final StorageService _storageService = GetIt.I<StorageService>();
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


  void _atualizarDados() {
    // Lógica para atualizar os dados aqui
    // Exemplo: enviar os dados para um servidor ou atualizar um banco de dados local
    print('Dados atualizados!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPersonalizado(
        text: 'Atualizar Dados',
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
              title: const Text('Atribuir Permissão'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AtribuirPermissao(),
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
          width: 350,
          height: 350,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          hintText: 'Nome',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        //controller: _nomeController,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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
                          hintText: 'Sobrenome',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        //controller: _sobrenomeController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'E-mail',
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Senha',
                controller: _senhaController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Confirmar Senha',
                controller: _confirmarSenhaController,
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Atualizar Dados',
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
    home: AtualizarDados(),
  ));
}
