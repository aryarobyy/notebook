import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/card/note_card.dart';
import 'package:to_do_list/component/util/text.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';

class CategoriesCard extends ConsumerWidget {
  final UserModel userData;
  final CategoryModel category;

  const CategoriesCard({
    super.key,
    required this.userData,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryNotifierProvider);
    final cs = Theme.of(context).colorScheme;
    final noteId = category.noteId?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _buildPopup(
            context,
            category.title,
            category.noteId,
            state.isLoading,
            ref,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                category.title,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              const SizedBox(height: 4),
              MyText(
                '$noteId NoteBook',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _buildPopup(
      BuildContext context,
      String title,
      List<dynamic>? items,
      bool isLoading,
      WidgetRef ref,
      ) async {
    final noteNotifier = ref.read(noteNotifierProvider.notifier);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading notes..."),
              ],
            ),
          ),
        ),
      ),
    );

    List<NoteModel> notesData = [];

    if (items != null && items.isNotEmpty) {
      for (var noteId in items) {
        try {
          final note = await noteNotifier.noteById(userData.id, noteId);
          notesData.add(note);
        } catch (e) {
          print('Error fetching note $noteId: $e');
        }
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: notesData.isEmpty
                  ? const Text("No data available")
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: notesData.length,
                itemBuilder: (context, index) {
                  final note = notesData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NoteCard(
                      title: note.title,
                      subtitle: _scheduleStatus(note.schedule),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    }
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