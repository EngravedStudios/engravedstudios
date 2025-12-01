import '../entities/user.dart';

abstract class IAuthRepository {
  Future<AppUser?> getCurrentUser();
  Future<AppUser> login({required String email, required String password});
  Future<void> loginWithOAuth2({required String provider});
  Future<AppUser> signup({required String email, required String password, required String name});
  Future<void> logout();
  Future<void> updateName(String name);
  Future<void> updatePassword({required String newPassword, String? oldPassword});
  Future<void> updateEmail({required String email, required String password});
  Future<void> createVerification({required String url});
  Future<void> updatePrefs(Map<String, dynamic> prefs);
  Future<Map<String, dynamic>> getPrefs();
  Future<void> deleteAccount();
}
