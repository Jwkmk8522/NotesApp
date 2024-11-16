import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'dart:developer' as dev show log;
import '../Enums/menuaction.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<Menuactions>(
            onSelected: (value) async {
              final shouldlogout = await showalertdialog(context);
              if (shouldlogout) {
                AuthService.firebase().logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (routes) => false);
              }
              dev.log(shouldlogout.toString());
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<Menuactions>(
                    value: Menuactions.logout, child: Text('logout')),
              ];
            },
          )
        ],
      ),
      body: const Text("This is main screen"),
    );
  }
}

Future<bool> showalertdialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout ..."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Logout")),
        ],
      );
    },
  ).then((value) => value ?? false);
}
