import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/historicoDeReserva.dart';
import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/widgets/BotaoCar.dart'; // Importe o BotaoCar aqui
import '../main.dart';
import '../models/LocationModel.dart';
import '../models/ParkingSpaceModel.dart';
import '../repositories/gerenciamentoDeReservasRepository.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/AppBarPersonalizado.dart';
import '../widgets/ListaDeVagas.dart';

// Comente a importação da API se não for utilizá-la agora
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class GerenciamentoDeReserva extends StatefulWidget {
  const GerenciamentoDeReserva({Key? key}) : super(key: key);
  @override
  State<GerenciamentoDeReserva> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<GerenciamentoDeReserva> {
  final AuthService _authService = getIt<AuthService>();
  final StorageService _storageService = getIt<StorageService>();

  List<LocationModel> _estabelecimentos = [];
  LocationModel? _estabelecimentoSelecionado;
  List<ParkingSpaceModel> _vagas = [];
  bool _isLoading = true;

  Future<String?> _getToken() async {
    return await _storageService.getToken();
  }
  @override
  void initState() {
    super.initState();
    _loadEstabelecimentos();
  }

  Future<void> _loadEstabelecimentos() async {
    try {
      final estabelecimentos = await ReservaRepository(_storageService).getLocations();
      setState(() {
        _estabelecimentos = estabelecimentos;
        _isLoading = false;
      });
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> _loadVagas(String estabelecimentoId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locations = await ReservaRepository(_storageService).getLocations();
      setState(() {
        _vagas = locations.first.parkingSpaces; // Supondo que só há uma localização por estabelecimento
        _isLoading = false;
      });
    } catch (e) {
      // Tratar erro
    }
  }

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





  @override
  Widget build(BuildContext context) {
    _isLoading
        ? const CircularProgressIndicator()
        : Expanded(child: ListaDeVagas(parkingSpaces: _vagas));
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
          DropdownButton<LocationModel>(
          value: _estabelecimentoSelecionado,
            items: _estabelecimentos.map((location) {
              return DropdownMenuItem<LocationModel>(
                value: location,
                child: Text(location.name),
              );
            }).toList(),
            onChanged: (LocationModel? newValue) {
              setState(() {
                _estabelecimentoSelecionado = newValue;
                if (newValue != null) {
                  _loadVagas(newValue.id);
                }
              });
            },
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(child: ListaDeVagas(parkingSpaces: _vagas)), // Exibir a lista de vagas
          ],
        ),
      ),
    ),
    );
  }
}
