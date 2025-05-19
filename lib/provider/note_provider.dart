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
  Future<NoteModel> addNote({
    required String createdBy,
    required String title,
    String? content,
    List<String>? tags
  }) async{
    try{
      final id = Uuid().v4();

      await http.post(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'createdBy': createdBy,
          'title': title,
          'content': content,
          'tags': tags,
        }),
      );

      final note = await getNoteById(createdBy: createdBy, noteId: id);
      return note;
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> getNoteById({
    required String createdBy,
    required String noteId,
  }) async {
    try{
      if(noteId.isEmpty) throw Exception("NoteId empty");
      print("Creatorrr: $createdBy");
      print("Creatorrr: $noteId");
      final response = await http.get(
        Uri.parse('$url/$createdBy/$noteId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData['data'];
        print("KAASKMASKM $data");
        return NoteModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to get note: ${response.body}');
      }
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> updateNote({
    required String noteId,
    required String createdBy,
    required Map<String, dynamic> updatedData
  }) async {
    try{
      final response = await http.put(
        Uri.parse('$url/$noteId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update note: ${response.body}');
      }
      final noteUpdated = await getNoteById(createdBy: createdBy, noteId: noteId);

      return noteUpdated;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<NoteModel> getNotes(String createdBy) async {
    try{
      if(createdBy.isEmpty) throw Exception("NoteId empty");

      final response = await http.get(
        Uri.parse('$url/creator/$createdBy'),
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

  Future<NoteModel> getNotesByTag({
    required String createdBy,
    required List<String> tags
  }) async {
    try{
      if(createdBy.isEmpty) throw Exception("NoteId empty");

      final response = await http.post(
        Uri.parse('$url/creator/$createdBy'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "tags": tags
        })
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
}