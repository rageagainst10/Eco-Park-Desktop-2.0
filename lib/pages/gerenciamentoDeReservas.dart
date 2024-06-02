import 'package:ecoparkdesktop/pages/AtribuirPermissao.dart';
import 'package:ecoparkdesktop/pages/atualizarDados.dart';
import 'package:ecoparkdesktop/pages/gerencimentoDePremios.dart';
import 'package:ecoparkdesktop/pages/cadastroLocalizacao.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/LocationModel.dart';
import '../models/ParkingSpaceModel.dart';
import '../repositories/GerenciamentoDeReservasRepository.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../widgets/AppBarPersonalizado.dart';
import '../widgets/ListaDeVagas.dart';
import 'cadastroFuncionario.dart';

class GerenciamentoDeReserva extends StatefulWidget {
  const GerenciamentoDeReserva({Key? key}) : super(key: key);

  @override
  State<GerenciamentoDeReserva> createState() => _GerenciamentoDeReservaState();
}

class _GerenciamentoDeReservaState extends State<GerenciamentoDeReserva> {
  final StorageService _storageService = getIt<StorageService>();
  final AuthService _authService =
  getIt<AuthService>(); // Obter instância do AuthService

  final TextEditingController _textController = TextEditingController();

  List<LocationModel> _estabelecimentos = [];
  LocationModel? _estabelecimentoSelecionado;
  List<ParkingSpaceModel> _vagas = [];
  List<ParkingSpaceModel> _vagasEditadas = [];
  bool _isLoading = true;

  String? _userRole;
  @override
  void initState() {
    super.initState();
    _getUserRole();
    _loadEstabelecimentos();
  }

  Future<void> _getUserRole() async {
    try {
      final userRole = await _storageService.getUserRole();
      setState(() {
        _userRole = userRole;
      });
    } catch (e) {
      // Tratar erro ao obter o papel do usuário
      setState(() {
      });
      print('Erro ao obter papel do usuário: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadEstabelecimentos() async {
    try {
      final estabelecimentos =
          await ReservaRepository(_storageService).getLocations();
      setState(() {
        _estabelecimentos = estabelecimentos;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadVagas(String estabelecimentoId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final locations = await ReservaRepository(_storageService).getLocations();
      final location =
          locations.firstWhere((loc) => loc.id == estabelecimentoId);
      location.parkingSpaces.sort(compareParkingSpaces);
      setState(() {
        _vagas = location.parkingSpaces;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
    }
  }

  int compareParkingSpaces(ParkingSpaceModel a, ParkingSpaceModel b) {
    final RegExp regex = RegExp(r'(\d+)');
    final matchA = regex.firstMatch(a.name);
    final matchB = regex.firstMatch(b.name);

    if (matchA == null || matchB == null) {
      return a.name.compareTo(b.name);
    }

    final numA = int.parse(matchA.group(0)!);
    final numB = int.parse(matchB.group(0)!);

    return numA == numB ? a.name.compareTo(b.name) : numA.compareTo(numB);
  }

  void _onVagaEditada(ParkingSpaceModel vagaEditada) {
    setState(() {
      final index = _vagas.indexWhere((vaga) => vaga.id == vagaEditada.id);
      if (index != -1) {
        _vagas[index] = vagaEditada;
      }
      _vagasEditadas.add(vagaEditada);
    });
  }

  void _saveChanges() async {
    try {
      for (var vaga in _vagasEditadas) {
        await ReservaRepository(_storageService).salvarAlteracoes(vaga);
      }
      setState(() {
        _vagasEditadas = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar alterações: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(
        text: 'Gerenciamento de reservas',
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: _isLoading ? const CircularProgressIndicator() : _buildContent(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF8DCBC8)),
            child: Text(
              'Outras Páginas',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
              context, 'Gerenciamento de Premios', GerenciamentoDePremios()),
          FutureBuilder<String?>(
            future: _storageService.getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Indicador de carregamento
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
              } else {
                _userRole = snapshot.data; // Atribui o papel do usuário
                return _userRole != 'PlatformAdministrator' && _userRole != 'Employee'
                    ? _buildDrawerItem(
                    context, 'Cadastro de Localização', CadastroDeLocalizacao())
                    : Container();
              }
            },
          ),//Insert Location
          FutureBuilder<String?>(
            future: _storageService.getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Indicador de carregamento
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
              } else {
                _userRole = snapshot.data; // Atribui o papel do usuário
                return _userRole != 'PlatformAdministrator'
                    ? _buildDrawerItem(
                    context, 'Cadastro de Funcionario', CadastroDeFuncionario())
                    : Container();
              }
            },
          ), //Insert Employee
          FutureBuilder<String?>(
            future: _storageService.getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Indicador de carregamento
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
              } else {
                _userRole = snapshot.data; // Atribui o papel do usuário
                return _userRole != 'PlatformAdministrator'
                    ? _buildDrawerItem(
                    context, 'Atribuir Permissão', AtribuirPermissao())
                    : Container();
              }
            },
          ), //Atribuir Permissão
          _buildDrawerItem(context, 'Atualizar Dados', AtualizarDados()),
          _buildDrawerItemLogout(context, 'Sair', Login()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildDrawerItemLogout(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () async {
        await _authService.logout();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildContent() {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8DCBC8), width: 1.0),
        borderRadius: BorderRadius.circular(15),
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
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListaDeVagas(
                    parkingSpaces: _vagas,
                    onVagaEditada: _onVagaEditada,
                  ),
                ),
                _buildLegenda(),
                SizedBox(height: 16), // Espaçamento entre a legenda e o botão
                FutureBuilder<String?>(
                  future: _storageService.getUserRole(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Indicador de carregamento
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar o papel do usuário: ${snapshot.error}'); // Mensagem de erro
                    } else {
                      _userRole = snapshot.data; // Atribui o papel do usuário
                      return _userRole != 'PlatformAdministrator'
                          ? _buildSaveButton()
                      : Container();
                    }
                  },
                ),
                SizedBox(
                    height:
                        16), // Espaçamento entre o botão e a parte de baixo do container
              ],
            ),
          ),
        ],
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 40,
      width: 315,
      child: TextButton(
        onPressed: _saveChanges,
        child: const Text(
          'Salvar Alterações',
          style: TextStyle(color: Color(0xFF8DCBC8)),
        ),
        style: ButtonStyle(
          side: WidgetStateProperty.all<BorderSide>(
            const BorderSide(color: Color(0xFF8DCBC8), width: 2.0),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
