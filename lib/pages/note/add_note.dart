import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
  final QuillController _contentController = QuillController.basic();
  final List<String> _tags = [];

  final isEditProvider = StateProvider<bool>((ref) => false);
  final isCategoryProvider = StateProvider<bool>((ref) => false);
  final isBoldProvider = StateProvider<bool>((ref) => false);
  final isItalicProvider = StateProvider<bool>((ref) => false);
  final isUnderlinedProvider = StateProvider<bool>((ref) => false);
  final circleButtonSelectedProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateFormatStates);
  }

  @override
  void dispose() {
    _contentController.removeListener(_updateFormatStates);
    _titleController.dispose();
    super.dispose();
  }

  void _updateFormatStates() {
    final attrs = _contentController.getSelectionStyle().attributes;

    ref.read(isBoldProvider.notifier).state =
        attrs.keys.contains(Attribute.bold.key);
    ref.read(isItalicProvider.notifier).state =
        attrs.keys.contains(Attribute.italic.key);
    ref.read(isUnderlinedProvider.notifier).state =
        attrs.keys.contains(Attribute.underline.key);
  }

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
                _titleController.text.isNotEmpty
                  ? MyPopup.show(
                    context,
                    title: "Yakin gamau lanjut?",
                    agreeText: "Yakin",
                    disagreeText: "Batal",
                    onAgreePressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Dashboard()),
                      );
                    },
                  )
                  : Navigator.pushReplacement(
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
                        onChanged: (value) {},
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: QuillEditor.basic(
                          controller: _contentController,
                          config: QuillEditorConfig(
                            padding: EdgeInsets.all(12),
                            placeholder: 'Description Task',
                          ),
                        ),
                      ),
                      _buildCategoryouriteButton(context),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Center(
                child: _buildButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryouriteButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isActive = ref.watch(isCategoryProvider);

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final slideIn = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slideIn,
              child: child,
            ),
          );
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(cs.secondaryContainer),
                elevation: WidgetStateProperty.all(2),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              child: Text(
                "Category",
                style: TextStyle(color: cs.onSecondaryContainer),
              ),
              onPressed: () {
                final bool isNowEditing = ref
                    .read(isCategoryProvider.notifier)
                    .update((state) => !state);
                if (!isNowEditing) {
                  ref.read(isCategoryProvider.notifier).state = false;
                }
              },
            ),
            SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: isActive
                  ? Text(
                      "Well well well",
                      style: TextStyle(color: cs.onBackground),
                      key: const ValueKey<bool>(true),
                    )
                  : SizedBox.shrink(key: const ValueKey<bool>(false)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isEdit = ref.watch(isEditProvider);
    final isBold = ref.watch(isBoldProvider);
    final isItalic = ref.watch(isItalicProvider);
    final isUnderlined = ref.watch(isUnderlinedProvider);

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

      final delta = _contentController.document.toDelta();
      final contentAsJsonString = jsonEncode(delta.toJson());

      final notifier = ref.read(noteNotifierProvider.notifier);
      final note = await notifier.addNote(
        widget.userId,
        _titleController.text.trim(),
        contentAsJsonString,
      );

      MyPopup.show(context, title: "Catatan berhasil dibuat");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Note(creatorId: widget.userId, noteId: note.id),
        ),
      );
    }

    void _toggleFormatAttribute(Attribute attribute) {
      final isActive = _contentController
          .getSelectionStyle()
          .attributes
          .containsKey(attribute.key);

      if (isActive) {
        _contentController.formatSelection(
            Attribute(attribute.key, AttributeScope.inline, null));
      } else {
        _contentController.formatSelection(attribute);
      }
    }

    Widget buildFormatButton(
        IconData icon, bool isActive, VoidCallback onPressed) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isActive ? cs.primary : cs.onSurface.withOpacity(0.6),
        ),
        style: IconButton.styleFrom(
          backgroundColor:
              isActive ? cs.primary.withOpacity(0.1) : Colors.transparent,
        ),
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
            ? Container(
                key: const ValueKey('format-toolbar'),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: cs.onSurface.withOpacity(0.06),
                ),
                child: Row(
                  key: const ValueKey('button-row'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildFormatButton(
                      Icons.format_bold,
                      isBold,
                      () => _toggleFormatAttribute(
                        Attribute.bold,
                      ),
                    ),
                    buildFormatButton(
                      Icons.format_italic,
                      isItalic,
                      () => _toggleFormatAttribute(
                        Attribute.italic,
                      ),
                    ),
                    buildFormatButton(
                      Icons.format_underline,
                      isUnderlined,
                      () => _toggleFormatAttribute(
                        Attribute.underline,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                key: ValueKey('empty-box'),
              ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: cs.onSurface),
          iconSize: 30,
          onPressed: () {
            final bool isNowEditing =
                ref.read(isEditProvider.notifier).update((state) => !state);

            if (!isNowEditing) {
              ref.read(isBoldProvider.notifier).state = false;
              ref.read(isItalicProvider.notifier).state = false;
              ref.read(isUnderlinedProvider.notifier).state = false;
            }
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
