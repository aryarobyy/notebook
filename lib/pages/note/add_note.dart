import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/button1.dart';
import 'package:to_do_list/component/button2.dart';
import 'package:to_do_list/component/note_text_field.dart';
import 'package:to_do_list/component/text_field.dart';
import 'package:to_do_list/component/widget/header.dart';
import 'package:to_do_list/component/widget/popup.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/pages/note/note.dart';

class AddNote extends ConsumerStatefulWidget {
  final String userId;
  const AddNote({
    super.key,
    required this.userId
  });

  @override
  ConsumerState<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends ConsumerState<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _tags = [];

@override
  Widget build(BuildContext context) {
  final state    = ref.watch(noteNotifierProvider);
  final notifier = ref.read(noteNotifierProvider.notifier);

  void _postNote() async {
    if (_titleController.text.isEmpty) {
      MyPopup.show(
        context,
        title: "Judul gak boleh kosong",
        agreeText: "OK",
        onAgreePressed: () {
        },
      );
      return;
    }

    final note = await notifier.addNote(
      widget.userId,
      _titleController.text.trim(),
      _contentController.text.trim(),
    );
    MyPopup.show(context, title: "Catatan berhasil dibuat");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Note(
      createdBy: widget.userId,
      noteId: note.id
    )));
  }

  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          MyHeader(
            title: "Add Note",
            onBackPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Dashboard()),
              );
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyTextField(
                      controller: _titleController,
                      name: "Title",
                      inputType: TextInputType.text,
                    ),
                    // NoteTextField(
                    //   controller: _contentController,
                    //   onChanged: (value) {
                    //     // ref.read(noteNotifierProvider.notifier)
                    //     //   .onContentChanged(value, noteId, createdBy)
                    //   },
                    // ),
                    const SizedBox(height: 24),

                    MyButton1(
                      text: "Submit",
                      onPressed: _postNote,
                      icon: Icons.touch_app,
                      buttonId: 'submit_note',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
