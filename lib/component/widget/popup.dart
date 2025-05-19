import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  final String title;
  final String? content;
  final String? agreeText;
  final String? disagreeText;
  final VoidCallback? onAgreePressed;
  final VoidCallback? onDisagreePressed;

  const MyPopup({
    Key? key,
    required this.title,
    this.content,
    this.agreeText,
    this.disagreeText,
    this.onAgreePressed,
    this.onDisagreePressed,
  }) : super(key: key);

  static void show(
      BuildContext context, {
        required String title,
        String? content,
        String? disagreeText,
        String? agreeText,
        VoidCallback? onAgreePressed,
        VoidCallback? onDisagreePressed,
      }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim, secAnim) {
        return Center(
          child: MyPopup(
            title: title,
            content: content,
            agreeText: agreeText,
            disagreeText: disagreeText,
            onAgreePressed: () {
              Navigator.of(ctx).pop();
              if (onAgreePressed != null) onAgreePressed();
            },
            onDisagreePressed: () {
              Navigator.of(ctx).pop();
              if (onDisagreePressed != null) onDisagreePressed();
            },
          ),
        );
      },
      transitionBuilder: (ctx, animation, secAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final buttons = <Widget>[];
    if (disagreeText != null) {
      buttons.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: onDisagreePressed,
          child: Text(
            disagreeText!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
    if (agreeText != null) {
      buttons.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: onAgreePressed,
          child: Text(
            agreeText!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              const SizedBox(height: 12),
              Text(
                content!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttons.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: buttons.length == 1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: buttons,
              ),
            ],
          ],
        ),
      ),
    );
  }
}