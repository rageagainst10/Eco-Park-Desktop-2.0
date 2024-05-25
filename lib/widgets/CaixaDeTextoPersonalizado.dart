import 'package:flutter/material.dart';

class CaixaDeTextoPersonalizado extends StatelessWidget {
  final String hintText;

  const CaixaDeTextoPersonalizado({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(
              color: Color(0xFF8DCBC8), // Cor correta
              width: 2.0,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
        ),
        obscureText: true,
      ),
    );
  }
}

