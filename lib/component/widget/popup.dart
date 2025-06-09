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
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim, secAnim) {
        return MyPopup(
          title: title,
          content: content,
          agreeText: agreeText,
          disagreeText: disagreeText,
          onAgreePressed: onAgreePressed,
          onDisagreePressed: onDisagreePressed,
        );
      },
      transitionBuilder: (ctx, animation, secAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: curvedAnimation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              const SizedBox(height: 12),
              Text(
                content!,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final buttons = <Widget>[];

    if (disagreeText != null) {
      buttons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDisagreePressed?.call();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(disagreeText!),
          ),
        ),
      );
    }

    if (disagreeText != null && agreeText != null) {
      buttons.add(const SizedBox(width: 16));
    }

    if (agreeText != null) {
      buttons.add(
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onAgreePressed?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(agreeText!),
          ),
        ),
      );
    }

    if (buttons.length == 1) {
      return Center(child: buttons.first);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}