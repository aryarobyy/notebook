import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/header.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';

class Note extends ConsumerStatefulWidget {
  final String creatorId;
  final String noteId;
  const Note({
    required this.creatorId,
    required this.noteId,
    super.key,
  });

  @override
  ConsumerState<Note> createState() => _NoteState();
}

class _NoteState extends ConsumerState<Note> {
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
        .read(noteNotifierProvider.notifier)
        .noteById(widget.creatorId, widget.noteId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteNotifierProvider);
    final note = state.note;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (note == null) {
      return const Scaffold(
        body: Center(
          child: Text("Catatan tidak ditemukan atau gagal dimuat."),
        ),
      );
    }

    try {
      if (_controller.document.isEmpty()) {
        final List<dynamic> jsonData = jsonDecode(note.content);
        final delta = Delta.fromJson(jsonData);
        _controller.document = Document.fromDelta(delta);
      }
    } catch (e) {
      if (_controller.document.isEmpty()) {
        _controller.document = Document()..insert(0, note.content);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(
              title: note.title,
              onBackPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Dashboard()));
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: QuillEditorConfig(
                    showCursor: false,
                    padding: EdgeInsets.all(8),
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