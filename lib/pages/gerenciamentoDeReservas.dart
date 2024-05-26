import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/historicoDeReserva.dart';
import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/widgets/BotaoCar.dart'; // Importe o BotaoCar aqui
import '../widgets/AppBarPersonalizado.dart';

// Comente a importação da API se não for utilizá-la agora
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class GerenciamentoDeReserva extends StatefulWidget {
  const GerenciamentoDeReserva({Key? key}) : super(key: key);

  @override
  State<GerenciamentoDeReserva> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<GerenciamentoDeReserva> {
  TextEditingController _textController = TextEditingController();
  Map<Color, int> _carCounts = {
    Colors.blue: 0,
    Colors.green: 0,
    Colors.yellow: 0,
  };

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateCarCount(Color color) {
    setState(() {
      _carCounts[color] = (_carCounts[color] ?? 0) + 1;
    });
  }

  // Comente a função de salvar alterações se não for utilizá-la agora
  /*
  void _saveChanges() async {
    final data = {
      'nome_estabelecimento': _textController.text,
      'car_counts': {
        'vaga_pdc': _carCounts[Colors.blue],
        'vaga_combustao': _carCounts[Colors.green],
        'vaga_eletrico': _carCounts[Colors.yellow],
      },
    };

    final response = await http.post(
      Uri.parse('http://suaapi.com/endpoint'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Dados salvos com sucesso!');
    } else {
      print('Erro ao salvar os dados: ${response.statusCode}');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(
        text: 'Gerenciamento de reservas', // Passando o texto desejado para o AppBarPersonalizado
      ),
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
              title: Text('Gen. De premios'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDePremios()),
                );
              },
            ),
            ListTile(
              title: Text('His. Reservas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoricoDeReservas()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF8DCBC8),
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
                        hintText: 'Informe o número de andares...',
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Texto digitado: ${_textController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: const Color(0xFF8DCBC8),
                          width: 2.0,
                        ),
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 450,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF8DCBC8),
                    width: 2.0,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 60),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                      ],
                    ),
                    SizedBox(width: 3),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                      ],
                    ),
                    SizedBox(width: 70),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                      ],
                    ),
                    SizedBox(width: 3),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                        SizedBox(height: 3),
                        BotaoCar(onColorChanged: _updateCarCount),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {
                    // _saveChanges();
                    print('Salvar alterações');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8DCBC8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Salvar alterações',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Carro a Combustao ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Carro eletrico',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Vaga para PDC ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
