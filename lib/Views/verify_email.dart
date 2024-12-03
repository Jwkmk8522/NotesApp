import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_service.dart';

import '../constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text("we have send you email you can verify your account"),
          const Text("if you dont get email press button "),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text("Verify Email")),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Loginviewroute, (route) => false);
              },
              child: Text("Restart")),
        ],
      ),
    );
  }
}
