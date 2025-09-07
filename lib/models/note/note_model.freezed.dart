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
  @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE)
  NoteStatus get status;
  @JsonKey(fromJson: DateTimeFromJson)
  DateTime get createdAt;
  @JsonKey(fromJson: DateTimeFromJsonNullable)
  DateTime? get updatedAt;
  @JsonKey(fromJson: DateTimeFromJsonNullable)
  DateTime? get schedule;
  List<String> get tag;

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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(other.tag, tag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      creatorId,
      title,
      content,
      status,
      createdAt,
      updatedAt,
      schedule,
      const DeepCollectionEquality().hash(tag));

  @override
  String toString() {
    return 'NoteModel(id: $id, creatorId: $creatorId, title: $title, content: $content, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, schedule: $schedule, tag: $tag)';
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
      @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) NoteStatus status,
      @JsonKey(fromJson: DateTimeFromJson) DateTime createdAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
      List<String> tag});
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
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? schedule = freezed,
    Object? tag = null,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as NoteStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedule: freezed == schedule
          ? _self.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tag: null == tag
          ? _self.tag
          : tag // ignore: cast_nullable_to_non_nullable
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
            @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) NoteStatus status,
            @JsonKey(fromJson: DateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
            List<String> tag)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(
            _that.id,
            _that.creatorId,
            _that.title,
            _that.content,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.schedule,
            _that.tag);
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
            @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) NoteStatus status,
            @JsonKey(fromJson: DateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
            List<String> tag)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel():
        return $default(
            _that.id,
            _that.creatorId,
            _that.title,
            _that.content,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.schedule,
            _that.tag);
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
            @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) NoteStatus status,
            @JsonKey(fromJson: DateTimeFromJson) DateTime createdAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
            @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
            List<String> tag)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NoteModel() when $default != null:
        return $default(
            _that.id,
            _that.creatorId,
            _that.title,
            _that.content,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.schedule,
            _that.tag);
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
      @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) required this.status,
      @JsonKey(fromJson: DateTimeFromJson) required this.createdAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) this.updatedAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) this.schedule,
      required final List<String> tag})
      : _tag = tag;
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
  @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE)
  final NoteStatus status;
  @override
  @JsonKey(fromJson: DateTimeFromJson)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: DateTimeFromJsonNullable)
  final DateTime? updatedAt;
  @override
  @JsonKey(fromJson: DateTimeFromJsonNullable)
  final DateTime? schedule;
  final List<String> _tag;
  @override
  List<String> get tag {
    if (_tag is EqualUnmodifiableListView) return _tag;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tag);
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            const DeepCollectionEquality().equals(other._tag, _tag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      creatorId,
      title,
      content,
      status,
      createdAt,
      updatedAt,
      schedule,
      const DeepCollectionEquality().hash(_tag));

  @override
  String toString() {
    return 'NoteModel(id: $id, creatorId: $creatorId, title: $title, content: $content, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, schedule: $schedule, tag: $tag)';
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
      @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) NoteStatus status,
      @JsonKey(fromJson: DateTimeFromJson) DateTime createdAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
      @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
      List<String> tag});
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
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? schedule = freezed,
    Object? tag = null,
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
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as NoteStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedule: freezed == schedule
          ? _self.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tag: null == tag
          ? _self._tag
          : tag // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
