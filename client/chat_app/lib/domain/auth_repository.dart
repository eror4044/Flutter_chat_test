import 'package:chat_app/data/auth_api.dart';
import 'package:chat_app/models/user_model.dart';

class AuthRepository {
  final AuthApi _authApi;
  User? _currentUser;

  AuthRepository(this._authApi);

  User? get currentUser => _currentUser;

  Future<void> login(String username) async {
    final token = await _authApi.login(username);
    _currentUser = User(username: username, token: token);
  }

  void logout() {
    _currentUser = null;
  }
}
