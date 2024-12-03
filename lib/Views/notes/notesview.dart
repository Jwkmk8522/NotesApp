import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/crud/note_service.dart';

import 'dart:developer' as dev show log;
import '../../Enums/menuaction.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final Databaseservice _noteservice;
  String get useremail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteservice = Databaseservice();
    super.initState();
  }

  @override
  void dispose() {
    _noteservice.closedb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text("Your Notes"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Newnoteviewroute);
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<Menuactions>(
              onSelected: (value) async {
                final shouldlogout = await showalertdialog(context);
                if (shouldlogout) {
                  AuthService.firebase().logOut();
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
        body: FutureBuilder(
          future: _noteservice.getorcreateuser(email: useremail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _noteservice.allnotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('Notes of this user');
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
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
