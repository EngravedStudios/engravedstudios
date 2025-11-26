import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/appwrite_service.dart';
import '../repositories/interfaces/auth_repository_interface.dart';
import '../repositories/implementations/auth_repository.dart';
import '../models/user_model.dart';

final appwriteServiceProvider = Provider<AppwriteService>((ref) {
  return AppwriteService();
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final appwriteService = ref.watch(appwriteServiceProvider);
  return AuthRepository(appwriteService);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final IAuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signup(email: email, password: password, name: name);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithOAuth2(String provider) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.loginWithOAuth2(provider: provider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
