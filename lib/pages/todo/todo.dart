import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo extends ConsumerStatefulWidget {
  const Todo({super.key});

  @override
  ConsumerState createState() => _TodoState();
}

class _TodoState extends ConsumerState<Todo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
