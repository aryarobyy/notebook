import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do_list/models/user_model.dart';
import 'package:to_do_list/provider/user_provider.dart';

final userServiceProvider = Provider((ref) => UserProvider());

@immutable
class State {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const State({
    this.isLoading = false,
    this.user,
    this.error,
  });

  State copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return State(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<State> {
  UserNotifier(this._provider) : super(const State());

  final UserProvider _provider;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> login(String email, String password, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _provider.login(email: email, password: password);
      await currentUser();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> register(String username, String email, String password, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _provider.register(
        username: username,
        email: email,
        password: password,
      );
      await login(email, password, ref);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> currentUser() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userDataString = await _storage.read(key: 'userData');

      if (userDataString == null || userDataString.isEmpty) {
        state = state.copyWith(isLoading: false, user: null);
        return;
      }

      final Map<String, dynamic> userMap = jsonDecode(userDataString);
      final String id = userMap['id'] as String;
      final user = await _provider.getUserById(id);
      state = state.copyWith(user: user, isLoading: false);
      return;
    } catch (e) {
      await _storage.delete(key: 'userData');
      state = state.copyWith(user: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<UserModel> update ({
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.updateUser(
        userId: userId,
        updatedData: updatedData
      );

      state = state.copyWith(isLoading: false, user: data);
      return data;
    } catch (e) {
      state = state.copyWith(user: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _storage.delete(key: 'userData');
      state = state.copyWith(user: null, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final userNotifierProvider =
  StateNotifierProvider<UserNotifier, State>(
      (ref) => UserNotifier(ref.read(userServiceProvider)),
);