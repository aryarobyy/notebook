import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/button1.dart';
import 'package:to_do_list/component/categories_card.dart';
import 'package:to_do_list/component/note_card.dart';
import 'package:to_do_list/component/size/size_config.dart';
import 'package:to_do_list/component/text.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/note_list.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/home/activity.dart';
import 'package:to_do_list/pages/home/category_setting.dart';
import 'package:to_do_list/pages/profile_page.dart';

final navLoadingProvider = StateProvider<bool>((ref) => false);
final navTitleProvider = StateProvider<String>((ref) => "All");
final loadingNavProvider = StateProvider<String?>((ref) => null);

class Home extends ConsumerStatefulWidget {
  final UserModel userData;
  const Home({super.key, required this.userData});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && widget.userData.id.isNotEmpty) {
        ref
          .read(categoryNotifierProvider.notifier)
          .categoryByCreator(widget.userData.id);
        await ref
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

  Future<void> _createCategory() async {
    final notifier = ref.read(categoryNotifierProvider.notifier);
    try{
      final data = await notifier.addCategory(creatorId: widget.userData.id, title: _categoryController.text);
      print("data sended $data");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final isNavLoading = ref.watch(navLoadingProvider);
    final noteState = ref.watch(noteNotifierProvider);
    final catState = ref.watch(categoryNotifierProvider);
    final navTitle = ref.watch(navTitleProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: isNavLoading == false && noteState.isLoading ?
      const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2)
          )
      ) :
      SafeArea(
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
                              ProfilePage(
                                userData: widget.userData,
                              ),
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
              const NoteCard(
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
              Expanded(
                child: Activity(
                  userData: widget.userData,
                  navTitle: navTitle,
                  notes: noteState.notes,
                  category: catState.category
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final navTitle = ref.watch(navTitleProvider);
    final state = ref.watch(categoryNotifierProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(navLoadingProvider.notifier).state = state.isLoading;
      }
    });

    if (state.categories == null ||
        state.categories!.isEmpty) {
      return const SizedBox.shrink();
    }

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
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = state.categories![index];
                    final currentNavTitle = ref.watch(navTitleProvider);
                    return MyButton1(
                      text: category.title,
                      isTapped: currentNavTitle == category.title,
                      onPressed: () {
                        _handleNavChange(category.title);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              print(state.categories);
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context){
              //     return _buildAddCat(context);
              //   }
              // );
              if (state.categories != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategorySetting(categories: state.categories, userData: widget.userData,)
                  )
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category tidak ditemukan')),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: cs.surface,
              ),
              child: Icon(Icons.settings, color: cs.onSurface, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCat (BuildContext context){
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      content: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
        ),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Add your category"),
                  Spacer(),
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel)
                  )
                ],
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _categoryController,
                style: TextStyle(
                  fontSize: 20
                ),
                decoration: InputDecoration(
                  labelText: "Kiriiik"
                ),
              ),
              SizedBox(height: 30,),
              MyButton1(
                text: "Create",
                onPressed: _createCategory
              )
            ],
          )
        ),
      ),
    );
  }
}