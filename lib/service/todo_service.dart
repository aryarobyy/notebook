import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/component/core/constant.dart';
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';
import 'package:uuid/uuid.dart';

final userCol = USER_COLLECTION;
final todoCol = TODO_COLLECTION;

class TodoService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<TodoModel> createTodo({
    required String creatorId,
    required String title,
    String? subTitle,
    List<String>? tag,
    List<String>? subTasks,
    List<String>? noteId,
  }) async {
    try{
      final id = const Uuid().v4();

      final creatorSnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .get();

      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final todo = TodoModel(
        id: id,
        title: title,
        subTitle: subTitle ?? "",
        tag: tag ?? [],
        subTasks: subTasks ?? [],
        noteId: noteId ?? [],
        createdAt: DateTime.now(),
      );

      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(id)
          .set(todo.toJson());

      return todo;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<TodoModel> updateTodo({
    required String creatorId,
    required String todoId,
    required Map<String, dynamic> updatedData
  }) async {
    try {
      final creatorSnap =
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .get();
      if (!creatorSnap.exists) throw Exception("Unknown creator: $creatorId");
      if(updatedData.isEmpty) throw Exception("No data to update");

      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .update(updatedData);
      return TodoModel.fromJson(updatedData);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<TodoModel> getTodoById({
    required String creatorId,
    required String todoId,
  }) async {
    try{
      final docSnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .get();
      if (!docSnap.exists || docSnap.data() == null) {
        throw Exception("Todo not found");
      }
      return TodoModel.fromJson(docSnap.data()!);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<TodoModel>> getTodosByCreator(String creatorId) async {
    try{
      final querySnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .get();
      return querySnap.docs
          .map((doc) => TodoModel.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }
}