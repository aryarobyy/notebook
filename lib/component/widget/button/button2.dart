
import 'package:flutter_riverpod/legacy.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonPressedProvider = StateProvider<Offset>((ref) => Offset.zero);

class MyButton2Notifier extends StateNotifier<Offset> {
  MyButton2Notifier() : super(Offset.zero);

  void updateTapPosition(Offset position) => state = position;
}

final myButton2Provider = StateNotifierProvider<MyButton2Notifier, Offset>((ref) {
  return MyButton2Notifier();
});


class MyButton2 extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double width;
  final double height;

  const MyButton2({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width = 200.0,
    this.height = 50.0,
  }) : super(key: key);

  @override
  ConsumerState<MyButton2> createState() => _MyButton2State();
}

class _MyButton2State extends ConsumerState<MyButton2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    ref.read(myButton2Provider.notifier).updateTapPosition(localPosition);
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tapPosition = ref.watch(myButton2Provider);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  left: tapPosition.dx - (widget.width * _rippleAnimation.value / 2),
                  top: tapPosition.dy - (widget.width * _rippleAnimation.value / 2),
                  child: Opacity(
                    opacity: 1.0 - _rippleAnimation.value / 2,
                    child: Container(
                      width: widget.width * _rippleAnimation.value,
                      height: widget.width * _rippleAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
