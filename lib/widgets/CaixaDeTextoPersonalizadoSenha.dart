import 'package:flutter/material.dart';

class CaixaDeTextoPersonalizadoSenha extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;

  const CaixaDeTextoPersonalizadoSenha({
    Key? key,
    required this.hintText,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _CaixaDeTextoPersonalizadoSenhaState createState() => _CaixaDeTextoPersonalizadoSenhaState();
}

class _CaixaDeTextoPersonalizadoSenhaState extends State<CaixaDeTextoPersonalizadoSenha> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(
              color: Color(0xFF8DCBC8), // Cor correta
              width: 2.0,
            ),
          ),
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintStyle: const TextStyle(color: Colors.black),
        ),
        obscureText: _obscureText,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}

