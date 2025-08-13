import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do_list/models/user_model.dart';
import 'package:to_do_list/provider/category_provider.dart';
import 'package:to_do_list/provider/user_provider.dart';

final userServiceProvider = Provider((ref) => UserProvider());
final secureStorageProvider = Provider((ref) => FlutterSecureStorage());
FlutterSecureStorage _storage = FlutterSecureStorage();

@immutable
class UserState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const UserState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  UserState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this._provider, this._storage) : super(const UserState());

  final UserProvider _provider;
  final FlutterSecureStorage _storage;

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _provider.login(email: email, password: password);
      await currentUser();
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _provider.register(
        username: username,
        email: email,
        password: password,
      );
      // await login(email, password, ref);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> currentUser() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tokenValid = await verifToken();

      if (!tokenValid) {
        print('Token tidak valid');
        state = state.copyWith(isLoading: false, user: null, error: null);
        return;
      }

      print('Token valid, mengambil userData...');
      final userDataString = await _storage.read(key: 'userData');

      if (userDataString == null || userDataString.isEmpty) {
        print('UserData tidak ditemukan');
        state = state.copyWith(isLoading: false, user: null, error: null);
        return;
      }

      Map<String, dynamic> userMap;
      try {
        userMap = jsonDecode(userDataString);
      } catch (e, s) {
        state = state.copyWith(
            user: null,
            error: "Gagal parse JSON: ${e.toString()}",
            isLoading: false);
        await logout();
        return;
      }

      UserModel user;
      try {
        user = UserModel.fromJson(userMap);
      } catch (e, s) {
        state = state.copyWith(
            user: null,
            error: "Gagal konversi data user: ${e.toString()}",
            isLoading: false);
        await logout();
        return;
      }

      print('Cek CurrentUser berhasil, user: ${user.toString()}');
      state = state.copyWith(user: user, isLoading: false, error: null);

    } catch (e, stackTrace) {
      print('currentUser - Error umum di luar dugaan: $e\n$stackTrace');
      state = state.copyWith(user: null, error: e.toString(), isLoading: false);
      await logout();
    }
  }

  Future<bool> verifToken() async {
    try {
      final token = await _storage.read(key: 'token');
      print('Token: $token');

      if (token == null || token.isEmpty) {
        print('Token tidak ditemukan');
        return false;
      }

      final bool isUserValid = await _provider.verifyToken(token);

      if (!isUserValid) {
        print('Token tidak valid, menghapus dari storage');
        await _storage.delete(key: 'token');
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      print('Error during verify token: $e\n$stackTrace');
      return false;
    }
  }


  Future<UserModel> update({
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data =
          await _provider.updateUser(userId: userId, updatedData: updatedData);

      state = state.copyWith(isLoading: false, user: data);
      return data;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> logout([Map<String, dynamic>? userData]) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      if (userData != null && userData.containsKey('id')) {
        await _provider.logout(userData['id']);
      }

      await _storage.delete(key: 'userData');
      await _storage.delete(key: 'token');

      state = state.copyWith(user: null, isLoading: false);
    } catch (e, stackTrace) {
      print('Error during logout: $e\n$stackTrace');
      state = state.copyWith(user: null, isLoading: false);
    }
  }

  Future<void> signIn() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _provider.googleSignIn();
    } catch (e, stackTrace) {
      print('Error during signIn: $e\n$stackTrace');
      state = state.copyWith(user: null, error: e.toString(), isLoading: false);
    }
  }
}

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(
    ref.read(userServiceProvider),
    ref.read(secureStorageProvider),
  ),
);
