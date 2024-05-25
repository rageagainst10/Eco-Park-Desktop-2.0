import 'package:flutter/material.dart';

class BotaoPersonalizado extends StatelessWidget {
  const BotaoPersonalizado({super.key});

  @override
  Widget build(BuildContext context) {
    // Criar um controlador de texto dentro de um StatefulWidget seria mais apropriado
    // para ter controle sobre o valor da entrada de texto. Vou manter um controlador aqui para exemplo.
    TextEditingController _textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Botão Personalizado")),
      body: Center(
        child: Container(
          width: 250,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white, // Cor de fundo do botão
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car, // Ícone à esquerda
                  color: Colors.black,
                ),
                SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                Text(
                  'Vaga para PDC',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BotaoPersonalizado(),
  ));
}
