import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/pages/atribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';

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
              onTap: () {
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
