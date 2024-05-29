import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/localizacao.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/LocationModel.dart';
import '../models/ParkingSpaceModel.dart';
import '../repositories/gerenciamentoDeReservasRepository.dart';
import '../services/storage_service.dart';
import '../widgets/AppBarPersonalizado.dart';
import '../widgets/ListaDeVagas.dart';


class GerenciamentoDeReserva extends StatefulWidget {
  const GerenciamentoDeReserva({Key? key}) : super(key: key);
  @override
  State<GerenciamentoDeReserva> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<GerenciamentoDeReserva> {
  final StorageService _storageService = getIt<StorageService>();

  List<LocationModel> _estabelecimentos = [];
  LocationModel? _estabelecimentoSelecionado;
  List<ParkingSpaceModel> _vagas = [];
  List<ParkingSpaceModel> _vagasEditadas = [];
  bool _isLoading = true;

  void _onVagaEditada(ParkingSpaceModel vagaEditada) {
    setState(() {
      final index = _vagas.indexWhere((vaga) => vaga.id == vagaEditada.id);
      if (index != -1) {
        _vagas[index] = vagaEditada; // Substitui a vaga antiga pela editada
      }
      _vagasEditadas.add(vagaEditada); // Adiciona à lista de vagas editadas para salvar na API
    });
  }
  void _saveChanges() async {
    try {
      for (var vaga in _vagasEditadas) {
        await ReservaRepository(_storageService).salvarAlteracoes(vaga);
      }

      // Limpar a lista de vagas editadas após salvar
      setState(() {
        _vagasEditadas = [];
      });

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
    } catch (e) {
      // Tratar erro ao salvar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alterações: $e')),
      );
    }
  }


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

  int compareParkingSpaces(ParkingSpaceModel a, ParkingSpaceModel b) {
    final RegExp regex = RegExp(r'(\d+)'); // Expressão regular para extrair números

    final matchA = regex.firstMatch(a.name);
    final matchB = regex.firstMatch(b.name);

    if (matchA == null || matchB == null) {
      return a.name.compareTo(b.name); // Se não houver números, compara as strings normalmente
    }

    final numA = int.parse(matchA.group(0)!); // Extrai e converte o número para inteiro
    final numB = int.parse(matchB.group(0)!);

    if (numA == numB) {
      return a.name.compareTo(b.name); // Se os números forem iguais, compara as strings
    } else {
      return numA.compareTo(numB);    // Se os números forem diferentes, compara os números
    }
  }
  Future<void> _loadVagas(String estabelecimentoId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locations = await ReservaRepository(_storageService).getLocations();

      // Encontra a localização com o ID especificado
      final location = locations.firstWhere((loc) => loc.id == estabelecimentoId);

      // Ordena as vagas da localização encontrada
      location.parkingSpaces.sort(compareParkingSpaces);
      setState(() {
        _vagas = location.parkingSpaces; // Supondo que só há uma localização por estabelecimento
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
        ? const Center(child: CircularProgressIndicator())
        : Expanded(child: ListaDeVagas(parkingSpaces: _vagas, onVagaEditada: _onVagaEditada));
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
              title: Text('Cadastro de Localizacao'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LocalizacaoCadastro()),
                );
              },
            ),
            ListTile(
              title: Text('Gerenciamento de Premios'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GerenciamentoDePremios()),
                );
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Login()),
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
            hint: const Text("Selecionar localização"),
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
                  : Expanded(
                child: Column(
                  children: [
                    Expanded(child: ListaDeVagas(parkingSpaces: _vagas, onVagaEditada: _onVagaEditada,)), // Grade de vagas
                    _buildLegenda(), // Legenda de cores
                    ElevatedButton(
                      onPressed: _saveChanges, // Chama o método para salvar as alterações
                      child: const Text('Salvar Alterações'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }
  Widget _buildLegenda() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendaItem(Colors.blue, 'Elétrico'),
          _buildLegendaItem(Colors.green, 'Combustão'),
          _buildLegendaItem(Colors.yellow, 'Pcd'),
        ],
      ),
    );
  }

  Widget _buildLegendaItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
