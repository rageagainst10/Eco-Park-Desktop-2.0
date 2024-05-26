import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import '../widgets/AppBarPersonalizado.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado(),
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
              title: Text('Gen. Reservas'),
              onTap: () {
                // Adicione funcionalidade para o Botão 1
                Navigator.pop(context); // Fecha o Drawer
                Navigator.pushNamed(context, '/gen_reservas'); // Navega para a tela de reservas
              },
            ),
            ListTile(
              title: Text('His. Reservas'),
              onTap: () {
                // Adicione funcionalidade para o Botão 2
                Navigator.pop(context); // Fecha o Drawer
                Navigator.pushNamed(context, '/his_reservas'); // Navega para a tela de histórico de reservas
              },
            ),
            // Adicione mais widgets ListTile para botões adicionais, se necessário
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
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
              SizedBox(height: 10,),
              Text(
                "Criar acesso",
                style: TextStyle(
                  color: Color(0xFF8DCBC8), // Definindo a cor do texto
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15), // Adicionando borda de raio 15
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Digite algo',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(15), // Adicionando borda de raio 15
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Digite algo',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 15,),
                  CaixaDeTextoCadastro(texto: 'E-mail'),
                  SizedBox(height: 15,),
                  CaixaDeTextoCadastro(texto: 'Senha'),
                  SizedBox(height: 15,),
                  CaixaDeTextoCadastro(texto: 'Confirmar Senha'),
                  SizedBox(height: 15,),
                  CaixaDeTextoCadastro(texto: 'ID/Gestor'),
                  SizedBox(height: 15,)
                ],
              ),
              // Adicione outros widgets aqui para o conteúdo da tela
            ],
          ),
        ),
      ),
    );
  }
}
