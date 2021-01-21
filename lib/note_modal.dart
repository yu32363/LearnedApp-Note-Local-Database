import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_local_db_app/model/note.dart';

class NoteModal {
  final Function buttonPressed;
  final String id;
  String mode;

  NoteModal({this.buttonPressed, this.id, this.mode});

  final GlobalKey<FormState> _formkey = GlobalKey();

  String _title = '';
  String _subject = '';

  var _titleFocus = FocusNode();
  var _subjectFocus = FocusNode();

  void submitButton(BuildContext context) {
    if (!_formkey.currentState.validate()) {
      return;
    }
    Navigator.of(context).pop();
    _formkey.currentState.save();
    buttonPressed(
      id: id,
      title: _title,
      subject: _subject,
      mode: mode,
    );
  }

  InputDecoration inputStyle(String text) {
    return InputDecoration(
      border: InputBorder.none,
      labelText: text,
      hintStyle: TextStyle(
        color: Colors.black26,
      ),
      contentPadding: EdgeInsets.all(0),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black12),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black12),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black12),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black12),
      ),
    );
  }

  Future<dynamic> showModal({BuildContext ctx, Note data}) {
    return showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (ctx) {
          return SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom),
                color: Color(0xFF757575),
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mode == 'add' ? 'New Note' : 'Edit Note',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          OutlineButton.icon(
                            borderSide: BorderSide(
                                color: mode == 'add'
                                    ? Colors.green
                                    : Colors.orangeAccent),
                            highlightedBorderColor: mode == 'add'
                                ? Colors.green
                                : Colors.orangeAccent,
                            onPressed: () => submitButton(ctx),
                            icon: Icon(
                              mode == 'add' ? Icons.add : Icons.edit,
                              color: mode == 'add'
                                  ? Colors.green
                                  : Colors.orangeAccent,
                            ),
                            label: Text(
                              mode == 'add' ? 'Add' : 'Edit',
                              style: TextStyle(
                                  color: mode == 'add'
                                      ? Colors.green
                                      : Colors.orangeAccent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: data != null ? data.title : null,
                        key: ValueKey('Title'),
                        focusNode: _titleFocus,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        onFieldSubmitted: (_) {
                          FocusScope.of(ctx).requestFocus(_subjectFocus);
                        },
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Title must be at least 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _title = value;
                        },
                        decoration: inputStyle('Title'),
                      ),
                      TextFormField(
                        initialValue: data != null ? data.subject : null,
                        key: ValueKey('subject'),
                        focusNode: _subjectFocus,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        onEditingComplete: () => submitButton(ctx),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Subject must be at least 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _subject = value;
                        },
                        decoration: inputStyle('Subject'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
