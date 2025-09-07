DateTime DateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is Map<String, dynamic> &&
      value.containsKey('seconds') &&
      value.containsKey('nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['seconds'] * 1000 + value['nanoseconds'] ~/ 1000000).toInt(),
    );
  }

  if (value is String) {
    return DateTime.parse(value);
  }

  return DateTime.now();
}

DateTime? DateTimeFromJsonNullable(dynamic value) {
  if (value == null) return null;

  if (value is Map<String, dynamic> &&
      value.containsKey('seconds') &&
      value.containsKey('nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['seconds'] * 1000 + value['nanoseconds'] ~/ 1000000).toInt(),
    );
  }

  if (value is String) {
    return DateTime.parse(value);
  }

  return null;
}