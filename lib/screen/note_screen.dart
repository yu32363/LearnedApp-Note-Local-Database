import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_local_db_app/model/note.dart';
import 'package:note_local_db_app/model/note_controller.dart';
import 'package:intl/intl.dart';
import 'package:note_local_db_app/note_modal.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  Color color;

  Color circleColor(index) {
    if (index % 4 == 0) {
      color = Colors.red;
    } else if (index % 4 == 1) {
      color = Colors.blue;
    } else if (index % 4 == 2) {
      color = Colors.green;
    } else if (index % 4 == 3) {
      color = Colors.yellow;
    }
    return color;
  }

  void _submit({String id, String title, String subject, String mode}) {
    setState(() {
      if (mode == 'add') {
        NoteController().addNote(title, subject);
      } else {
        NoteController().updateNote(id, title, subject);
      }
    });
  }

  final SlidableController slideController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                NoteModal(buttonPressed: _submit, mode: 'add')
                    .showModal(ctx: context);
              })
        ],
      ),
      body: FutureBuilder(
          future: NoteController().fetchAndSetNote(),
          builder: (context, result) {
            if (result.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Note> note = result.data;

            return ListView.builder(
              itemCount: note.length,
              itemBuilder: (context, i) {
                return Slidable(
                  controller: slideController,
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.2,
                  secondaryActions: [
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.black45,
                      icon: Icons.edit,
                      onTap: () {
                        NoteModal(
                                buttonPressed: _submit,
                                mode: 'edit',
                                id: note[i].id)
                            .showModal(ctx: context, data: note[i]);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        setState(() {
                          NoteController().deleteNote(note[i].id);
                        });
                      },
                    )
                  ],
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        leading: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor: circleColor(i),
                          radius: 25,
                          child: Text(note[i].title[0].toUpperCase()),
                        ),
                        title: Text(
                          note[i].title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note[i].subject),
                            Text(DateFormat.yMMMd('en_US')
                                .format(note[i].created)),
                          ],
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.star,
                              color: note[i].favorite == true
                                  ? Colors.amber
                                  : Colors.grey[400],
                            ),
                            onPressed: () {
                              note[i].favorite = !note[i].favorite;
                              setState(() {
                                NoteController()
                                    .updateStar(note[i].id, note[i].favorite);
                              });
                            }),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
