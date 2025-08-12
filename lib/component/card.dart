import 'package:flutter/material.dart';
import 'package:to_do_list/component/text.dart';

class MyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double width;
  final double height;
  final Color? color;
  final VoidCallback? onTap; // ✅ opsional

  const MyCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.width = double.infinity,
    this.height = 100,
    this.color,
    this.onTap, // ✅ default null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = color ?? cs.surface;
    final textColor = cs.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            const SizedBox(height: 4),
            MyText(
              subtitle,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}