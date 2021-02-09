import 'package:flutter/material.dart';
import 'package:note_app_localdb/helper/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:note_app_localdb/screen/note_edit_screen.dart';
import 'package:note_app_localdb/screen/note_list_screen.dart';
import 'package:note_app_localdb/screen/note_view_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Notes',
        initialRoute: '/',
        routes: {
          '/': (context) => NoteListScreen(),
          NoteViewScreen.routeName: (context) => NoteViewScreen(),
          NoteEditScreen.routeName: (context) => NoteEditScreen(),
        },
      ),
    );
  }
}
