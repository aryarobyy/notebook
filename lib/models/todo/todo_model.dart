import '../date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
sealed class TodoModel with _$TodoModel {
  factory TodoModel({
    required String id,
    required String title,
    String? subTitle,
    List<String>? noteId,
    List<String>? tag,
    List<String>? subTasks,
    @Default(false) bool isDone,
    @JsonKey(fromJson: DateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? lastActive,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}