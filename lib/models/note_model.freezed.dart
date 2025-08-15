// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteModel {
  String get id;
  String get creatorId;
  String get title;
  String get content;
  @JsonKey(fromJson: _dateTimeFromJson)
  DateTime get createdAt;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get lastActive;
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  DateTime? get schedule;
  List<String> get tags;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NoteModelCopyWith<NoteModel> get copyWith =>
      _$NoteModelCopyWithImpl<NoteModel>(this as NoteModel, _$identity);

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NoteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(other.tags, tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      creatorId,
      title,
      content,
      createdAt,
      lastActive,
      schedule,
      const DeepCollectionEquality().hash(tags));

  @override
  String toString() {
    return 'NoteModel(id: $id, creatorId: $creatorId, title: $title, content: $content, createdAt: $createdAt, lastActive: $lastActive, schedule: $schedule, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) _then) =
      _$NoteModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String creatorId,
      String title,
      String content,
      @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
      List<String> tags});
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res> implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._self, this._then);

  final NoteModel _self;
  final $Res Function(NoteModel) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? lastActive = freezed,
    Object? schedule = freezed,
    Object? tags = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _self.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: freezed == lastActive
          ? _self.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedule: freezed == schedule
          ? _self.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [NoteModel].
extension NoteModelPatterns on NoteModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NoteModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NoteModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NoteModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String creatorId,
            String title,
            String content,
            @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
            List<String> tags)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(_that.id, _that.creatorId, _that.title, _that.content,
            _that.createdAt, _that.lastActive, _that.schedule, _that.tags);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String creatorId,
            String title,
            String content,
            @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
            List<String> tags)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel():
        return $default(_that.id, _that.creatorId, _that.title, _that.content,
            _that.createdAt, _that.lastActive, _that.schedule, _that.tags);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String creatorId,
            String title,
            String content,
            @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
            @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
            List<String> tags)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(_that.id, _that.creatorId, _that.title, _that.content,
            _that.createdAt, _that.lastActive, _that.schedule, _that.tags);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NoteModel implements NoteModel {
  _NoteModel(
      {required this.id,
      required this.creatorId,
      required this.title,
      required this.content,
      @JsonKey(fromJson: _dateTimeFromJson) required this.createdAt,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) this.lastActive,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) this.schedule,
      required final List<String> tags})
      : _tags = tags;
  factory _NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  @override
  final String id;
  @override
  final String creatorId;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? lastActive;
  @override
  @JsonKey(fromJson: _dateTimeFromJsonNullable)
  final DateTime? schedule;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NoteModelCopyWith<_NoteModel> get copyWith =>
      __$NoteModelCopyWithImpl<_NoteModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NoteModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NoteModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      creatorId,
      title,
      content,
      createdAt,
      lastActive,
      schedule,
      const DeepCollectionEquality().hash(_tags));

  @override
  String toString() {
    return 'NoteModel(id: $id, creatorId: $creatorId, title: $title, content: $content, createdAt: $createdAt, lastActive: $lastActive, schedule: $schedule, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class _$NoteModelCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$NoteModelCopyWith(
          _NoteModel value, $Res Function(_NoteModel) _then) =
      __$NoteModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String creatorId,
      String title,
      String content,
      @JsonKey(fromJson: _dateTimeFromJson) DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
      @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
      List<String> tags});
}

/// @nodoc
class __$NoteModelCopyWithImpl<$Res> implements _$NoteModelCopyWith<$Res> {
  __$NoteModelCopyWithImpl(this._self, this._then);

  final _NoteModel _self;
  final $Res Function(_NoteModel) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? lastActive = freezed,
    Object? schedule = freezed,
    Object? tags = null,
  }) {
    return _then(_NoteModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _self.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActive: freezed == lastActive
          ? _self.lastActive
          : lastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedule: freezed == schedule
          ? _self.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
