import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/provider/note_provider.dart';


final noteServiceProvider = Provider((ref) => NoteProvider());

@immutable
class State {
  final bool isLoading;
  final NoteModel? note;
  final String? error;
  final String fullContent;

  const State({
    this.isLoading = false,
    this.note,
    this.error,
    this.fullContent = '',
  });

  State copyWith({
    bool? isLoading,
    NoteModel? note,
    String? error,
    String? fullContent,
  }) {
    return State(
      isLoading: isLoading ?? this.isLoading,
      note: note ?? this.note,
      error: error ?? this.error,
      fullContent: fullContent ?? this.fullContent,
    );
  }
}

class NoteNotifier extends StateNotifier<State> {
  NoteNotifier(this._provider) : super(const State());

  final NoteProvider _provider;
  Timer? _debounce;
  String _savedContent = '';

  Future<NoteModel> addNote (String createdBy, String title, String content) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.addNote(
        createdBy: createdBy,
        title: title,
        content: content
      );
      state = state.copyWith(isLoading: false, note: data);
      return data;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<NoteModel> noteById (String createdBy, String noteId) async{
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.getNoteById(
        createdBy: createdBy,
        noteId: noteId
      );
      state = state.copyWith(isLoading: false, note: data);
      return data;
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> currentNote(String noteId, String createdBy) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final note = await _provider.getNoteById(
        createdBy: createdBy,
        noteId: noteId
      );
      state = state.copyWith(note: note, isLoading: false);
      return;
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<NoteModel> update ({
    required String noteId,
    required String createdBy,
    required Map<String, dynamic> updatedData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.updateNote(
        noteId: noteId,
        createdBy: createdBy,
        updatedData: updatedData
      );

      state = state.copyWith(isLoading: false, note: data);
      return data;
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  void onContentChanged(String newContent, String noteId, String createdBy) {
    _savedContent = newContent;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _saveParagraph(noteId, createdBy, _savedContent);
    });
  }

  Future<void> _saveParagraph(String noteId,String content, String createdBy) async {
    try {
      await update(
          noteId: noteId,
          createdBy: createdBy,
          updatedData: {'content': content}
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

}

final noteNotifierProvider =
  StateNotifierProvider<NoteNotifier, State>(
      (ref) => NoteNotifier(ref.read(noteServiceProvider)),
);