import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/header.dart';
import 'package:to_do_list/component/widget/popup.dart';
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
  final TextEditingController _titleController = TextEditingController();
  QuillController _contentController = QuillController.basic();

  final isBoldProvider = StateProvider<bool>((ref) => false);
  final isEditProvider = StateProvider<bool>((ref) => false);
  final isItalicProvider = StateProvider<bool>((ref) => false);
  final circleButtonSelectedProvider = StateProvider<bool>((ref) => false);
  final isUnderlinedProvider = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateFormatStates);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(noteNotifierProvider.notifier)
          .noteById(widget.creatorId, widget.noteId);

      final note = ref.read(noteNotifierProvider).note;

      if (note != null) {
        try {
          final doc = Document.fromJson(jsonDecode(note.content));
          setState(() {
            _titleController.text = note.title;
            _contentController.document.replace(0, _contentController.document.length, doc.toDelta());
          });
        } catch (e) {
          final fallbackDoc = Document()..insert(0, note.content);
          setState(() {
            _titleController.text = note.title;
            _contentController.document.replace(0, _contentController.document.length, fallbackDoc.toDelta());
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _contentController.removeListener(_updateFormatStates);
    _titleController.dispose();
    super.dispose();
  }

  void _updateFormatStates() {
    final attrs = _contentController.getSelectionStyle().attributes;
    print("Style updated: $attrs");
    ref.read(isBoldProvider.notifier).state =
        attrs.keys.contains(Attribute.bold.key);
    ref.read(isItalicProvider.notifier).state =
        attrs.keys.contains(Attribute.italic.key);
    ref.read(isUnderlinedProvider.notifier).state =
        attrs.keys.contains(Attribute.underline.key);
  }

  Future<void> _updateNote( ) async {
    final state = ref.watch(noteNotifierProvider);
    final notifier = ref.read(noteNotifierProvider.notifier);
    final note = state.note!;
    print("Update");

    try{
      final delta = _contentController.document.toDelta();
      final contentAsJsonString = jsonEncode(delta.toJson());
      Map<String, dynamic> notePayload = {
        'id': note.id,
        'creatorId': note.creatorId,
        'title': _titleController.text.isEmpty ? note.title : _titleController.text,
        'content': contentAsJsonString,
        'tags': note.tags
      };

      print("Updatess");
      final dataUploaded = await notifier.update(
          noteId: note.id,
          creatorId: note.creatorId,
          updatedData: notePayload
      );
      print("Note updated $dataUploaded");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Dashboard()));
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteNotifierProvider);
    final notifier = ref.read(noteNotifierProvider.notifier);
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
    // QuillController? _contentController;
    try {
      final doc = Document.fromJson(jsonDecode(note.content));
      _contentController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      final fallbackDoc = Document()..insert(0, note.content);
      _contentController = QuillController(
        document: fallbackDoc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    if (_contentController == null) {
      try {
        final doc = Document.fromJson(jsonDecode(note.content));
        _contentController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        final fallbackDoc = Document()..insert(0, note.content);
        _contentController = QuillController(
          document: fallbackDoc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      _titleController.text = note.title;
      _contentController.addListener(_updateFormatStates);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(
              title: note.title,
              onBackPressed: _updateNote,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: QuillEditor.basic(
                  controller: _contentController,
                  config: QuillEditorConfig(
                      showCursor: false,
                      padding: EdgeInsets.all(8),
                      checkBoxReadOnly: false
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

  Widget _buildButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isEdit = ref.watch(isEditProvider);
    final isBold = ref.watch(isBoldProvider);
    final isItalic = ref.watch(isItalicProvider);
    final isUnderlined = ref.watch(isUnderlinedProvider);

    void _toggleFormatAttribute(Attribute attribute) {
      final isActive = _contentController
          .getSelectionStyle()
          .attributes
          .containsKey(attribute.key);

      if (isActive) {
        // Remove the formatting by using the attribute with null value
        _contentController.formatSelection(
            Attribute.clone(attribute, null));
      } else {
        // Apply the formatting
        _contentController.formatSelection(attribute);
      }

      // Update the state providers immediately after formatting
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateFormatStates();
      });
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
            splashFactory: NoSplash.splashFactory
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
          onTap: _updateNote,
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