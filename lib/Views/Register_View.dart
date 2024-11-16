import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exception.dart';
import 'package:notesapp/services/auth/auth_service.dart';

import 'package:notesapp/utilities/showmessage.dart';

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
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
          title: const Text('Register'),
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
                        .createuser(email: email, password: password);
                    AuthService.firebase().sendemailverification();
                    Navigator.of(context).pushNamed(
                      Verifyemailroute,
                    );
                  } on WeakPasswordAuthException {
                    await showmessage(context, "your password is weak");
                  } on EmailAlredyInUseAuthException {
                    await showmessage(
                        context, "email is use by another person");
                  } on InvalidEmailAuthException {
                    await showmessage(context, "your email is not valid");
                  } on GenericAuthException {
                    await showmessage(context, 'Not Register');
                  }
                },
                child: const Text("Register")),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child: const Text("Already have an account")),
          ],
        ));
  }
}
