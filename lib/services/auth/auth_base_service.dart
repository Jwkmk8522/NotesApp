import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBaseService {
  Future<void> initialize();
  User? get currentUser;
  Future<User?> logIn({
    required String email,
    required String password,
  });
  Future<User?> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();

  Future<void> forgetpassword({required String email});

  // Future<User?> signinwithgoogle();
}
