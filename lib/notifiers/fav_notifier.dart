import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/provider/fav_provider.dart';

final favServiceProvider = Provider((ref) => FavProvider());

@immutable
class State {
  final bool isLoading;
  final FavModel? favourite;
  final String? error;
  final List<FavModel>? favourites;

  const State({
    this.isLoading = false,
    this.favourite,
    this.error,
    this.favourites
  });

  State copyWith({
    bool? isLoading,
    FavModel? favourite,
    String? error,
    List<FavModel>? favourites
  }) {
    return State(
      isLoading: isLoading ?? this.isLoading,
      favourite: favourite ?? this.favourite,
      error: error ?? this.error,
      favourites: favourites ?? this.favourites,
    );
  }
}

class FavNotifier extends StateNotifier<State> {
  FavNotifier(this._provider) : super(const State());

  final FavProvider _provider;

  Future<FavModel> addFav (String creatorId, String title, List<String> noteId) async{
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.addFav(
        creatorId: creatorId,
        title: title,
        noteId: noteId
      );
      state = state.copyWith(isLoading: false, favourite: data);
      return data;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<FavModel> favByTitle (String creatorId, String title) async{
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.getFavByTitle(
          creatorId: creatorId,
          title: title
      );
      state = state.copyWith(isLoading: false, favourite: data);
      return data;
    } catch (e) {
      state = state.copyWith(favourite: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<List<FavModel>> favByCreator (String creatorId) async{
    state = state.copyWith(isLoading: true, error: null);
    try{
      final favourites = await _provider.getFav(creatorId);
      state = state.copyWith(favourites: favourites, isLoading: false);
      return favourites;
    } catch (e) {
      state = state.copyWith(favourites: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<FavModel> updateTitle ({
    required String creatorId,
    required String oldTitle,
    required String newTitle,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.updateTitle(
          creatorId: creatorId,
          oldTitle: oldTitle,
          newTitle: newTitle
      );

      state = state.copyWith(isLoading: false, favourite: data);
      return data;
    } catch (e) {
      state = state.copyWith(favourite: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<FavModel> update ({
    required String creatorId,
    required String title,
    required Map<String, dynamic> updatedData
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try{
      final data = await _provider.update(
        creatorId: creatorId,
        title: title,
        updatedData: updatedData
      );

      state = state.copyWith(isLoading: false, favourite: data);
      return data;
    } catch (e) {
      state = state.copyWith(favourite: null, error: e.toString(), isLoading: false);
      rethrow;
    }
  }

}