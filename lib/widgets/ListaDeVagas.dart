import 'package:flutter/material.dart';

import '../models/ParkingSpaceModel.dart';

class ListaDeVagas extends StatefulWidget {
  final List<ParkingSpaceModel> parkingSpaces;
  final Function(ParkingSpaceModel) onVagaEditada;

  const ListaDeVagas({Key? key, required this.parkingSpaces, required this.onVagaEditada}) : super(key: key);

  @override
  _ListaDeVagasState createState() => _ListaDeVagasState();
}

class _ListaDeVagasState extends State<ListaDeVagas> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: widget.parkingSpaces.length,
      itemBuilder: (context, index) {
        final space = widget.parkingSpaces[index];
        return GestureDetector(
          onTap: () {
            _showEditDialog(context, space);
          },
          child: Column(
            children: [
              Text(space.name, style: const TextStyle(fontSize: 12)), // Exibe o nome da vaga
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getColor(space.type),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  space.isOccupied ? Icons.directions_car : Icons.directions_car_filled,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(space.isOccupied ? 'Ocupado' : 'Livre', style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, ParkingSpaceModel space) {
    String? novoTipo = space.type;
    int novoAndar = space.floor;
    bool novaOcupacao = space.isOccupied;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Vaga'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: Text('Andar'),
                value: novoTipo,
                onChanged: (value) => setState(() => novoTipo = value),
                items: [_buildDropdownMenuItem('Elétrico', 'Electric'),
                  _buildDropdownMenuItem('Combustão', 'Combustion'),
                  _buildDropdownMenuItem('PCD', 'Pcd'),
                ],
              ),
              TextFormField(
                initialValue: novoAndar.toString(),
                onChanged: (value) => setState(() => novoAndar = int.tryParse(value) ?? 0),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: const Text('Ocupada'),
                value: novaOcupacao,
                onChanged: (value) => setState(() => novaOcupacao = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final novaVaga = ParkingSpaceModel(
                  id: space.id,
                  floor: novoAndar,
                  name: space.name,
                  isOccupied: novaOcupacao,
                  type: novoTipo!,
                );
                widget.onVagaEditada(novaVaga); // Notifica a tela principal
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Color _getColor(String tipo) {
    switch (tipo) {
      case 'Electric':
        return Colors.blue; // Azul para elétrico
      case 'Combustion':
        return Colors.green; // Verde para combustão
      case 'Pcd':
        return Colors.yellow; // Amarelo para pcd
      default:
        return Colors.grey; //cinza para outros
    }
  }

  DropdownMenuItem<String> _buildDropdownMenuItem(String label, String value) {
    return DropdownMenuItem<String>(
      value: value, // Valor em inglês
      child: Text(label), // Texto em português
    );
  }
}