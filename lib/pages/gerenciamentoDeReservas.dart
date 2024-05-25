import 'package:flutter/material.dart';
import '../widgets/AppBarPersonalizado.dart';

class GerenciamentoDeReserva extends StatefulWidget {
  const GerenciamentoDeReserva({Key? key}) : super(key: key);

  @override
  State<GerenciamentoDeReserva> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<GerenciamentoDeReserva> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(),
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
                // Adicione funcionalidade para o Botão 1
              },
            ),
            ListTile(
              title: Text('His. Reservas'),
              onTap: () {
                // Adicione funcionalidade para o Botão 2
              },
            ),
            // Adicione mais widgets ListTile para botões adicionais, se necessário
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF8DCBC8),
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Text(
                      'Nome do estabelecimento',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 280,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Informe o numero de andares...',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 30), // Espaçamento entre a caixa de texto e o botão
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação a ser executada quando o botão for pressionado
                        print('Texto digitado: ${_textController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xFF8DCBC8), // Cor da borda
                          width: 2.0,
                        ),
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black
                        ),
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
