import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/component/core/constant.dart';
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';
import 'package:uuid/uuid.dart';

final userCol = USER_COLLECTION;
final todoCol = TODO_COLLECTION;
final subtaskCol = SUBTASK_COLLECTION;

class SubtaskService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<SubTaskModel> createSubtask({
    required String creatorId,
    required String todoId,
    required String content,
    bool isDone = false,
  }) async {
    try{
      final id = const Uuid().v4();

      final subtask = SubTaskModel(
        id: id,
        text: content,
        todoId: [todoId],
        createdAt: DateTime.now(),
        isDone: isDone,
      );
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .collection(subtaskCol)
          .doc(id)
          .set(subtask.toJson());

      return subtask;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> UpdateSubtask({
    required String creatorId,
    required String todoId,
    required String subtaskId,
    String? content,
    bool? isDone,
  }) async {
    try{
      final creatorSnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .get();

      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final Map<String, dynamic> data = {};
      if (content != null) data['content'] = content;
      if (isDone != null) data['isDone'] = isDone;

      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .collection(subtaskCol)
          .doc(subtaskId)
          .update(data);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<SubTaskModel> getSubtaskById({
    required String creatorId,
    required String todoId,
    required String subtaskId,
  }) async {
    try{
      final docSnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .collection(subtaskCol)
          .doc(subtaskId)
          .get();
      if (!docSnap.exists || docSnap.data() == null) {
        throw Exception("Subtask not found");
      }
      return SubTaskModel.fromJson(docSnap.data()!);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<SubTaskModel>> getSubtask ({
    required String creatorId,
    required String todoId,
  }) async {
    try {
      final querySnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .collection(subtaskCol)
          .get();
      return querySnap.docs
          .map((doc) => SubTaskModel.fromJson(doc.data()))
          .toList();
    }  catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteSubtask({
    required String creatorId,
    required String todoId,
    required String subtaskId,
  }) async {
    try {
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(todoCol)
          .doc(todoId)
          .collection(subtaskCol)
          .doc(subtaskId)
          .delete();
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }
}