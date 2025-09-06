import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String inputText;
  final bool isTitle;
  final int? maxLine;

  const NoteTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    required this.inputText,
    this.maxLine,
    this.isTitle = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType:  isTitle == true ? TextInputType.text : TextInputType.multiline,
        maxLines: maxLine ?? 1,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          color: cs.onSecondary,
        ),
        decoration: InputDecoration(
          hintText: inputText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 20,
            color: isTitle == true ? Colors.grey[700] : Colors.grey[500],
            fontWeight: isTitle == true ? FontWeight.w500 : FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}