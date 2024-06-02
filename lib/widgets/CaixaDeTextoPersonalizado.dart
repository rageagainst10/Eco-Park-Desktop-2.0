import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class CaixaDeTextoPersonalizado extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;

  final Function(String)? onSubmitted;

  const CaixaDeTextoPersonalizado({
    Key? key,
    required this.hintText,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);
  @override
  _CaixaDeTextoPersonalizadoState createState() =>
      _CaixaDeTextoPersonalizadoState();
}

class _CaixaDeTextoPersonalizadoState extends State<CaixaDeTextoPersonalizado> {
  String? _errorMessage;

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
          errorText: _errorMessage,
          hintStyle: const TextStyle(color: Colors.black),
        ),
        onSubmitted: widget.onSubmitted,
        onChanged: (value) {
          setState(() {
            _errorMessage = AuthService.validarEmail(value)
                ? null
                : 'Formato de e-mail inválido';
          });
        },
      ),
    );
  }
}
