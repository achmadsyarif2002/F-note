import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_app_localdb/helper/note_provider.dart';
import 'package:note_app_localdb/screen/note_edit_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../widget/list_item.dart';
import 'package:note_app_localdb/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(context, listen: false).getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Consumer<NoteProvider>(
                child: notesUI(context),
                builder: (context, noteprovider, child) {
                  return noteprovider.items.length <= 0
                      ? child
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return header();
                            } else {
                              final i = index - 1;
                              final item = noteprovider.items[i];

                              return ListItem(
                                id: item.id,
                                title: item.title,
                                content: item.content,
                                date: item.date,
                                imagePath: item.imagePath,
                              );
                            }
                          },
                          itemCount: noteprovider.items.length + 1,
                        );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  goNoteEditScreen(context);
                },
                child: Icon(
                  Icons.add,
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}

Widget header() {
  return GestureDetector(
    onTap: _launchUrl,
    child: Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(75.0),
        ),
      ),
      height: 150,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'VESCOD',
            style: headerRideStyle,
          ),
          Text(
            'Notes',
            style: headerNotesStyle,
          ),
        ],
      ),
    ),
  );
}

void _launchUrl() async {
  const url = 'github.com/achmadsyarif2002';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'could not launch $url';
  }
}

Widget notesUI(BuildContext context) {
  return ListView(
    children: [
      header(),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset(
              'assets/crying_emoji.png',
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
          ),
          RichText(
            text: TextSpan(
              style: noNotesStyle,
              children: [
                TextSpan(text: 'There is no note available\n Tap on'),
                TextSpan(
                    text: ' "+" ',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goNoteEditScreen(context);
                      }),
                TextSpan(
                  text: 'To add new note',
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

void goNoteEditScreen(BuildContext context) {
  Navigator.of(context).pushNamed(NoteEditScreen.routeName);
}
