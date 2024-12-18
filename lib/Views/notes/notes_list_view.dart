import 'package:flutter/material.dart';
import 'package:notesapp/services/crud/note_service.dart';
import 'package:notesapp/utilities/show_delete_dialog.dart';

typedef DeleteNoteCallBack = void Function(Databasenotes note);

class NotesListView extends StatelessWidget {
  final List<Databasenotes> notes;
  final DeleteNoteCallBack onDeleteNote;

  const NotesListView(
      {super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              onPressed: () async {
                final shoulddelete = await showdeletedialog(context);
                if (shoulddelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}
