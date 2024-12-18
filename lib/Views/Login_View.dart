import 'package:flutter/material.dart';

import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/error_dialog.dart';
// import 'package:sign_in_button/sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  //bool _ispasswordvisible = false;   //abc
  bool _ispasswordvisible = true; //....

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
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _password,
              obscureText: _ispasswordvisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "Enter Your Password",
                enabledBorder: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ispasswordvisible = !_ispasswordvisible;
                    });
                  },
                  icon: Icon(_ispasswordvisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Forgetpasswordroute);
                    },
                    child: const Text(
                      'Foget Password ?',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await AuthService().logIn(email: email, password: password);
                    final user = AuthService().currentUser;
                    if (user?.emailVerified ?? false) {
                      //user is verified
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/notes/', (route) => false);
                    } else {
                      //user is not verified
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Verifyemailroute, (route) => false);
                    }
                  } on UserNotFoundAuthException {
                    await showerrordialog(
                        context, 'User is not Register first register');
                  } on WrongPasswordAuthException {
                    await showerrordialog(
                        context, 'Enter valid Password for This email');
                  } on InvalidEmailAuthException {
                    await showerrordialog(context, "Invalid email");
                  } on GenericAuthException {
                    await showerrordialog(context, "Error :User not login in ");
                  }
                },
                child: const Text("Login ")),
            // SignInButton(
            //   Buttons.google,
            //   text: 'Sign in with Google',
            //   onPressed: () async {
            //     try {
            //       final user = await AuthService().signinwithgoogle();
            //       if (user != null) {
            //         await Navigator.of(context).pushNamed(Notesviewroute);
            //       }
            //     } catch (e) {
            //       await showerrordialog(context, 'Error: $e');
            //     }
            //   },
            // ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/regester/', (route) => false);
                },
                child: const Text("Create an account"))
          ],
        ),
      ),
    );
  }
}
