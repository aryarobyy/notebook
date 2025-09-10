import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/button/button1.dart';
import 'package:to_do_list/component/widget/card/note_card.dart';
import 'package:to_do_list/component/util/text.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/note/note.dart';
import 'package:flutter_riverpod/legacy.dart';

final selectedNoteTitleProvider = StateProvider<String?>((ref) => null);

class Activity extends ConsumerStatefulWidget {
  final UserModel userData;
  final String navTitle;
  final List<NoteModel>?notes;
  final CategoryModel? category;
  const Activity({
    required this.userData,
    required this.navTitle,
    required this.notes,
    required this.category,
    super.key,
  });

  @override
  ConsumerState<Activity> createState() => _ActivityState();
}

class _ActivityState extends ConsumerState<Activity> {
  final TextEditingController _dropDownController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String currentNavTitle = widget.navTitle;

    if (widget.notes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final allNotes = widget.notes;
    final categoryNoteIds = widget.category?.noteId;

    if (allNotes == null || allNotes.isEmpty) {
      return const Center(
        child: MyText(
          "Belum ada catatan",
          fontSize: 16,
          color: Colors.grey,
        ),
      );
    }

    final filteredNotes = (currentNavTitle == "All")
        ? allNotes
        : allNotes
        .where((note) => categoryNoteIds?.contains(note.id) ?? false)
        .toList();

    if (filteredNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(
              "Belum ada catatan untuk kategori ini",
              fontSize: 16,
              color: Colors.grey,
            ),
            SizedBox(height: 40,),
            MyButton1(
              variant: ButtonVariant.secondary,
              height: 50,
              // width: 200,
              text: "Tambahkan Note",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildAddAct(context);
                  }
                );
              },
            )
          ],
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
          child: NoteCard(
            title: note.title,
            subtitle: _scheduleStatus(note.schedule),
            onTap: (widget.userData.id.isNotEmpty && note.id.isNotEmpty)
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Note(
                    creatorId: widget.userData.id,
                    noteId: note.id,
                  ),
                ),
              );
            }
                : null,
          ),
        );
      },
    );
  }

  Widget _buildAddAct(BuildContext context) {
    final List<NoteModel> allNotesForDropdown = ref.watch(noteNotifierProvider).notes ?? [];
    final String? selectedTitle = ref.watch(selectedNoteTitleProvider);
    final NoteModel selectedNote = allNotesForDropdown.firstWhere(
          (note) => note.id == selectedTitle,
      orElse: () => allNotesForDropdown.isNotEmpty ? allNotesForDropdown.first : NoteModel(
        id: '',
        creatorId: '',
        title: '',
        content: '',
        createdAt: DateTime.timestamp(),
        tag: [],
        status: NoteStatus.UNACTIVE,
      ),
    );
    if (selectedTitle != null && selectedNote != null && _dropDownController.text != selectedNote.title) {
      _dropDownController.text = selectedNote.title;
    }

    return AlertDialog(
      content: Container(
        width: 300,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText("Pilih Note", fontSize: 18, fontWeight: FontWeight.bold,),
                Spacer(),
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel)
                )
              ],
            ),
            const SizedBox(height: 20),
            if (allNotesForDropdown.isEmpty)
              const MyText("Tidak ada catatan untuk dipilih.", color: Colors.grey)
            else
              DropdownMenu<String>(
                width: 260,
                controller: _dropDownController,
                initialSelection: selectedTitle,
                hintText: "Pilih Notemu",
                onSelected: (String? value) {
                  ref.read(selectedNoteTitleProvider.notifier).state = value;
                  print('Selected Note ID: $value');
                },
                dropdownMenuEntries: allNotesForDropdown.map<DropdownMenuEntry<String>>(
                      (NoteModel note) {
                    return DropdownMenuEntry<String>(
                      value: note.id,
                      label: note.title,
                    );
                  },
                ).toList(),
              ),
            MyButton1(
              text: "Simpan",
              onPressed: () {

              }
            )
          ],
        ),
      ),
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
