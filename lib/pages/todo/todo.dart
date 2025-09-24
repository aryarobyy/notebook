import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/card/subtask_card.dart';
import 'package:to_do_list/component/widget/card/todo_card.dart';
import 'package:to_do_list/component/widget/layout/header.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/subtask_notifier.dart';
import 'package:to_do_list/notifiers/todo_notifier.dart';
import 'package:to_do_list/pages/todo/subtask.dart';

class Todo extends ConsumerStatefulWidget {
  final String creatorId;
  const Todo({
    required this.creatorId,
    super.key
  });

  @override
  ConsumerState createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoNotifierProvider.notifier).getTodosByCreator(
          creatorId: widget.creatorId
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoNotifierProvider);
    final subtaskState = ref.watch(subTaskNotifierProvider);

    if (todoState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (todoState.error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Todo"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Error: ${todoState.error}"),
              ElevatedButton(
                onPressed: () {
                  ref.read(todoNotifierProvider.notifier).getTodosByCreator(
                      creatorId: widget.creatorId
                  );
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final todos = todoState.todos ?? [];

    return Scaffold(
      body: Column(
        children: [
          todos.isEmpty
              ? const Center(
            child: Text("No todos available"),
          )
              : ListView.builder(
            itemCount: todos.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final TodoModel todo = todos[index];

              return FutureBuilder(
                future: _loadSubtasks(todo.id),
                builder: (context, snapshot) {
                  final subtasks = subtaskState.subTasks ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subtasks.length,
                    itemBuilder: (context, index) {
                      final subtask = subtasks[index];
                      return SubtaskCard(
                        creatorId: widget.creatorId,
                        todoId: todo.id,
                        subtaskId: subtask.id,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadSubtasks(String todoId) async {
    await ref.read(subTaskNotifierProvider.notifier).getSubTask(
      creatorId: widget.creatorId,
      todoId: todoId,
    );
  }
}