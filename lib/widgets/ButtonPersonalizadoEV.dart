import 'package:flutter/material.dart';

class BotaoPersonalizado extends StatelessWidget {
  const BotaoPersonalizado({
    Key? key,
    required this.textController,
    this.buttonText = 'Vaga para PDC',
    this.buttonColor = Colors.white,
  }) : super(key: key);

  final TextEditingController textController;
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      child: ElevatedButton(
        onPressed: () {
          // Ação a ser executada quando o botão for pressionado
          print('Texto digitado: ${textController.text}');
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: const Color(0xFF8DCBC8), // Cor da borda
            width: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: buttonColor, // Cor de fundo do botão
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
              buttonText, // Texto do botão
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
