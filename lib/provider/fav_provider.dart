
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';

final api = dotenv.env['SERVER_URI'];
final url = '$api/user';

class FavProvider {
  Future<FavModel> addFav ({
    required String creatorId,
    required String title,
    required List<String> noteId
  }) async {
    try{
      await http.post(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'creatorId': creatorId,
          'title': title,
          'noteId': noteId,
        }),
      );

      final fav = await getFavByTitle(creatorId: creatorId, title: title);
      return fav;
    } catch (e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<FavModel>> getFav(String creatorId) async {
    try {
      final response = await http.post(
        Uri.parse('$url/$creatorId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> favList = responseData['data']['data'];

        return favList
            .map((item) => FavModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to get fav: ${response.body}');
      }
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }


  Future<FavModel> getFavByTitle({
    required String creatorId,
    required String title
  }) async {
    try{
      final response = await http.post(
        Uri.parse('$url/$title'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"title": title})
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final favData = responseData['data'];
        return FavModel.fromJson(favData['data']);
      } else {
        throw Exception('Failed to get user: ${response.body}');
      }
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<FavModel> updateTitle ({
    required String creatorId,
    required String oldTitle,
    required String newTitle,
  }) async {
    try{
      final response = await http.put(
        Uri.parse('$url/title'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "oldTitle": oldTitle,
          "newTitle": newTitle
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.body}');
      }
      final dataUpdated = await getFavByTitle(creatorId: creatorId, title: newTitle);

      return dataUpdated;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<FavModel> update({
    required String creatorId,
    required String title,
    required Map<String, dynamic> updatedData
  }) async {
    try{
      final response = await http.put(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update note: ${response.body}');
      }
      final dataUpdated = await getFavByTitle(title: title, creatorId: creatorId);

      return dataUpdated;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }
}