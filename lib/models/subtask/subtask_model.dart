import '../date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtask_model.freezed.dart';
part 'subtask_model.g.dart';

@freezed
sealed class SubTaskModel with _$SubTaskModel {
  factory SubTaskModel({
    required String id,
    required String text,
    required List<String> todoId,
    @JsonKey(fromJson: DateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? lastActive,
    @Default(false) bool isDone,
  }) = _SubTaskModel;

  factory SubTaskModel.fromJson(Map<String, dynamic> json) =>
      _$SubTaskModelFromJson(json);
}