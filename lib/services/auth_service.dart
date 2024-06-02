import 'package:ecoparkdesktop/main.dart';

import '../models/UserModel.dart';
import '../repositories/AuthRepository.dart';
import '../services/storage_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final StorageService _storageService = getIt<StorageService>();
  UserModel? _currentUser;

  AuthService(this._authRepository);

  Future<void> login(String email, String senha) async {
    _currentUser = await _authRepository.login(email, senha);
  }

  bool get isLoggedIn => _currentUser != null;

  UserModel? get currentUser => _currentUser;

  Future<void> logout() async {
    await _storageService.deleteToken();
    await _storageService.deleteUserRole();
    _currentUser = null;
  }

  static bool validarEmail(String email) {
    // Expressão regular para validar o formato do e-mail
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}