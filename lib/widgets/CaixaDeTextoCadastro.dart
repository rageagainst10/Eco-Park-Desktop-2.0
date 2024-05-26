import 'package:flutter/material.dart';

class CaixaDeTextoCadastro extends StatelessWidget {
  final String texto;

  const CaixaDeTextoCadastro({
    Key? key,
    required this.texto,
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
        borderRadius: BorderRadius.circular(15), // Adicionando borda de raio 15
      ),
      child: Center(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Digite algo',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(8.0),
          ),
          controller: TextEditingController(text: texto), // Definindo o texto do TextField
          onChanged: (value) {}, // Adicionando um onChanged vazio para evitar um erro
        ),
      ),
    );
  }
}
