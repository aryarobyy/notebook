import 'dart:ui';

import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
enum SnackType { success, error, info, warning }

class MySnackBar {
  static void show(
      String message, {
        SnackType type = SnackType.info,
        String? actionLabel,
        VoidCallback? onAction,
        Duration duration = const Duration(seconds: 3),
      }) {
    final (color, icon) = _style(type);

    final snack = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: color,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      action: (actionLabel != null)
          ? SnackBarAction(
        label: actionLabel,
        onPressed: onAction ?? () {},
      )
          : null,
    );

    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snack);
  }

  static (Color, IconData) _style(SnackType type) {
    switch (type) {
      case SnackType.success:
        return (Colors.green.shade600, Icons.check_circle);
      case SnackType.error:
        return (Colors.red.shade700, Icons.error);
      case SnackType.warning:
        return (Colors.orange.shade700, Icons.warning);
      case SnackType.info:
        return (Colors.blueGrey.shade800, Icons.info);
    }
  }
}