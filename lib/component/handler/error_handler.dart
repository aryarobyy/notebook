import 'package:flutter/material.dart';

void handleError(Object e, StackTrace stackTrace) {
  final traceLines = stackTrace.toString().split('\n');
  final firstLine = traceLines.isNotEmpty ? traceLines[0] : 'unknown location';

  print('❌ Error: $e');
  print('📍 Terjadi di: $firstLine');
}