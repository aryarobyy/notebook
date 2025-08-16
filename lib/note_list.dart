import 'package:flutter/material.dart';
import 'package:to_do_list/component/note_card.dart';
import 'package:to_do_list/models/index.dart';

class NoteList extends StatelessWidget {
  final List<NoteModel> notes;
  final void Function(NoteModel note)? onNoteTap;

  const NoteList({
    super.key,
    required this.notes,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada catatan",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: notes.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: NoteCard(
              title: note.title,
              subtitle: _scheduleStatus(note.schedule),
              onTap: () => onNoteTap?.call(note),
            ),
          );
        },
      ),
    );
  }

  String _scheduleStatus(DateTime? schedule) {
    if (schedule == null) return "Tidak ada jadwal";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scheduledDay = DateTime(schedule.year, schedule.month, schedule.day);
    final difference = scheduledDay.difference(today).inDays;

    if (difference == 0) return "Hari ini";
    if (difference == 1) return "Besok";
    if (difference > 1) return "$difference hari lagi";
    if (difference < 0) return "Sudah lewat";

    return "Jadwal tidak valid";
  }
}
