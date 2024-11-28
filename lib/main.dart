import 'package:flutter/material.dart';
import 'package:notesapp/Views/forgetpassword.dart';

import 'package:notesapp/Views/login_view.dart';
import 'package:notesapp/Views/notesview.dart';
import 'package:notesapp/Views/register_view.dart';
import 'package:notesapp/Views/verify_email.dart';
import 'package:notesapp/services/auth/auth_service.dart';

import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          Loginviewroute: (context) => const LoginView(),
          Regesterviewroute: (context) => const Regester(),
          Notesviewroute: (context) => const NotesView(),
          Verifyemailroute: (context) => const VerifyEmail(),
          Forgetpasswordroute: (context) => const Forgetpassword(),
        },
        home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initilization(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
