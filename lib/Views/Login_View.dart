import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exception.dart';
import 'package:notesapp/services/auth/auth_service.dart';

import '../utilities/showmessage.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text('Login View'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: "Enter Your Password"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService.firebase()
                        .login(email: email, password: password);
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
//user is verified
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/notes/', (route) => false);
                    } else {
//user is not verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Verifyemailroute, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showmessage(
                        context, 'User is not Register first register');
                  } on WrongPasswordAuthException {
                    await showmessage(
                        context, 'Enter valid Password for This email');
                  } on InvalidEmailAuthException {
                    await showmessage(context, "Invalid email");
                  } on GenericAuthException {
                    await showmessage(context, "Error :User not login in ");
                  }
                },
                child: const Text("Login ")),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/regester/', (route) => false);
                },
                child: const Text("Create an account"))
          ],
        ));
  }
}
