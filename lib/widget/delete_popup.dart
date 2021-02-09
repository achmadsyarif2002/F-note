import 'package:flutter/material.dart';
import 'package:note_app_localdb/models/note.dart';
import 'package:provider/provider.dart';
import '../helper/note_provider.dart';

class DeletePopUp extends StatelessWidget {
  final Note selectedNote;

  const DeletePopUp({Key key, this.selectedNote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete note?'),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<NoteProvider>(context, listen: false)
                .deleteNote(selectedNote.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
