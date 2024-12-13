import 'package:chat_app/data/auth_api.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>(
  (ref) => AuthStateNotifier(ref.read(authRepositoryProvider)),
);

final authRepositoryProvider = Provider((ref) => AuthRepository(AuthApi()));

class AuthStateNotifier extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(null) {
    state = _authRepository.currentUser;
  }

  Future<void> login(String username) async {
    await _authRepository.login(username);
    state = _authRepository.currentUser;
  }

  void logout() {
    _authRepository.logout();
    state = null;
  }
}
