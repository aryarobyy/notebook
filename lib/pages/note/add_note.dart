import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/note_text_field.dart';
import 'package:to_do_list/component/size/size_config.dart';
import 'package:to_do_list/component/widget/header.dart';
import 'package:to_do_list/component/widget/popup.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/pages/note/note.dart';

class AddNote extends ConsumerStatefulWidget {
  final String userId;
  const AddNote({super.key, required this.userId});

  @override
  ConsumerState<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends ConsumerState<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _tags = [];

  final isEditProvider = StateProvider<bool>((ref) {
    return false;
  });
  final isBoldProvider = StateProvider<bool>((ref) {
    return false;
  });
  final isItalicProvider = StateProvider<bool>((ref) {
    return false;
  });
  final isUnderlinedProvider = StateProvider<bool>((ref) {
    return false;
  });
  final circleButtonSelectedProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyHeader(
              title: "Add Note",
              onBackPressed: () {
                _titleController.text.isNotEmpty || _contentController.text.isNotEmpty ?
                  MyPopup.show(
                    context, title: "Yakin gamau lanjut?",
                    agreeText: "Yakin",
                    disagreeText: "Batal",
                    onAgreePressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Dashboard()),
                      );
                    },
                  ):
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Dashboard()),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NoteTextField(
                        controller: _titleController,
                        inputText: "Task name",
                        isTitle: true,
                        onChanged: (value){

                        },
                      ),
                      NoteTextField(
                        controller: _contentController,
                        inputText: "Description Task",
                        onChanged: (value) {
                          // ref.read(noteNotifierProvider.notifier)
                          //   .onContentChanged(value, noteId, creatorId)
                        },
                        maxLine: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Center(
                child: _buildButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context){
    final cs = Theme.of(context).colorScheme;
    final notifier = ref.read(noteNotifierProvider.notifier);
    final bool isEdit = ref.watch(isEditProvider);
    final size = SizeConfig;

    void _postNote() async {
      if (_titleController.text.isEmpty) {
        MyPopup.show(
          context,
          title: "Judul gak boleh kosong",
          agreeText: "OK",
          onAgreePressed: () {},
        );
        return;
      }

      final note = await notifier.addNote(
        widget.userId,
        _titleController.text.trim(),
        _contentController.text.trim(),
      );
      MyPopup.show(context, title: "Catatan berhasil dibuat");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Note(creatorId: widget.userId, noteId: note.id)
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            );

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: isEdit
              ?
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: cs.onSurface.withOpacity(0.06),
            ),
            child: Row(
              key: const ValueKey('button-row'),
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(Icons.format_bold)
                ),
                const SizedBox(width: 24),
                IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.format_italic)
                ),
                const SizedBox(width: 24),
                IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.format_underline)
                ),
              ],
            ),
          )
              :
          const SizedBox(
            key: ValueKey('empty-box'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: cs.onSurface),
          iconSize: 30,
          onPressed: () {
            ref.read(isEditProvider.notifier).update((state) => !state);
          },
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: _postNote,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary,
            ),
            child: Icon(
              Icons.check,
              size: 30,
              color: cs.surface,
            ),
          ),
        ),
      ],
    );
  }
}
