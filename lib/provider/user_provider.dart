import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';

final api = dotenv.env['SERVER_URI'];
final url = '$api/user';
FlutterSecureStorage _storage = FlutterSecureStorage();

class UserProvider {

  Future<void> savingUser() async {
    try {
      final userDataString = await _storage.read(key: 'userData');
      if (userDataString == null) {
        throw Exception("User data undefined");
      }

      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      final String? userId = userMap['id'];
      if (userId == null) {
        throw Exception("User id is missing in stored userData");
      }

      Map<String, dynamic> updatedUserData = Map<String, dynamic>.from(userMap);

      final String? profilePicUrl = userMap['profilePic'];
      if (profilePicUrl != null && profilePicUrl.isNotEmpty &&
          (profilePicUrl.startsWith('http://') || profilePicUrl.startsWith('https://'))) {

        final savedProfilePath = await _downloadAndSaveImage(
            profilePicUrl, userId, 'Profile');

        if (savedProfilePath != null) {
          updatedUserData['profilePic'] = savedProfilePath;
          print("Profile picture set to local path: $savedProfilePath");
        }
      }

      final String? bannerPicUrl = userMap['bannerPic'];
      if (bannerPicUrl != null && bannerPicUrl.isNotEmpty &&
          (bannerPicUrl.startsWith('http://') || bannerPicUrl.startsWith('https://'))) {

        final savedBannerPath = await _downloadAndSaveImage(
            bannerPicUrl, userId, 'Banner');

        if (savedBannerPath != null) {
          updatedUserData['bannerPic'] = savedBannerPath;
          print("Banner picture set to local path: $savedBannerPath");
        }
      }

      await _storage.write(key: 'userData', value: jsonEncode(updatedUserData));
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<String?> _downloadAndSaveImage(String url, String userId, String dirName) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final imageDir = Directory('${dir.path}/$dirName');

        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        final image = img.decodeImage(response.bodyBytes);
        if (image == null) {
          return null;
        }

        final filePath = '${imageDir.path}/$userId.png';
        final file = File(filePath);

        await file.writeAsBytes(img.encodePng(image));

        return filePath;
      } else {
        print("Failed to download image. Status code: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
    return null;
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try{
      final response = await http.post(
        Uri.parse('$url/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'token', value: data['token']);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try{
      final response = await http.post(
        Uri.parse('$url/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        await _storage.write(key: 'token', value: data['token']);
        final userData = data['data'];
        final Map<String, dynamic> userMap = userData['data'];
        await _storage.write(key: 'userData', value: jsonEncode(userMap));
        await savingUser();
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    final token = await _storage.read(key: 'token');

    try{
      if (token == null) {
        throw Exception('No token found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('$url/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final userData = responseData['data'];
        return UserModel.fromJson(userData['data']);
      } else {
        throw Exception('Failed to get user: ${response.body}');
      }
    } catch(e, stackTrace){
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> updateUser({
    required String userId,
    required Map<String, dynamic> updatedData
  }) async {
    try{
      final response = await http.put(
        Uri.parse('$url/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.body}');
      }

      final userUpdated = await getUserById(userId);

      return userUpdated;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> logout(String userId) async {
    try{
      await http.post(
        Uri.parse('$url/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id":userId}),
      );
      await _storage.delete(key: 'token');
      final del = await _storage.delete(key: 'userData');
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<bool> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$url/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('Token verification failed: ${errorData['message']}');
        return false;
      }
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      return false;
    }
  }


  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}