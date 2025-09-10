import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do_list/models/user/user_model.dart';
import 'package:to_do_list/service/user_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final userServiceProvider = Provider((ref) => UserService());
final secureStorageProvider = Provider((ref) => FlutterSecureStorage());

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
  UserNotifier(this._service, this._storage) : super(const UserState());

  final UserService _service;
  final FlutterSecureStorage _storage;

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.login(email: email, password: password);
      await currentUser();
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.register(
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
      final userDataString = await _storage.read(key: "userData");
      final userMap = jsonDecode(userDataString!);

      final user = UserModel.fromJson(userMap);

      state = state.copyWith(user: user, isLoading: false, error: null);
    } catch (e, s) {
      state = state.copyWith(isLoading: false, user: null, error: e.toString());
      await logout();
    }
  }

  Future<bool> verifyToken() async {
    try {
      final bool isUserValid = await _service.verifyToken();

      if (!isUserValid) {
        print('Token tidak valid, menghapus dari storage');
        return false;
      }

      return true;
    } catch (e, stackTrace) {
      print('Error during verify token: $e\n$stackTrace');
      return false;
    }
  }

  Future<void> update({
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data =
          await _service.updateUser(userId: userId, updatedData: updatedData);

      state = state.copyWith(isLoading: false, user: data);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _service.signOut();

      await _storage.deleteAll();

      state = state.copyWith(user: null, isLoading: false);
    } catch (e, stackTrace) {
      print('Error during logout: $e\n$stackTrace');
      state = state.copyWith(user: null, isLoading: false);
    }
  }

  Future<void> signIn() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _service.signInWithGoogle();
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
