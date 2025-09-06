import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/button/nav_button.dart';
import 'package:to_do_list/component/widget/field/note_text_field.dart';
import 'package:to_do_list/component/size/size_config.dart';
import 'package:to_do_list/component/widget/layout/header.dart';
import 'package:to_do_list/component/widget/layout/popup.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';
import 'package:to_do_list/pages/note/note.dart';

final isEditProvider = StateProvider<bool>((ref) => false);
final isCategoryProvider = StateProvider<bool>((ref) => false);
final isBoldProvider = StateProvider<bool>((ref) => false);
final isItalicProvider = StateProvider<bool>((ref) => false);
final isUnderlinedProvider = StateProvider<bool>((ref) => false);
final circleButtonSelectedProvider = StateProvider<bool>((ref) => false);
final categoryProvider = StateProvider<String>((ref) => '');

class AddNote extends ConsumerStatefulWidget {
  final String userId;
  const AddNote({super.key, required this.userId});

  @override
  ConsumerState<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends ConsumerState<AddNote> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _contentController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_updateFormatStates);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(mounted && widget.userId.isNotEmpty){
        ref
          .read(categoryNotifierProvider.notifier)
          .categoryByCreator(widget.userId);
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
                      _buildCategoryButton(context),
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

  Widget _buildCategoryButton(BuildContext context) {
    final state = ref.watch(categoryNotifierProvider);
    final cs = Theme.of(context).colorScheme;
    final isActive = ref.watch(isCategoryProvider);
    final category = state.categories;
    final selectedCategory = ref.watch(categoryProvider);

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
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.secondary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 4,
              ),
              onPressed: () {
                ref.read(isCategoryProvider.notifier).update((state) => !state);
              },
              child: const Text("Category"),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: isActive
                  ? Wrap(
                spacing: 8,
                runSpacing: 8,
                children: category!.map((e) {
                  final bool isSelected = e.title == selectedCategory;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? cs.primary
                          : cs.secondaryContainer,
                      foregroundColor: isSelected
                          ? cs.onPrimary
                          : cs.onSecondaryContainer,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: isSelected ? 4 : 2,
                    ),
                    onPressed: () {
                      if (selectedCategory == e.title) {
                        ref.read(categoryProvider.notifier).state = '';
                      } else {
                        ref.read(categoryProvider.notifier).state = e.title;
                      }
                    },
                    child: Text(e.title),
                  );
                }).toList(),
              ) : const SizedBox.shrink(key: ValueKey(false)),
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
    final selectedCategory = ref.watch(categoryProvider);

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

      final noteNotifier = ref.read(noteNotifierProvider.notifier);
      final catNotifier = ref.read(categoryNotifierProvider.notifier);

      final note = await noteNotifier.addNote(
        widget.userId,
        _titleController.text.trim(),
        contentAsJsonString,
      );

      if(selectedCategory.isNotEmpty){
        final data = await catNotifier.update(creatorId: widget.userId, title: selectedCategory, removeNoteId: [], addNoteId: [note.id]);
        print("data $data");
      }

      _titleController.clear();
      _contentController.clear();
      selectedCategory == '';

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
