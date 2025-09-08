import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/component/core/constant.dart';
import 'package:to_do_list/component/handler/error_handler.dart';
import '../models/category/category_model.dart';

final String userCol = USER_COLLECTION;
final String categoryCol = CATEGORY_COLLECTION;

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CategoryModel> addCategory({
    required String creatorId,
    required String title,
    List<String>? noteId,
  }) async {
    try {
      if (creatorId.isEmpty || title.isEmpty) {
        throw Exception("creatorId or title is empty");
      }

      final creatorRef = _firestore.collection(userCol).doc(creatorId);
      final creatorSnap = await creatorRef.get();

      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final formattedTitle = _titleHandler(title);
      final categoryRef =
      creatorRef.collection(categoryCol).doc(formattedTitle);

      final postedData = <String, dynamic>{
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      };

      if (noteId != null && noteId.isNotEmpty) {
        postedData['noteId'] = noteId;
      }

      await categoryRef.set(postedData, SetOptions(merge: true));
      final querySnap = await categoryRef.get();

      final data = querySnap.data();
      if (data == null) {
        throw Exception("Failed to fetch category after saving");
      }

      return CategoryModel.fromJson({
        'title': querySnap.id,
        ...data,
      });
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<CategoryModel>> getAllCategory(String creatorId) async {
    try {
      if (creatorId.isEmpty) throw Exception("creatorId is empty");

      final creatorRef = _firestore.collection(userCol).doc(creatorId);
      final creatorSnap = await creatorRef.get();
      if (!creatorSnap.exists) {
        throw Exception("Unknown creator: $creatorId");
      }

      final querySnap = await creatorRef.collection(categoryCol).get();
      return querySnap.docs
          .map((doc) => CategoryModel.fromJson({
        'title': doc.id,
        ...doc.data(),
      }))
          .toList();
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<CategoryModel> getCategoryByTitle({
    required String creatorId,
    required String title,
  }) async {
    try {
      if (creatorId.isEmpty || title.isEmpty) {
        throw Exception("creatorId or title missing");
      }

      final formattedTitle = _titleHandler(title);
      final docRef = _firestore
          .collection(userCol)
          .doc(creatorId)
          .collection(categoryCol)
          .doc(formattedTitle);

      final querySnap = await docRef.get();

      return CategoryModel.fromJson({
        'title': querySnap.id,
        ...querySnap.data()!,
      });
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory({
    required String creatorId,
    required String title,
    List<String> addNoteId = const [],
    List<String> removeNoteId = const [],
  }) async {
    try {
      if (creatorId.isEmpty || title.isEmpty) {
        throw Exception("creatorId and title are required");
      }

      final formattedTitle = _titleHandler(title);
      final categoryRef = _firestore
          .collection(userCol)
          .doc(creatorId)
          .collection(categoryCol)
          .doc(formattedTitle);

      final querySnap = await categoryRef.get();
      if (!querySnap.exists) {
        throw Exception("Category '$formattedTitle' not found");
      }

      final updateData = <String, dynamic>{};

      if (addNoteId.isNotEmpty) {
        updateData['noteId'] = FieldValue.arrayUnion(addNoteId);
      }
      if (removeNoteId.isNotEmpty) {
        updateData['noteId'] = FieldValue.arrayRemove(removeNoteId);
      }

      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
        await categoryRef.update(updateData);
      }
      return CategoryModel.fromJson(updateData);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<CategoryModel> updateTitle({
    required String creatorId,
    required String oldTitle,
    required String newTitle,
  }) async {
    try {
      if (creatorId.isEmpty || oldTitle.isEmpty || newTitle.isEmpty) {
        throw Exception("creatorId, oldTitle, or newTitle missing");
      }

      final creatorRef = _firestore.collection(userCol).doc(creatorId);

      final oldFormatted = _titleHandler(oldTitle);
      final newFormatted = _titleHandler(newTitle);

      final oldRef = creatorRef.collection(categoryCol).doc(oldFormatted);
      final newRef = creatorRef.collection(categoryCol).doc(newFormatted);

      final oldSnap = await oldRef.get();
      if (!oldSnap.exists) throw Exception("Old category not found");

      final oldData = oldSnap.data()!;

      await newRef.set({
        ...oldData,
        'title': newFormatted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await oldRef.delete();

      final newSnap = await newRef.get();
      if (!newSnap.exists) throw Exception("Failed to create new category");

      return CategoryModel.fromJson(newSnap.data()!);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }


  String _titleHandler(String title) {
    return title
        .toLowerCase()
        .split(" ")
        .map((word) =>
    word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : "")
        .join(" ");
  }
}
