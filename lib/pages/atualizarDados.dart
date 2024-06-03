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
import '../models/UserModel.dart';
import '../repositories/UsuarioRepository.dart';
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
  final TextEditingController _firstNameController =
  TextEditingController();
  final TextEditingController _lastNameController =
  TextEditingController();

  final StorageService _storageService = GetIt.I<StorageService>();
  final AuthService _authService =
  getIt<AuthService>(); // Obter instância do AuthService
  final UsuarioRepository _usuarioRepository = UsuarioRepository(GetIt.I<StorageService>());

  String? _userRole;
  String? _userEmail;
  String? _senhaErrorMessage;
  String? _confirmarSenhaErrorMessage; // Mensagem de erro para a senha
  String? _emailErrorMessage;
  int? _cargoSelecionado; // Cargo selecionado no dropdown


  @override
  void initState() {
    super.initState();
    _getUserRole(); // Carrega o papel do usuário ao iniciar a tela
    _getUserEmail();
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
  Future<void> _getUserEmail() async {
    try {
      final userEmail = await _storageService.getUserEmail();
      setState(() {
        _userEmail = userEmail;
      });
    } catch (e) {
      // Tratar erro ao obter o email do usuário
      setState(() {
      });
      print('Erro ao obter email do usuário: $e');
    }
  }


  Future<void> _atualizarDados() async {

    _defineConfirmedPasswordErrorMessage();
    if(_confirmarSenhaErrorMessage != null){
      return;
    }
    _definePasswordErrorMessage();
    if (_senhaErrorMessage != null) {
      return;
    }
    _defineEmailErrorMessage();
    if(_emailErrorMessage != null){
      return;
    }


    final String? nome = _firstNameController.text.isNotEmpty ? _firstNameController.text : null;
    final String? sobrenome = _lastNameController.text.isNotEmpty ? _lastNameController.text : null;
    final String? email = _emailController.text.isNotEmpty ? _emailController.text : null;
    final String? senha = _senhaController.text.isNotEmpty ? _senhaController.text : null;


    final usuario = UserModel(
      firstName: nome,
      lastName: sobrenome,
      email: email,
      password: senha,
      userType: _cargoSelecionado,
    );

    try {
      await _usuarioRepository.atualizarDadosUsuario(usuario);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar dados: $e')),
      );
    }
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
                    title: Text('Atribuir Permissão'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AtribuirPermissao()),
                      );
                    },
                  )
                      : Container();
                }
              },
            ),//Atribuir Permissao
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
          height: 357+59+38,
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
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
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
                        controller: _lastNameController,
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
                  onChanged: (_) => _defineEmailErrorMessage()
              ),
              if (_emailErrorMessage !=
                  null) // Exibe mensagem de erro se o email for invalido
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _emailErrorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Senha',
                controller: _senhaController,
                onChanged: (_) {
                  _definePasswordErrorMessage();
                  if(_confirmarSenhaController.text.isNotEmpty)
                  {
                  _defineConfirmedPasswordErrorMessage();
                  }
                }
              ),
              if (_senhaErrorMessage !=
                  null) // Exibe mensagem de erro se a senha for invalida
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _senhaErrorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Confirmar Senha',
                controller: _confirmarSenhaController,
                onChanged: (_) => _defineConfirmedPasswordErrorMessage(),
              ),
              if (_confirmarSenhaErrorMessage !=
                  null && _senhaController.text.isNotEmpty) // Exibe mensagem de erro se as senhas não coincidirem
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _confirmarSenhaErrorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: FutureBuilder<String?>(
                  future: _storageService.getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Indicador de carregamento
                    } else if (snapshot.hasError) {
                      return Text(
                          'Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
                    } else {
                      _userRole = snapshot.data; // Atribui o papel do usuário
                      return _userRole == 'PlatformAdministrator'
                          ? DropdownButtonFormField<int>(
                        hint: Text('Selecione o seu novo cargo'),
                        value: _cargoSelecionado,
                        onChanged: (int? newValue) {
                          setState(() {
                            _cargoSelecionado = newValue;
                          });
                        },
                        items: [
                          _buildDropdownMenuItem(
                              'Administrador de Plataforma',
                              4),
                          _buildDropdownMenuItem(
                              'Administrador', 3),
                          _buildDropdownMenuItem(
                              'Funcionário', 1),
                        ].toList(),
                      )
                          : _userRole == 'Administrator'
                          ? DropdownButtonFormField<int>(
                        hint: Text(
                            'Selecione o seu novo cargo'),
                        value: _cargoSelecionado,
                        onChanged: (int? newValue) {
                          setState(() {
                            _cargoSelecionado = newValue;
                          });
                        },
                        items: [
                          _buildDropdownMenuItem(
                              'Administrador', 3),
                          _buildDropdownMenuItem(
                              'Funcionário', 1),
                        ].toList(),
                      )
                          : DropdownButtonFormField<int>(
                        hint: Text(
                            'Selecione o seu novo cargo'),
                        value: _cargoSelecionado,
                        onChanged: (int? newValue) {
                          setState(() {
                            _cargoSelecionado = newValue;
                          });
                        },
                        items: [
                          _buildDropdownMenuItem(
                              'Funcionário', 1),
                        ].toList(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: TextButton(
                  onPressed: ((_senhaController.text ==
                      _confirmarSenhaController.text)
                      || _senhaController.text.isEmpty && _confirmarSenhaController.text.isEmpty)
                      && _validadePassword()
                      ? () {
                    _atualizarDados();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              GerenciamentoDeReserva()),
                    );
                  }: null,
                  style: ButtonStyle(
                    side: WidgetStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: Color(0xFF8DCBC8),
                        width: 2.0,
                      ),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Atualizar Dados',
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

  DropdownMenuItem<int> _buildDropdownMenuItem(String label, int value) {
    return DropdownMenuItem<int>(
      value: value, // UserType Enum
      child: Text(label), // Texto em português
    );
  }

  void _defineConfirmedPasswordErrorMessage() {
    setState(() {
      _confirmarSenhaErrorMessage = _validateConfirmedPassword()
          ? null
          : 'As senhas não coincidem.';
    });
  }

  bool _validateConfirmedPassword(){
    return ((_senhaController.text == _confirmarSenhaController.text)  || _senhaController.text.isEmpty && _confirmarSenhaController.text.isEmpty);
  }

  void _definePasswordErrorMessage() {
    setState(() {
      _senhaErrorMessage = _validadePassword()
          ? null
          : 'A senha deve conter um caracter maiúsculo, um minúsculo, um caracter especial e no mínimo 7 caracteres.';
    });
  }
  bool _validadePassword() {
    bool temMaiuscula = _senhaController.text.contains(RegExp(r'[A-Z]'));
    bool temMinuscula = _senhaController.text.contains(RegExp(r'[a-z]'));
    bool temNumero = _senhaController.text.contains(RegExp(r'[0-9]'));
    bool temTamanhoCorreto = _senhaController.text.length >= 7;
    bool contemCaracterEspecial = _senhaController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool isSenhaCorreta =
        (temMaiuscula && temMinuscula && temNumero && temTamanhoCorreto && contemCaracterEspecial) || _senhaController.text.isEmpty;

    return isSenhaCorreta;
  }
  bool _validateEmail(){
    return _emailController.text.toLowerCase() != _userEmail?.toLowerCase();
  }
  void _defineEmailErrorMessage() {
    setState(() {
      _emailErrorMessage = _validateEmail()
          ? null
          : 'O e-mail a ser atualizado deve ser diferente do seu email atual. Caso não queira atualizar, deixe o campo em branco';
    });
  }
}
