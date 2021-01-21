import 'package:flutter/material.dart';
import 'package:note_local_db_app/screen/note_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NoteScreen(),
    );
  }
}
