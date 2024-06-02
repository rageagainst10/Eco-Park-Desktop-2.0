import 'package:flutter/material.dart';

class AppBarPersonalizado extends StatelessWidget
    implements PreferredSizeWidget {
  final String text; // Adicionando o parâmetro text

  const AppBarPersonalizado({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Color(0xFF8DCBC8), // Defina a cor de fundo da barra de aplicativos
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Alinha os elementos no espaço disponível
        children: [
          Text(
            text, // Usando o texto fornecido
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'ECO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: 'PARK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Altura desejada
}
