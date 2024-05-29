import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  UserModel? _currentUser;

  AuthService(this._authRepository);

  Future<void> login(String email, String senha) async {
    _currentUser = await _authRepository.login(email, senha);
  }

  bool get isLoggedIn => _currentUser != null;

  UserModel? get currentUser => _currentUser;

  void logout() {
    _currentUser = null;
  }

  static bool validarEmail(String email) {
    // Expressão regular para validar o formato do e-mail
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}