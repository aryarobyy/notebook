import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/component/core/constant.dart';
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';
import 'package:uuid/uuid.dart';

final userCol = USER_COLLECTION;
final notesCol = NOTE_COLLECTION;

class NoteService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<NoteModel> createNote({
    required String creatorId,
    required String title,
    required String content,
    List<String> tags = const [],
    List<SubTaskModel> subTasks = const [],
    DateTime? schedule,
    NoteStatus status = NoteStatus.ACTIVE,
  }) async {
    try {
      final id = const Uuid().v4();

      final creatorSnap =
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .get();
      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final formattedTags = tags.map((t) => t.toUpperCase()).toList();

      final note = NoteModel(
        id: id,
        creatorId: creatorId,
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        schedule: schedule,
        tag: formattedTags,
        status: status,
      );

      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .doc(id)
          .set(note.toJson());

      return note;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateNote({
    required String creatorId,
    required String noteId,
    String? title,
    String? content,
    DateTime? schedule,
    NoteStatus? status,
    List<SubTaskModel>? subTasks,
  }) async {
    try {
      final creatorSnap =
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .get();
      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final Map<String, dynamic> data = {};
      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (schedule != null) data['schedule'] = schedule;
      if (status != null) data['status'] = status.name;
      if (subTasks != null) {
        data['subTasks'] = subTasks.map((s) => s.toJson()).toList();
      }
      data['updatedAt'] = DateTime.now();

      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .doc(noteId)
          .update(data);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> getNoteById({
    required String creatorId,
    required String noteId,
  }) async {
    try {
      final docSnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .doc(noteId)
          .get();

      if (!docSnap.exists || docSnap.data() == null) {
        throw Exception("Note not found");
      }

      return NoteModel.fromJson(docSnap.data()!);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<NoteModel>> getNotesByCreator(String creatorId) async {
    try {
      final querySnap = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .get();

      return querySnap.docs
          .map((doc) => NoteModel.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<NoteModel>> getNotesByTags({
    required String creatorId,
    required List<String> tags,
  }) async {
    try {
      if (tags.isEmpty) {
        throw Exception("Tags must be a non-empty array");
      }

      final querySnapshot = await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .where('tag', arrayContainsAny: tags.map((t) => t.toUpperCase()))
          .get();

      return querySnapshot.docs
          .map((doc) => NoteModel.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteNote({
    required String creatorId,
    required String noteId,
  }) async {
    try {
      await _fireStore
          .collection(userCol)
          .doc(creatorId)
          .collection(notesCol)
          .doc(noteId)
          .delete();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }
}
