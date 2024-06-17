import 'package:ecoparkdesktop/main.dart';
import 'package:ecoparkdesktop/services/base_auth_service.dart';

import '../models/LoginModel.dart';
import '../repositories/AuthRepository.dart';
import '../services/storage_service.dart';

class AuthService extends BaseAuthService{
  final AuthRepository _authRepository;
  final StorageService _storageService = getIt<StorageService>();
  LoginModel? _currentUser;

  AuthService(this._authRepository);

  @override
  Future<void> login(String email, String senha) async {
    _currentUser = await _authRepository.login(email, senha);
  }

  bool get isLoggedIn => _currentUser != null;

  LoginModel? get currentUser => _currentUser;

  @override
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