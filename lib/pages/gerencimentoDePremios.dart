import 'package:ecoparkdesktop/pages/AtribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/cadastroFuncionario.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class GerenciamentoDePremios extends StatelessWidget {
  const GerenciamentoDePremios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeGerenciamentoDePremios(),
    );
  }
}

class HomeGerenciamentoDePremios extends StatefulWidget {
  const HomeGerenciamentoDePremios({Key? key}) : super(key: key);

  @override
  _HomeGerenciamentoDePremiosState createState() =>
      _HomeGerenciamentoDePremiosState();
}

class _HomeGerenciamentoDePremiosState
    extends State<HomeGerenciamentoDePremios> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();

  final StorageService _storageService = getIt<StorageService>();
  final AuthService _authService = getIt<AuthService>();

  String? _userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    try {
      final userRole = await _storageService.getUserRole();
      setState(() {
        _userRole = userRole;
      });
    } catch (e) {
      setState(() {});
      print('Erro ao obter papel do usuário: $e');
    }
  }

  List<Map<String, String>> premios = [];

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    valorController.dispose();
    validadeController.dispose();
    super.dispose();
  }

  void adicionarProduto() {
    String nome = nomeController.text;
    String quantidade = quantidadeController.text;
    String valor = valorController.text;
    String validade = validadeController.text;

    if (nome.isNotEmpty &&
        quantidade.isNotEmpty &&
        valor.isNotEmpty &&
        validade.isNotEmpty) {
      setState(() {
        premios.add({
          'nome': nome,
          'quantidade': quantidade,
          'valor': valor,
          'validade': validade,
        });
      });

      nomeController.clear();
      quantidadeController.clear();
      valorController.clear();
      validadeController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  void excluirProduto(int index) {
    setState(() {
      premios.removeAt(index);
    });
  }

  void limparTudo() {
    setState(() {
      premios.clear();
    });
    nomeController.clear();
    quantidadeController.clear();
    valorController.clear();
    validadeController.clear();
    print("Todos os campos foram limpos.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(
        text: 'Gerenciamento de premios',
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
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
              title: Text('Gerenciamento de reservas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => GerenciamentoDeReserva()),
                );
              },
            ),
            FutureBuilder<String?>(
              future: _storageService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar o papel do usuário: ${snapshot.error}');
                } else {
                  _userRole = snapshot.data;
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
            ),
            FutureBuilder<String?>(
              future: _storageService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar o papel do usuário: ${snapshot.error}');
                } else {
                  _userRole = snapshot.data;
                  return _userRole != 'PlatformAdministrator'
                      ? ListTile(
                          title: Text('Cadastro de Funcionario'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CadastroDeFuncionario()),
                            );
                          },
                        )
                      : Container();
                }
              },
            ),
            FutureBuilder<String?>(
              future: _storageService.getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar o papel do usuário: ${snapshot.error}');
                } else {
                  _userRole = snapshot.data;
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF8DCBC8),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome do prêmio",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF8DCBC8)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantidadeController,
                      decoration: InputDecoration(
                        labelText: "Quantidade disponível",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8DCBC8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: valorController,
                      decoration: InputDecoration(
                        labelText: "Valor do prêmio",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8DCBC8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: validadeController,
                      decoration: InputDecoration(
                        labelText: "Validade do prêmio",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF8DCBC8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextButton(
                        onPressed: () {}, //_getImage,
                        style: TextButton.styleFrom(
                          side: BorderSide(color: Color(0xFF8DCBC8)),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF8DCBC8),
                        ),
                        child: Text(
                          "Adicionar Imagem",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // Espaço entre os botões
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextButton(
                        onPressed: adicionarProduto,
                        style: TextButton.styleFrom(
                          side: BorderSide(color: Color(0xFF8DCBC8)),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF8DCBC8),
                        ),
                        child: Text(
                          "Adicionar Produto",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: premios.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(premios[index]['nome']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantidade: ${premios[index]['quantidade']}"),
                          Text("Valor: ${premios[index]['valor']}"),
                          Text("Validade: ${premios[index]['validade']}"),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          excluirProduto(index);
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Você possui ${premios.length} prêmios adicionados"),
                  Spacer(),
                  ElevatedButton(
                    onPressed: limparTudo,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 45),
                      side: BorderSide(color: Color(0xFF8DCBC8)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      "Limpar tudo",
                      style: TextStyle(
                        color: Color(0xFF8DCBC8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const GerenciamentoDePremios());
}
