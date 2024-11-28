import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:notesapp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  AuthProvider provider;
  AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createuser({
    required String email,
    required String password,
    required String name,
  }) {
    return provider.createuser(email: email, password: password, name: name);
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    return provider.login(email: email, password: password);
  }

  @override
  Future<void> sendemailverification() {
    return provider.sendemailverification();
  }

  @override
  Future<void> logout() {
    return provider.logout();
  }

  @override
  Future<void> initilization() async {
    await provider.initilization();
  }

  @override
  Future<void> forgetpassword({required String email}) async {
    await provider.forgetpassword(email: email);
  }
}
