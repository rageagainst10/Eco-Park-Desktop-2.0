import 'package:flutter/material.dart';

class CaixaDeTextoCadastro extends StatelessWidget {
  final String texto;
  final TextEditingController controller;

  const CaixaDeTextoCadastro({
    Key? key,
    required this.texto,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
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
            hintText: texto, // Usando o texto fornecido como dica para o campo de texto
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(8.0),
          ),
          controller: controller,
        ),
      ),
    );
  }
}
