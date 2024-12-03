import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/showmessage.dart';

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
    super.dispose(); // TODO: implement dispose
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Foget Password '),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            const Text(
                "Enter your Email and Press the submit button then the Email is sent to you ..."),
            const SizedBox(height: 10),
            TextField(
              controller: _forgetemail,
              decoration: const InputDecoration(
                hintText: 'Enter your Email',
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final forgetemail = _forgetemail.text;
                  try {
                    await AuthService.firebase()
                        .forgetpassword(email: forgetemail);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Loginviewroute, (route) => false);
                  } on InvalidEmailAuthException {
                    await showmessage(context, "Your email is Invalid");
                  } on GenericAuthException {
                    await showmessage(context, "Error: Email not send");
                  }
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
