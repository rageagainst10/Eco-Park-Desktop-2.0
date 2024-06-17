abstract class BaseAuthService {
  Future<void> login(String email, String senha);
  Future<void> logout();
}
