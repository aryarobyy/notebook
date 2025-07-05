import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/button1.dart';
import 'package:to_do_list/component/card.dart';
import 'package:to_do_list/component/size/size_config.dart';
import 'package:to_do_list/component/text.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/note/note.dart';
import 'package:to_do_list/pages/profile_page.dart';

class Home extends ConsumerStatefulWidget {
  final UserModel userData;
  Home({super.key, required this.userData});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final navTitleProvider = StateProvider<String>((ref) {
    return "All";
  });
  final loadingNavProvider = StateProvider<String?>((ref) => null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.userData.id.isNotEmpty) {
        ref
            .read(categoryNotifierProvider.notifier)
            .categoryByCreator(widget.userData.id);
        ref
            .read(noteNotifierProvider.notifier)
            .noteByCreator(widget.userData.id);
      }
    });
  }

  void _handleNavChange(String newTitle) async {
    final currentTitle = ref.read(navTitleProvider);
    if (newTitle == currentTitle) return;

    ref.read(navTitleProvider.notifier).state = newTitle;
    ref.read(loadingNavProvider.notifier).state = newTitle;

    if (newTitle == "All") {
      await ref
          .read(noteNotifierProvider.notifier)
          .noteByCreator(widget.userData.id);
    } else {}

    ref.read(loadingNavProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final noteState = ref.watch(noteNotifierProvider);
    final noteNotifier = ref.read(noteNotifierProvider.notifier);

    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       MyText(
      //         "Home",
      //         fontSize: 22,
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          "Welcome back",
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 4),
                        MyText(
                          widget.userData.username,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProfilePage(userData: widget.userData),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: cs.primary.withOpacity(0.4),
                        backgroundImage: widget.userData.image != null &&
                                widget.userData.image!.isNotEmpty
                            ? NetworkImage(widget.userData.image!)
                            : const AssetImage("assets/bayu.jpg")
                                as ImageProvider,
                        onBackgroundImageError: (_, __) {},
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const MyCard(
                title: "Bayu Nikah",
                subtitle: "Besok",
              ),
              const SizedBox(height: 15),
              _buildNav(context),
              const SizedBox(height: 15),
              const MyText(
                "Your Activities",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildActivity(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final navTitle = ref.watch(navTitleProvider);

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyButton1(
            isTapped: navTitle == 'All',
            text: "All",
            onPressed: () {
              _handleNavChange("All");
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(categoryNotifierProvider);

                if (state.isLoading) {
                  return const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)));
                }

                if (state.categoryourites == null ||
                    state.categoryourites!.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categoryourites!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final categoryourite = state.categoryourites![index];
                    final currentNavTitle = ref.watch(navTitleProvider);
                    return MyButton1(
                      text: categoryourite.id,
                      isTapped: currentNavTitle == categoryourite.id,
                      onPressed: () {
                        _handleNavChange(categoryourite.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: cs.surface,
              ),
              child: Icon(Icons.add, color: cs.onSurface, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity(BuildContext context) {
    final noteState = ref.watch(noteNotifierProvider);
    final categoryState = ref.watch(categoryNotifierProvider);
    final navTitle = ref.watch(navTitleProvider);

    if (noteState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allNotes = noteState.notes;
    final categoryNoteIds = categoryState.categoryourite?.noteId;

    if (allNotes == null || allNotes.isEmpty) {
      return const Center(
        child: MyText(
          "Belum ada catatan",
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

    final filteredNotes = (navTitle == "All")
        ? allNotes
        : allNotes
            .where((note) => categoryNoteIds?.contains(note.id) ?? false)
            .toList();

    if (filteredNotes.isEmpty) {
      return const Center(
        child: MyText(
          "Belum ada catatan untuk kategori ini",
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotes.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              if (widget.userData.id.isNotEmpty && note.id.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Note(
                      creatorId: widget.userData.id,
                      noteId: note.id,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          "Cannot open note. Missing required information.")),
                );
              }
            },
            child: MyCard(
              title: note.title,
              subtitle: _scheduleStatus(note.schedule),
            ),
          ),
        );
      },
    );
  }

  String _scheduleStatus(DateTime? schedule) {
    if (schedule == null) {
      return "Tidak ada jadwal";
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDay = DateTime(schedule.year, schedule.month, schedule.day);

    final difference = scheduledDay.difference(today).inDays;

    if (difference == 0) {
      return "Hari ini";
    } else if (difference == 1) {
      return "Besok";
    } else if (difference > 1) {
      return "$difference hari lagi";
    } else if (difference < 0) {
      return "Sudah lewat";
    } else {
      return "Jadwal tidak valid";
    }
  }
}
