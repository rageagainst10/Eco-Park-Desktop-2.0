import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Classe modelo para representar os dados do formulário
class FormularioData {
  final String nome;
  final String sobrenome;
  final String idGestor;
  final String email;
  final String senha;
  final String confirmarSenha;

  FormularioData({
    required this.nome,
    required this.sobrenome,
    required this.idGestor,
    required this.email,
    required this.senha,
    required this.confirmarSenha,
  });
}

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _idGestorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  void _enviarDadosParaAPI() {
    // Criar uma instância do modelo de dados com os valores dos campos de texto
    FormularioData data = FormularioData(
      nome: _nomeController.text,
      sobrenome: _sobrenomeController.text,
      idGestor: _idGestorController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      confirmarSenha: _confirmarSenhaController.text,
    );
    // Aqui você deve enviar os dados para a API
    // Substitua este bloco com a lógica real para enviar os dados para a API
    print('Enviando dados para a API: $data');

    // Exemplo de como fazer uma solicitação POST para a API usando a biblioteca http
    //http.post('sua_url_da_api', body: {
    //   'nome': data.nome,
    //   'sobrenome': data.sobrenome,
    //   'idGestor': data.idGestor,
    //   'email': data.email,
    //   'senha': data.senha,
    //   'confirmarSenha': data.confirmarSenha,
    // }).then((response) {
    //   // Lógica de manipulação da resposta da API
    // }).catchError((error) {
       // Lógica de tratamento de erro
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 10),
              const Text(
                "Criar acesso",
                style: TextStyle(
                  color: Color(0xFF8DCBC8),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nome',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        controller: _nomeController,
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Sobrenome',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                        controller: _sobrenomeController,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'ID/Gestor',
                controller: _idGestorController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'E-mail',
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Senha',
                controller: _senhaController,
              ),
              const SizedBox(height: 15),
              CaixaDeTextoCadastro(
                texto: 'Confirmar Senha',
                controller: _confirmarSenhaController,
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: TextButton(
                  onPressed:(){
                    //_enviarDadosParaAPI
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GerenciamentoDeReserva()),
                    );
                  }, // Corrigido o chamado do método
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: Color(0xFF8DCBC8),
                        width: 2.0,
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Color(0xFF8DCBC8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Já Possui uma conta? ",
                        style: TextStyle(
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                      TextSpan(
                        text: "Entre",
                        style: TextStyle(
                          color: Color(0xFF8DCBC8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
