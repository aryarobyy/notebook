
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';

final api = dotenv.env['SERVER_URI'];
final url = '$api/fav';

class FavProvider {
  Future<FavModel> addFav ({
    required String creatorId,
    required String title,
    required List<String> noteId
  }) async {
    try{
      final res = await http.post(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'creatorId': creatorId,
          'title': title,
          'noteId': noteId,
        }),
      );

      final resData = jsonDecode(res.body)['data'];
      final data = resData['data'];
      return FavModel.fromJson(data);
    } catch (e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<List<FavModel>> getFav(String creatorId) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$creatorId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("ASMSKAMAKS1");

        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("Hello 1");
        final Map<String, dynamic> data = responseData['data'];
        print("Hello 2");
        final List<dynamic> favList = data['data'] as List<dynamic>;

        print("Dataaaa: $favList");

        final favs = favList.map((e) {
          try {
            final parsed = FavModel.fromJson({
              ...e,
              'noteId': (e['noteId'] as List?)?.cast<String>(),
            });
            print("Parsed item: $parsed");
            return parsed;
          } catch (err) {
            print("Error parsing item: $e\nError: $err");
            rethrow;
          }
        }).toList();

        print("Data: $data");
        return favs;
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
        Uri.parse('$url/title'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "creatorId": creatorId,
          "title": title
        })
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final favData = responseData['data'];
        final data = favData['data'];
        return FavModel.fromJson(data);
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
      final res = await http.put(
        Uri.parse('$url/title'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "oldTitle": oldTitle,
          "newTitle": newTitle
        }),
      );
      final resData = jsonDecode(res.body)['data'];
      if (res.statusCode != 200) {
        throw Exception('Failed to update user: ${res.body}');
      }
      final data = resData['data'];

      return FavModel.fromJson(data);
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