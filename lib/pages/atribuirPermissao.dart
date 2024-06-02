import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:get_it/get_it.dart';

import '../main.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AtribuirPermissao extends StatefulWidget {
  const AtribuirPermissao({Key? key}) : super(key: key);

  @override
  State<AtribuirPermissao> createState() => _AtribuirPermissaoState();
}

class _AtribuirPermissaoState extends State<AtribuirPermissao> {
  final StorageService _storageService = GetIt.I<StorageService>();
  final AuthService _authService =
  getIt<AuthService>(); // Obter instância do AuthService

  // Lista de itens para o dropdown
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  // Valor selecionado
  String? _selectedFuncionario;
  String? _selectedPermissao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarPersonalizado(
        text: 'Atribuir Localização',
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
            ListTile(
              title: const Text('Cadastro de Localização'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CadastroDeLocalizacao(),
                  ),
                );
              },
            ),
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
                value: _selectedFuncionario,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFuncionario = newValue;
                  });
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                  height: 20), // Adiciona espaçamento entre os DropdownButtons
              DropdownButton<String>(
                hint: const Text('Selecionar Localização'),
                value: _selectedPermissao,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPermissao = newValue;
                  });
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                height: 40,
                width: 250,
                child: TextButton(
                  onPressed: () {
                    // Adicionar lógica para associar localização ao funcionário
                    if (_selectedFuncionario != null &&
                        _selectedPermissao != null) {
                      // Implementar a lógica de associação aqui
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Localização $_selectedPermissao atribuída a $_selectedFuncionario'),
                        ),
                      );
                    } else {
                      // Mensagem de erro caso algum campo não esteja selecionado
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, selecione o funcionário e a localização.'),
                        ),
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
