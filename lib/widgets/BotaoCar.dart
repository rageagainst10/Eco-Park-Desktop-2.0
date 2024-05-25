import 'package:flutter/material.dart';


class BotaoCar extends StatelessWidget {
  const BotaoCar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Adicione ação desejada aqui
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Color(0xFF8DCBC8) ,
        padding: const EdgeInsets.all(16), // Espaçamento interno do botão
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borda arredondada
        ),
      ),
      child: Icon(
        Icons.directions_car, // Ícone de carro
        color: Colors.black, // Cor do ícone
        size: 32, // Tamanho do ícone
      ),
    );
  }
}
