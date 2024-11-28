import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(
    this.isEmailVerified,
  );

  //factory constructer
  factory AuthUser.fromfirebase(User user) {
    return AuthUser(user.emailVerified);
  }
}
