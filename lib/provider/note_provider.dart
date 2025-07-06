import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';
import 'package:uuid/uuid.dart';

final api = dotenv.env['SERVER_URI'];
final url = '$api/note';
FlutterSecureStorage _storage = FlutterSecureStorage();

class NoteProvider {
  Future<NoteModel> addNote(
      {required String creatorId,
      required String title,
      String? content,
      List<String>? tags}) async {
    try {
      final id = Uuid().v4();

      final res = await http.post(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'creatorId': creatorId,
          'title': title,
          'content': content,
          'tags': tags,
        }),
      );
      if (res.statusCode == 500) {
        throw Exception("Something wrong");
      }
      final resData = jsonDecode(res.body)['data'];
      final data = resData['data'];
      return NoteModel.fromJson(data);
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
      print("NoteId : $noteId");
      if (noteId.isEmpty) throw Exception("NoteId empty");
      final response = await http.get(
        Uri.parse('$url/$creatorId/$noteId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData['data'];
        return NoteModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to get note: ${response.body}');
      }
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> updateNote({
    required String noteId,
    required String creatorId,
    required Map<String, dynamic> updatedData}) async {
      try {
        final response = await http.put(
          Uri.parse('$url/$noteId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updatedData),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update note: ${response.body}');
        }
        final noteUpdated =
            await getNoteById(creatorId: creatorId, noteId: noteId);

        return noteUpdated;
      } catch (e, stackTrace) {
        handleError(e, stackTrace);
        rethrow;
      }
  }

  Future<List<NoteModel>> getNotes(String creatorId) async {
    try {
      if (creatorId.isEmpty) throw Exception("NoteId empty");

      final response = await http.get(
        Uri.parse('$url/$creatorId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get note: ${response.body}');
      }
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final data = responseData['data'];
      final List<dynamic> noteList = data['data'] as List<dynamic>;
      final notes = noteList.map((e) => NoteModel.fromJson(e)).toList();
      return notes;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> getNotesByTag(
      {required String creatorId, required List<String> tags}) async {
    try {
      if (creatorId.isEmpty) throw Exception("NoteId empty");

      final response = await http.post(Uri.parse('$url/creator'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"creatorId": creatorId, "tags": tags}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData['data'];
        return NoteModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to get note: ${response.body}');
      }
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }
}
