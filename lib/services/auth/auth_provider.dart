import 'package:notesapp/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createuser({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<void> sendemailverification();

  Future<void> initilization();

  Future<void> forgetpassword({required String email});
}
