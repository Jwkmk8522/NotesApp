import 'package:flutter/material.dart';
import 'package:notesapp/Views/notes/notes_list_view.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/crud/note_service.dart';
import 'package:notesapp/utilities/logout_dialog.dart';

import 'dart:developer' show log;
import '../../Enums/menuaction.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final Databaseservice _noteservice;
  String get useremail => AuthService().currentUser!.email!;

  @override
  void initState() {
    _noteservice = Databaseservice();
    super.initState();
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
                final shouldlogout = await showlogoutdialog(context);
                if (shouldlogout) {
                  AuthService().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (routes) => false);
                }
                log(shouldlogout.toString());
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
          future: _noteservice.getOrCreateUser(email: useremail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _noteservice.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allnotes = snapshot.data as List<Databasenotes>;

                          return NotesListView(
                            notes: allnotes,
                            onDeleteNote: (note) async {
                              await _noteservice.deleteNote(id: note.id);
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
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
