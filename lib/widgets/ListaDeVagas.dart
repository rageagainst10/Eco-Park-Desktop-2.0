import 'package:ecoparkdesktop/models/locationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../models/ParkingSpaceModel.dart';

class ListaDeVagas extends StatelessWidget {
  final List<ParkingSpaceModel> parkingSpaces;

  const ListaDeVagas({Key? key, required this.parkingSpaces}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: parkingSpaces.length,
      itemBuilder: (context, index) {
        final space = parkingSpaces[index];
        return ListTile(
          title: Text('Vaga: ${space.name}'),
          subtitle: Text('Tipo: ${space.type}, Andar: ${space.floor + 1}'),
          trailing: Icon(
            space.isOccupied ? Icons.directions_car : Icons.directions_car_filled,
            color: space.isOccupied ? Colors.green : Colors.red,
          ),
          // Opcional: Adicionar um onTap para permitir ações na vaga (editar, reservar, etc.)
          onTap: () {
            // Lógica para lidar com o toque na vaga
          },
        );
      },
    );
  }
}
