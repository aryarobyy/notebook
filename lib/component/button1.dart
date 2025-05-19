import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buttonPressedProvider = StateProvider.family<bool, String>((ref, id) => false);

class MyButton1Notifier extends StateNotifier<bool> {
  MyButton1Notifier() : super(false);

  void press() => state = true;
  void release() => state = false;
}

final myButton1Provider = StateNotifierProvider.family<MyButton1Notifier, bool, String>((ref, id) {
  return MyButton1Notifier();
});

class MyButton1 extends ConsumerStatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double width;
  final double height;
  final bool isRounded;
  final String buttonId;

  const MyButton1({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonId,
    this.icon,
    this.width = 200.0,
    this.height = 50.0,
    this.isRounded = true,
  }) : super(key: key);

  @override
  ConsumerState<MyButton1> createState() => _MyButton1State();
}

class _MyButton1State extends ConsumerState<MyButton1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    ref.read(myButton1Provider(widget.buttonId).notifier).press();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    ref.read(myButton1Provider(widget.buttonId).notifier).release();
  }

  void _handleTapCancel() {
    _controller.reverse();
    ref.read(myButton1Provider(widget.buttonId).notifier).release();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isPressed = ref.watch(myButton1Provider(widget.buttonId));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: isPressed
                    ? cs.primary.withOpacity(0.8)
                    : cs.primary,
                borderRadius: BorderRadius.circular(
                  widget.isRounded ? 25.0 : 8.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.8),
                    blurRadius: isPressed ? 5.0 : 10.0,
                    spreadRadius: isPressed ? 1.0 : 2.0,
                    offset: Offset(0, isPressed ? 2.0 : 4.0),
                  ),
                ],
              ),
              child: Center(
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
            ),
          );
        },
      ),
    );
  }
}