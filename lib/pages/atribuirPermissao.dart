import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/AppBarPersonalizado.dart';

class AtribuirPermissao extends StatefulWidget {
  const AtribuirPermissao({Key? key}) : super(key: key);

  @override
  State<AtribuirPermissao> createState() => _AtribuirPermissaoState();
}

class _AtribuirPermissaoState extends State<AtribuirPermissao> {
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
      body: Text("oi"),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AtribuirPermissao(),
  ));
}
