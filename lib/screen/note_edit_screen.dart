import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_localdb/models/note.dart';
import 'package:note_app_localdb/utils/constant.dart';
import 'package:note_app_localdb/widget/delete_popup.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../helper/note_provider.dart';
import '../screen/note_view_screen.dart';

class NoteEditScreen extends StatefulWidget {
  static const routeName = '/edit_note';
  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  bool firstTime = true;
  Note selectedNote;
  int id;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      id = ModalRoute.of(this.context).settings.arguments;
      if (id != null) {
        selectedNote = Provider.of<NoteProvider>(this.context).getNote(id);
      }
      titleController.text = selectedNote?.title;
      contentController.text = selectedNote?.content;
      if (selectedNote?.imagePath != null) {
        _image = File(selectedNote.imagePath);
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.7,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Colors.black,
            ),
            onPressed: () {
              getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.insert_photo,
              color: Colors.black,
            ),
            onPressed: () {
              getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
            ),
            color: Colors.black,
            onPressed: () {
              if (id != null) {
                _showDialog();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextField(
                controller: titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                  hintText: 'Enter Note Title',
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_image != null)
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 5.0,
                top: 10.0,
                bottom: 5.0,
              ),
              child: TextField(
                controller: contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: 'Enter Something Wordsays....',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (titleController.text.isEmpty) {
            titleController.text = 'Untitled Note';
          }
          saveNote();
        },
        child: Icon(
          Icons.save,
        ),
      ),
    );
  }

  void getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);
    if (imageFile == null) return;
    File tempFile = File(imageFile.path);
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    tempFile = await tempFile.copy('${appDir.path}/$fileName');
    setState(() {
      _image = tempFile;
    });
  }

  void saveNote() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();
    String imagePath = _image != null ? _image.path : null;
    if (id != null) {
      Provider.of<NoteProvider>(this.context).addOrUpdateNote(
        id,
        title,
        content,
        imagePath,
        EditMode.UPDATE,
      );
      Navigator.of(this.context).pop();
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;
      Provider.of<NoteProvider>(this.context, listen: false)
          .addOrUpdateNote(id, title, content, imagePath, EditMode.ADD);

      Navigator.of(this.context)
          .pushReplacementNamed(NoteViewScreen.routeName, arguments: id);
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(
            selectedNote: selectedNote,
          );
        });
  }
}
