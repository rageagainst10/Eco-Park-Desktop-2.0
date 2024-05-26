import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:flutter/material.dart';
import '../widgets/AppBarPersonalizado.dart';

class HistoricoDeReservas extends StatefulWidget {
  const HistoricoDeReservas({Key? key}) : super(key: key);

  @override
  State<HistoricoDeReservas> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<HistoricoDeReservas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(
        text: 'Histórico de Reservas', // Passando o texto desejado para o AppBarPersonalizado
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
              title: Text('Gen. Reservas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDeReserva()),
                );
              },
            ),
            ListTile(
              title: Text('Gen. Premios'),
              onTap: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDePremios()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "PROBLEMAS TÉCNICOS",
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}

