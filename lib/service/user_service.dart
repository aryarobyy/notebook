import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list/component/core/constant.dart';
import 'package:to_do_list/component/handler/error_handler.dart';
import 'package:to_do_list/models/index.dart';

final userCol = USER_COLLECTION;

class UserService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();
  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  Future<void> InitializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await InitializeGoogleSignIn();
    }
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
  }) async {
    if (email.isEmpty) throw Exception("Email cannot be empty");
    if (password.isEmpty) throw Exception("Password cannot be empty");
    if (username.isEmpty) throw Exception("Username cannot be empty");
    if (!isValidEmail(email)) throw Exception("Invalid email format");

    try {
      final querySnap = await _fireStore
          .collection(userCol)
          .where('email', isEqualTo: email)
          .get();

      if (querySnap.docs.isNotEmpty) {
        throw Exception("Email is already used");
      }

      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user?.uid;
      if (uid == null) throw Exception("Failed to create user account");

      final userData = {
        'id': uid,
        'username': username,
        'email': email,
        'role': "USER",
        'createdAt': DateTime.now().toIso8601String(),
        'lastActive': DateTime.now().toIso8601String(),
      };

      await _fireStore
          .collection(userCol)
          .doc(uid)
          .set(userData);

      final storedData =
      await _fireStore
          .collection(userCol)
          .doc(uid)
          .get();

      final jsonData = storedData.data();
      if (jsonData == null) throw Exception("Failed to load stored user data");

      final userModel = UserModel.fromJson(jsonData);
      await _storage.write(key: 'userData', value: jsonEncode(jsonData));

      return userModel;
    } on FirebaseAuthException catch (e, stackTrace) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered. Please login instead.";
          break;
        case 'invalid-email':
          message = "The email format is invalid.";
          break;
        case 'weak-password':
          message = "Password is too weak. Try a stronger one.";
          break;
        default:
          message = "Registration failed. Code: ${e.code}";
      }
      handleError(message, stackTrace);
      throw Exception(message);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty) throw Exception("Email cannot be empty");
    if (password.isEmpty) throw Exception("Password cannot be empty");
    if (!isValidEmail(email)) throw Exception("Invalid email format");

    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCred.user;
      if (user == null) throw Exception("Failed to retrieve user information");

      final token = await user.getIdToken(true);
      if (token!.isEmpty) throw Exception("Failed to retrieve token");

      final querySnap = await _fireStore
          .collection(userCol)
          .where('email', isEqualTo: email.trim())
          .limit(1)
          .get();

      if (querySnap.docs.isEmpty) {
        throw Exception("User profile not found; please register first.");
      }

      final userDoc = querySnap.docs.first;
      await _fireStore.collection(userCol).doc(userDoc.id).update({
        'lastActive': DateTime.now().toIso8601String(),
        'isActive': true,
      });

      final data = UserModel.fromJson(userDoc.data());
      await _storage.write(key: 'userData', value: jsonEncode(userDoc.data()));
      await savingUser();
      return data;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel> updateUser ({
    required String userId,
    required Map<String, dynamic> updatedData
  }) async {
    try{
      final userSnap =
      await _fireStore
          .collection(userCol)
          .doc(userId)
          .get();
      if (!userSnap.exists) throw Exception("Unknown user: $userId");
      if(updatedData.isEmpty) throw Exception("No data to update");
      if(updatedData['role']) throw Exception("Cant update Role in here");

      await _fireStore
          .collection(userCol)
          .doc(userId)
          .update(updatedData);
      return UserModel.fromJson(updatedData);
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<bool> changeRole(String userId, Role newRole) async {
    try {
      final currUser = await _storage.read(key: "userData");

      if (currUser == null || !currUser.contains("SUPER_ADMIN")) {
        throw Exception("Only SUPER_ADMIN can change roles");
      }

      if (newRole == Role.SUPER_ADMIN) {
        throw Exception("Cannot assign SUPER_ADMIN role");
      }

      await _fireStore
          .collection(userCol)
          .doc(userId)
          .update({'role': newRole.toString().split('.').last});

      return true;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<bool> verifyToken() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        print("Tidak ada user login (token expired / belum login)");
        await signOut();
        return false;
      }

      await firebaseUser.getIdToken();

      final userDoc = await _fireStore.collection(userCol).doc(firebaseUser.uid).get();

      if (!userDoc.exists) {
        print("User tidak ditemukan di Firestore, logout");
        await signOut();
        return false;
      }

      return true;
    } on FirebaseAuthException catch (e, s) {
      print("verifyToken FirebaseAuth error: ${e.code} - ${e.message}\n$s");
      await signOut();
      return false;
    } catch (e, s) {
      print("verifyToken error: $e\n$s");
      await signOut();
      return false;
    }
  }

  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user is currently logged in");
    return user.uid;
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final data = await _storage.read(key: 'userData');
      if (data == null) throw Exception("No user data found in storage");
      return UserModel.fromJson(jsonDecode(data));
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Stream<UserModel> getUserById(String userId) {
    if (userId.isEmpty) throw Exception("UserId cant be empty");
    return _fireStore
        .collection(userCol)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) throw Exception("User not found");
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  Stream<List<UserModel>> getUsers() {
    return _fireStore.collection(userCol).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<UserModel?> getUserByEmail(String email) async {
    if (email.isEmpty) throw Exception("Email cant be empty");
    try {
      final data = await _fireStore
          .collection(userCol)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (data.docs.isEmpty) return null;
      return UserModel.fromJson(data.docs.first.data());
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> savingUser() async {
    try {
      final userDataString = await _storage.read(key: 'userData');
      if (userDataString == null) throw Exception("User data undefined");

      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      final String? userId = userMap['id'];
      if (userId == null) throw Exception("User id is missing");

      Map<String, dynamic> updatedUserData =
      Map<String, dynamic>.from(userMap);

      final String? imageUrl = userMap['image'];
      if (imageUrl != null &&
          (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
        final savedPath =
        await _downloadAndSaveImage(imageUrl, userId, 'Profile');
        if (savedPath != null) {
          updatedUserData['image'] = savedPath;
        }
      }

      await _storage.write(key: 'userData', value: jsonEncode(updatedUserData));
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  Future<String?> _downloadAndSaveImage(
      String url, String userId, String dirName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final dir = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${dir.path}/$dirName');

      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final image = img.decodeImage(response.bodyBytes);
      if (image == null) return null;

      final filePath = '${imageDir.path}/$userId.png';
      final file = File(filePath);

      await file.writeAsBytes(img.encodePng(image));
      return filePath;
    } catch (e, stackTrace) {
      handleError(e, stackTrace);
      rethrow;
    }
  }

  GoogleSignInAuthentication getAuthTokens(GoogleSignInAccount account) {
    return account.authentication;
  }

  Future<GoogleSignInAccount> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    try {
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleAuth.idToken
      );
      await _auth.signInWithCredential(authCredential);

      if (_auth.currentUser != null) {
        throw("Login success");
      } else {
        throw("Google Sign-In failed: User is null");
      }
    } on GoogleSignInException catch (e, stackTrace) {
        handleError(e, stackTrace);
        rethrow;
      } catch (error) {
        print('Unexpected Google Sign-In error: $error');
        rethrow;
      }
  }

  Future<void> signOut() async {
    await _storage.deleteAll();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}
