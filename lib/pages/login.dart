
import 'package:ecoparkdesktop/pages/cadastro.dart';
import 'package:ecoparkdesktop/pages/gerenciamentoDeReservas.dart';
import 'package:ecoparkdesktop/pages/localizacao.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoPersonalizado.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoPersonalizadoSenha.dart';
import 'package:flutter/material.dart';
import 'package:ecoparkdesktop/repositories/auth_repository.dart';
import 'package:ecoparkdesktop/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../main.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AuthService _authService = getIt<AuthService>();// Obter instância do AuthService
  bool _isLoading = false;

  void _login() async {
    String email = _emailController.text;
    String senha = _senhaController.text;

    if(!AuthService.validarEmail(email)){
      return;
    }

    setState(() {
      _isLoading = true; // Mostrar indicador de carregamento
    });

    try {
      await _authService.login(email, senha);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocalizacaoCadastro()));
    } catch (error) {
      // Exibir mensagem de erro (snackbar, diálogo, etc.)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro no login: $error'),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Esconder indicador de carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFFF3F9F8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: Image.asset("assets/images/logoEcoPark1.png"),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                      children: [
                        TextSpan(
                          text: "Reserve, Conserve, Descubra\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Sua Vaga, Sua Pegada",
                          style: TextStyle(
                            color: Color(0xFF8DCBC8),
                          ),
                        ),
                        TextSpan(
                          text: ", Sua\n",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Eco",
                          style: TextStyle(
                            color: Color(0xFF8DCBC8),
                          ),
                        ),
                        TextSpan(
                          text: "Park",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  SizedBox(
                    height: 200,
                    width: 400,
                    child: Image.asset("Assets/Images/text.png"),
                  ),
                  const SizedBox(height: 20),
                  SizedBox( // Adiciona um SizedBox para definir a largura da caixa de texto de e-mail
                    width: 350, // Define a largura desejada (ajuste conforme necessário)
                    child: CaixaDeTextoPersonalizado(
                      hintText: 'E-mail',
                      controller: _emailController,
                      onSubmitted: (_) => _login(), // Chama a função _login ao pressionar Enter
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox( // Adiciona um SizedBox para definir a largura da caixa de texto de senha
                    width: 350, // Define a mesma largura da caixa de texto de e-mail
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CaixaDeTextoPersonalizadoSenha(
                              hintText: 'Senha',
                              controller: _senhaController,
                              onSubmitted: (_) => _login(), // Chama a função _login ao pressionar Enter
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 350,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => _login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8DCBC8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isLoading // Mostrar indicador de carregamento se estiver carregando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Cadastro()),
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
                        text: "Nao possui uma conta? ",
                        style: TextStyle(
                          color: Color(0xFF5C5C5C),
                        ),
                      ),
                      TextSpan(
                        text: "Cadastre-se",
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
        ],
      ),
    );
  }
}

