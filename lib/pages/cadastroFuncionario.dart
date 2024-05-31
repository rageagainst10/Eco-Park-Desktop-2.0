import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ecoparkdesktop/pages/localizacao.dart';
import 'package:ecoparkdesktop/repositories/FuncionarioRepository.dart'; // Importe o repositório
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:ecoparkdesktop/widgets/CaixaDeTextoCadastro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../models/FormularioModel.dart'; // Para File
import 'package:mime/mime.dart';

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

  final StorageService _storageService = GetIt.I<StorageService>();

  Uint8List? _imageData;
  String? _mimeType;
  String? _imageName;
  File? _imagem;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    _imageName = pickedFile?.name;
    _mimeType = lookupMimeType(pickedFile!.path.split('/').last);

    if (pickedFile != null) {
      _imageData = await pickedFile.readAsBytes(); // Lê os bytes da imagem
      setState(() {
        _imagem = File(pickedFile.path);
      }); // Atualiza o estado para exibir a imagem selecionada (opcional)
    }
  }

  void _cadastrarFuncionario() async {
    // Criar uma instância do modelo de dados com os valores dos campos de texto
    FormularioData data = FormularioData(
      nome: _nomeController.text,
      sobrenome: _sobrenomeController.text,
      idGestor: _idGestorController.text,
      email: _emailController.text,
      senha: _senhaController.text,
    );

    try {
      final token =
          await _storageService.getToken(); // Obter o token do StorageService

      if (token == null) {
        throw Exception('Usuário não autenticado');
      }

      await FuncionarioRepository(_storageService).cadastrarFuncionario(
        data.nome,
        data.sobrenome,
        data.idGestor,
        data.email,
        data.senha,
        _imageData,
        _mimeType,
        _imageName,
      );
    } catch (e) {
      // Tratar erro
      print('Erro ao cadastrar funcionário: $e');
    }
    print('Enviando dados para a API: $data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 600,
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
                "Cadastrar Funcionário",
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
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Escolher Imagem'),
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 315,
                child: TextButton(
                  onPressed: () {
                    _cadastrarFuncionario();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => LocalizacaoCadastro()),
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
              _imagem != null // Exibe a imagem se ela foi selecionada
                  ? Image.memory(
                _imageData!,
                width: 100, // Ajuste a largura conforme necessário
                height: 100, // Ajuste a altura conforme necessário
              )
                  : const SizedBox.shrink(), // Não exibe nada se não houver imagem
            ],
          ),
        ),
      ),
    );
  }
}
