import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app_localdb/helper/note_provider.dart';
import 'package:note_app_localdb/models/note.dart';
import 'package:note_app_localdb/screen/note_edit_screen.dart';
import 'package:note_app_localdb/utils/constant.dart';
import 'package:note_app_localdb/widget/delete_popup.dart';
import 'package:provider/provider.dart';

class NoteViewScreen extends StatefulWidget {
  static const routeName = '/note_view';
  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  Note selectedNote;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context).settings.arguments;
    final provider = Provider.of<NoteProvider>(context);

    if (provider.getNote(id) != null) {
      selectedNote = provider.getNote(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          color: black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            color: black,
            onPressed: () {
              _showDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedNote?.title,
                style: viewTitleStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Icon(
                    Icons.access_time,
                    size: 18.0,
                  ),
                ),
                Text('${selectedNote?.date}'),
              ],
            ),
            if (selectedNote.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.file(
                    File(
                      selectedNote.imagePath,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Text(
                selectedNote.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            NoteEditScreen.routeName,
            arguments: selectedNote.id,
          );
        },
        child: Icon(
          Icons.edit,
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DeletePopUp(
            selectedNote: selectedNote,
          );
        });
  }
}
