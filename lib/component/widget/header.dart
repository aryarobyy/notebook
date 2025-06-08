import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHeader extends ConsumerWidget {
  final VoidCallback? onBackPressed;
  final String title;

  const MyHeader({
    Key? key,
    this.onBackPressed,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SizedBox(
      height: 66,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}