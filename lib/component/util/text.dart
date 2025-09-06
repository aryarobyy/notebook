import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const MyText(
      this.text, {
        Key? key,
        this.fontSize = 20,
        this.color,
        this.fontWeight,
        this.textAlign,
        this.overflow,
        this.maxLines,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final defaultColor = color ?? cs.onBackground;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        color: defaultColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
