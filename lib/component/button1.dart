import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyButton1 extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isRounded;
  final bool isTapped;

  const MyButton1({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 40.0,
    this.isRounded = true,
    this.isTapped = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return IntrinsicWidth(
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isTapped ? cs.primary : cs.onPrimary,
            foregroundColor: isTapped ? cs.surface : cs.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isRounded ? 20.0 : 8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 2,
            minimumSize: Size(width ?? 0, height),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return cs.primary.withOpacity(0.8);
                }
                return null;
              },
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
