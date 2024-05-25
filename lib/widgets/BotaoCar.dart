import 'package:flutter/material.dart';

class BotaoCar extends StatefulWidget {
  final Function(Color) onColorChanged;

  BotaoCar({Key? key, required this.onColorChanged}) : super(key: key);

  @override
  _BotaoCarState createState() => _BotaoCarState();
}

class _BotaoCarState extends State<BotaoCar> {
  Color _currentColor = Colors.blue;
  String _currentValue = 'vaga pdc';

  void _toggleColor() {
    setState(() {
      if (_currentColor == Colors.blue) {
        _currentColor = Colors.green;
        _currentValue = 'vaga combustao';
      } else if (_currentColor == Colors.green) {
        _currentColor = Colors.yellow;
        _currentValue = 'vaga eletrico';
      } else {
        _currentColor = Colors.blue;
        _currentValue = 'vaga pdc';
      }
      widget.onColorChanged(_currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggleColor,
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentColor,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Icon(
        Icons.directions_car,
        color: Colors.black,
        size: 32,
      ),
    );
  }
}
