import 'package:flutter/foundation.dart';

class Note {
  final String id;
  final String title;
  final String subject;
  final DateTime created;
  bool favorite;

  Note(
      {@required this.id,
      @required this.title,
      @required this.subject,
      @required this.created,
      @required this.favorite});
}
