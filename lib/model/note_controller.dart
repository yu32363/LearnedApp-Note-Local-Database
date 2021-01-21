import 'package:note_local_db_app/model/note.dart';
import 'package:note_local_db_app/helper/db_helper.dart';

class NoteController {
  List<Note> _notes = [];

  void addNote(String title, String subject) {
    final newNote = Note(
      id: DateTime.now().toString(),
      title: title,
      subject: subject,
      created: DateTime.now(),
      favorite: false,
    );
    DBHelper.insert('notes', {
      'id': newNote.id,
      'title': newNote.title,
      'subject': newNote.subject,
      'created': newNote.created.toIso8601String(),
      'favorite': newNote.favorite == false ? 0 : 1
    });
  }

  Future<List<Note>> fetchAndSetNote() async {
    final data = await DBHelper.getData('notes');
    _notes = data.map((item) {
      return Note(
          id: item['id'],
          title: item['title'],
          subject: item['subject'],
          created: DateTime.parse(item['created']),
          favorite: item['favorite'] == 0 ? false : true);
    }).toList();
    return _notes;
  }

  void updateNote(String id, String title, String subject) {
    final update = Note(
      id: id,
      title: title,
      subject: subject,
    );

    DBHelper.updateData('notes', {
      'id': update.id,
      'title': update.title,
      'subject': update.subject,
    });
  }

  void updateStar(String id, bool favorite) {
    final star = Note(id: id, favorite: favorite);

    DBHelper.updateData('notes', {
      'id': star.id,
      'favorite': star.favorite == false ? 0 : 1,
    });
  }

  void deleteNote(String id) {
    DBHelper.deleteData('notes', {'id': id});
  }
}
