import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exception.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/showmessage.dart';
import 'dart:developer' show log;

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  late final TextEditingController _forgetemail;
  @override
  void initState() {
    _forgetemail = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _forgetemail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: Column(
          children: [
            const Text(
              'Enter your Email and press submit then An Email is send to you where you change your password...',
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _forgetemail,
              decoration: const InputDecoration(
                hintText: 'Please Enter Your Email',
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final forgetemail = _forgetemail.text;
                try {
                  await AuthService.firebase()
                      .forgetpassword(email: forgetemail);
                  log('Password reset email sent.');

                  // Show a confirmation message or alert before navigating

                  const Text('A password reset email has been sent');

                  // Navigate to the login page after showing the confirmation
                  Navigator.of(context).pushNamed(Loginviewroute);
                  log('Navigated to login view.');
                } on InvalidEmailAuthException {
                  await showmessage(context, 'Your email is invalid');
                } on UserNotFoundAuthException {
                  await showmessage(context,
                      'not find your email in firebase first register');
                } on GenericAuthException {
                  await showmessage(context, 'Error while sending email');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
