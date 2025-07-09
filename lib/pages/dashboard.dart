import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/notifiers/user_notifier.dart';
import 'package:to_do_list/pages/calendar/calendar.dart';
import 'package:to_do_list/pages/focus/focus.dart';
import 'package:to_do_list/pages/home/home.dart';
import 'package:to_do_list/pages/note/add_note.dart';
import 'package:to_do_list/pages/setting.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class Dashboard extends ConsumerStatefulWidget {
  Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

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

  @override
  Widget build(BuildContext context) {
    final state    = ref.watch(userNotifierProvider);
    final notifier = ref.read(userNotifierProvider.notifier);
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
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AddNote(userId: userState.id),
            ),
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
}
