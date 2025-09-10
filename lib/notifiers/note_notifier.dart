import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/service/note_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final noteServiceProvider = Provider((ref) => NoteService());

@immutable
class State {
  final bool isLoading;
  final NoteModel? note;
  final List<NoteModel>? notes;
  final String? error;
  final String fullContent;

  const State({
    this.isLoading = false,
    this.note,
    this.notes,
    this.error,
    this.fullContent = '',
  });

  State copyWith({
    bool? isLoading,
    NoteModel? note,
    List<NoteModel>? notes,
    String? error,
    String? fullContent,
  }) {
    return State(
      isLoading: isLoading ?? this.isLoading,
      note: note ?? this.note,
      notes: notes ?? this.notes,
      error: error ?? this.error,
      fullContent: fullContent ?? this.fullContent,
    );
  }
}

class NoteNotifier extends StateNotifier<State> {
  NoteNotifier(this._service) : super(const State());

  final NoteService _service;
  Timer? _debounce;
  String _savedContent = '';

  Future<void> addNote(
      String creatorId, String title, String content) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.createNote(
          creatorId: creatorId, title: title, content: content);
      state = state.copyWith(isLoading: false, note: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> noteById(String creatorId, String noteId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data =
          await _service.getNoteById(creatorId: creatorId, noteId: noteId);
      state = state.copyWith(isLoading: false, note: data);
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> currentNote(String noteId, String creatorId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final note =
          await _service.getNoteById(creatorId: creatorId, noteId: noteId);
      state = state.copyWith(note: note, isLoading: false);
      return;
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> noteByCreator(String creatorId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final notes = await _service.getNotesByCreator(creatorId);
      state = state.copyWith(notes: notes, isLoading: false);
    } catch (e) {
      state =
          state.copyWith(notes: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> update({
    required String noteId,
    required String creatorId,
    required Map<String, dynamic> updatedData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _service.updateNote(
          noteId: noteId, creatorId: creatorId, updatedData: updatedData);

      state = state.copyWith(isLoading: false, note: data);
    } catch (e) {
      state = state.copyWith(note: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  void onContentChanged(String newContent, String noteId, String creatorId) {
    _savedContent = newContent;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      _saveParagraph(noteId, creatorId, _savedContent);
    });
  }

  Future<void> _saveParagraph(
      String noteId, String content, String creatorId) async {
    try {
      await update(
          noteId: noteId,
          creatorId: creatorId,
          updatedData: {'content': content});
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

final noteNotifierProvider = StateNotifierProvider<NoteNotifier, State>(
  (ref) => NoteNotifier(ref.read(noteServiceProvider)),
);