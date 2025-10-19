import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/card/todo_card.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/todo_notifier.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/calendar/calendar.dart';
import 'package:to_do_list/pages/focus/focus.dart';
import 'package:to_do_list/pages/home/home.dart';
import 'package:to_do_list/pages/note/add_note.dart';
import 'package:to_do_list/pages/setting/setting.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class Dashboard extends ConsumerStatefulWidget {
  Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

final TextEditingController _todoTitleController = TextEditingController();

class _DashboardState extends ConsumerState<Dashboard> {
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser;
  }

  final List<IconData> _iconList = [
    Icons.home,
    Icons.calendar_month,
    Icons.access_time_outlined,
    Icons.settings,
  ];

  void _onTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  Future<void> _loadUser() async {
    final notifier = ref.read(userNotifierProvider.notifier);
    await notifier.currentUser();
  }

  void _postTodo(String userId, String title) async {
    final notifier = ref.watch(todoNotifierProvider.notifier);
    if (title.isEmpty) {
      print("Judul gak boleh kosong");
    }

    await notifier
        .createTodo(
        creatorId: userId,
        title: title,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(userNotifierProvider);
    final userState = state.user;

    if (userState == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final widgetOption = [
      Home(userData: userState,),
      Calendar(),
      FocusPage(),
      Setting()
    ];

    return Scaffold(
      body: widgetOption[_currIndex],
      floatingActionButton: userState != null
          ? FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => _buildAddTodo(
              context,
              userState.id,
            )
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _iconList,
        activeIndex: _currIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: _onTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black54,
        height: 60,
        elevation: 8,
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        splashRadius: 20,
      ),
    );
  }

  Widget _buildAddTodo(BuildContext context, String userId) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(),
          ),
        ),
        Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: BoxConstraints(
                maxWidth: 600,
                minWidth: 300,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "assets/images/google.png",
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _todoTitleController,
                                  autofocus: true,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Masukkan judul",
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.star,
                          //     color: Colors.amber,
                          //   ),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () => _postTodo(userId, _todoTitleController.text),
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }
}
