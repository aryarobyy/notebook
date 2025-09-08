import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/service/todo_service.dart';

final todoServiceProvider = Provider((ref) => TodoService());

@immutable
class State {
  final bool isLoading;
  final TodoModel? todo;
  final List<TodoModel>? todos;
  final String? error;
  final String fullContent;

  const State({
    this.isLoading = false,
    this.todo,
    this.todos,
    this.error,
    this.fullContent = '',
  });

  State copyWith({
    bool? isLoading,
    TodoModel? todo,
    List<TodoModel>? todos,
    String? error,
    String? fullContent,
  }) {
    return State(
      isLoading: isLoading ?? this.isLoading,
      todo: todo ?? this.todo,
      todos: todos ?? this.todos,
      error: error ?? this.error,
      fullContent: fullContent ?? this.fullContent,
    );
  }
}

class TodoNotifier extends StateNotifier<State> {
  TodoNotifier(this._service) : super(const State());

  final TodoService _service;

  Future<void> createTodo({
    required String creatorId,
    required String title,
    String? subitle,
    List<String>? tag,
    List<String>? noteId,
    List<String>? subTasks,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _service.createTodo(
        creatorId: creatorId,
        title: title,
        tag: tag,
        noteId: noteId,
      );
      state = state.copyWith(isLoading: false, todo: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

 Future<void> getTodoById({
   required String creatorId,
   required String todoId,
 }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _service.getTodoById(creatorId: creatorId, todoId: todoId);
      state = state.copyWith(isLoading: false, todo: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> getTodosByCreator({
    required String creatorId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _service.getTodosByCreator(creatorId);
      state = state.copyWith(isLoading: false, todos: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> updateTodo({
    required String creatorId,
    required String todoId,
    required Map<String, dynamic> updatedData
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _service
        .updateTodo(
          todoId: todoId,
          creatorId: creatorId,
          updatedData: updatedData
      );
      state = state.copyWith(isLoading: false, todo: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, State>(
      (ref) => TodoNotifier(ref.read(todoServiceProvider)),
);