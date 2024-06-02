import 'dart:io';
import 'package:ecoparkdesktop/pages/AtribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/repositories/FuncionarioRepository.dart'; // Importe o repositório
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:typed_data';
import '../main.dart';
import '../models/FormularioModel.dart'; // Para File
import 'package:mime/mime.dart';

import '../services/auth_service.dart';

class CadastroDeFuncionario extends StatefulWidget {
  const CadastroDeFuncionario({super.key});

  @override
  State<CadastroDeFuncionario> createState() => _CadastroDeFuncionarioState();
}

class _CadastroDeFuncionarioState extends State<CadastroDeFuncionario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _idGestorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  final StorageService _storageService = GetIt.I<StorageService>();
  final AuthService _authService =
      getIt<AuthService>(); // Obter instância do AuthService

  String? _cargoSelecionado;
  Uint8List? _imageData;
  String? _mimeType;
  String? _imageName;
  File? _imagem;
  String? _confirmarSenhaErrorMessage; // Mensagem de erro para a senha
  String? _senhaErrorMessage; // Mensagem de erro para a senha

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    _imageName = pickedFile?.name;
    _mimeType = lookupMimeType(pickedFile!.path.split('/').last);

    _imageData = await pickedFile.readAsBytes(); // Lê os bytes da imagem
    setState(() {
      _imagem = File(pickedFile.path);
    }); // Atualiza o estado para exibir a imagem selecionada (opcional)
  }

  void _cadastrarFuncionario() async {
    if (_senhaController.text != _confirmarSenhaController.text) {
      setState(() {
        _confirmarSenhaErrorMessage = 'As senhas não coincidem.';
      });
      return; // Não realiza o cadastro
    } else {
      setState(() {
        _confirmarSenhaErrorMessage =
            null; // Limpa a mensagem de erro se as senhas forem iguais
      });
    }
    _definesenhaErrorMessage();
    if (_senhaErrorMessage != null) {
      return;
    }

    // Criar uma instância do modelo de dados com os valores dos campos de texto
    FormularioData data = FormularioData(
        nome: _nomeController.text,
        sobrenome: _sobrenomeController.text,
        idGestor: _idGestorController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        userType: _cargoSelecionado.toString());

    try {
      final token =
          await _storageService.getToken(); // Obter o token do StorageService

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      await FuncionarioRepository(_storageService).cadastrarFuncionario(
        data.nome,
        data.sobrenome,
        data.idGestor,
        data.email,
        data.senha,
        _imageData,
        _mimeType,
        _imageName,
        data.userType,
      );
    } catch (e) {
      // Tratar erro
      print('Erro ao cadastrar funcionário: $e');
    }
    print('Enviando dados para a API: $data');
  }

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
      setState(() {});
      print('Erro ao obter papel do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_senhaController.text != _confirmarSenhaController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('As senhas não coincidem.')),
            );
            return false; // Impede o retorno
          }
          return true; // Permite o retorno
        },
        child: Scaffold(
          appBar: AppBarPersonalizado(
            text:
                'Cadastro de Funcionários', // Passando o texto desejado para o AppBarPersonalizado
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
                      return Text(
                          'Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
                    } else {
                      _userRole = snapshot.data; // Atribui o papel do usuário
                      return _userRole != 'Employee' &&
                              _userRole != 'PlatformAdministrator'
                          ? ListTile(
                              title: Text('Cadastro de Localização'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroDeLocalizacao()),
                                );
                              },
                            )
                          : Container();
                    }
                  },
                ), //Insert Location
                FutureBuilder<String?>(
                  future: _storageService.getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Indicador de carregamento
                    } else if (snapshot.hasError) {
                      return Text(
                          'Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
                    } else {
                      _userRole = snapshot.data; // Atribui o papel do usuário
                      return _userRole != 'PlatformAdministrator'
                          ? ListTile(
                              title: Text('Atribuir Permissão'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AtribuirPermissao()),
                                );
                              },
                            )
                          : Container();
                    }
                  },
                ), //Atribuir Permissao
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
              height: 654,
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
                    "Cadastrar Funcionário",
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
                              hintText: 'Nome',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                            controller: _nomeController,
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
                              hintText: 'Sobrenome',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                            controller: _sobrenomeController,
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
                    onChanged: (_) => _definesenhaErrorMessage(),
                  ),
                  if (_senhaErrorMessage !=
                      null) // Exibe mensagem de erro se as senhas não coincidirem
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
                    onChanged: (_) => _validateConfirmedPassword(),
                  ),
                  if (_confirmarSenhaErrorMessage !=
                      null) // Exibe mensagem de erro se as senhas não coincidirem
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _confirmarSenhaErrorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 15),
                  FutureBuilder<String?>(
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
                            ? DropdownButtonFormField<String>(
                                hint: Text('Selecione o cargo do funcionário'),
                                value: _cargoSelecionado,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _cargoSelecionado = newValue;
                                  });
                                },
                                items: [
                                  _buildDropdownMenuItem(
                                      'Administrador de Plataforma',
                                      'PlataformAdministrator'),
                                  _buildDropdownMenuItem(
                                      'Administrador', 'Administrator'),
                                  _buildDropdownMenuItem(
                                      'Funcionário', 'Employee'),
                                ].toList(),
                              )
                            : _userRole == 'Administrator'
                                ? DropdownButtonFormField<String>(
                                    hint: Text(
                                        'Selecione o cargo do funcionário'),
                                    value: _cargoSelecionado,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _cargoSelecionado = newValue;
                                      });
                                    },
                                    items: [
                                      _buildDropdownMenuItem(
                                          'Administrador', 'Administrator'),
                                      _buildDropdownMenuItem(
                                          'Funcionário', 'Employee'),
                                    ].toList(),
                                  )
                                : DropdownButtonFormField<String>(
                                    hint: Text(
                                        'Selecione o cargo do funcionário'),
                                    value: _cargoSelecionado,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _cargoSelecionado = newValue;
                                      });
                                    },
                                    items: [
                                      _buildDropdownMenuItem(
                                          'Funcionário', 'Employee'),
                                    ].toList(),
                                  );
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 40,
                    width: 315,
                    child: TextButton(
                      onPressed: _getImage,
                      child: const Text(
                        'Escolher Imagem',
                        style: TextStyle(
                          color: Color(0xFF8DCBC8),
                        ),
                      ),
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
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 40,
                    width: 315,
                    child: TextButton(
                      onPressed: (_senhaController.text ==
                                  _confirmarSenhaController.text) &&
                              _validadePassword()
                          ? () {
                              _cadastrarFuncionario();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CadastroDeLocalizacao()),
                              );
                            }
                          : null, // Corrigido o chamado do método
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
                        'Cadastrar',
                        style: TextStyle(
                          color: Color(0xFF8DCBC8),
                        ),
                      ),
                    ),
                  ),
                  _imagem != null // Exibe a imagem se ela foi selecionada
                      ? Image.memory(
                          _imageData!,
                          width: 100, // Ajuste a largura conforme necessário
                          height: 100, // Ajuste a altura conforme necessário
                        )
                      : const SizedBox
                          .shrink(), // Não exibe nada se não houver imagem
                ],
              ),
            ),
          ),
        ));
  }

  void _validateConfirmedPassword() {
    setState(() {
      _confirmarSenhaErrorMessage =
          _senhaController.text == _confirmarSenhaController.text
              ? null
              : 'As senhas não coincidem.';
    });
  }

  bool _validadePassword() {
    bool temMaiuscula = _senhaController.text.contains(RegExp(r'[A-Z]'));
    bool temMinuscula = _senhaController.text.contains(RegExp(r'[a-z]'));
    bool temNumero = _senhaController.text.contains(RegExp(r'[0-9]'));
    bool temTamanhoCorreto = _senhaController.text.length >= 7;
    bool isSenhaCorreta =
        temMaiuscula && temMinuscula && temNumero && temTamanhoCorreto;

    return isSenhaCorreta;
  }

  void _definesenhaErrorMessage() {
    setState(() {
      _senhaErrorMessage = _validadePassword()
          ? null
          : 'A senha deve conter um caracter maiúsculo, um minúsculo e no mínimo 7 caracteres.';
    });
  }

  DropdownMenuItem<String> _buildDropdownMenuItem(String label, String value) {
    return DropdownMenuItem<String>(
      value: value, // Valor em inglês
      child: Text(label), // Texto em português
    );
  }
}
