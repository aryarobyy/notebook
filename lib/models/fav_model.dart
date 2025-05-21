import 'package:freezed_annotation/freezed_annotation.dart';

part 'fav_model.freezed.dart';
part 'fav_model.g.dart';

@freezed
sealed class FavModel with _$FavModel {
  factory FavModel({
    required String title,
    required List<String> noteId,
  }) = _FavModel;
  factory FavModel.fromJson(Map<String, dynamic> json) => _$FavModelFromJson(json);
}