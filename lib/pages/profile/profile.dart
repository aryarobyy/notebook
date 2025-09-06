import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/widget/card/categories_card.dart';
import 'package:to_do_list/component/widget/layout/header.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/notifiers/note_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';

final noteLoadingProvider = StateProvider<bool>((ref) => false);

class ProfilePage extends ConsumerStatefulWidget {
  final UserModel userData;
  const ProfilePage({
    super.key,
    required this.userData,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        ref
          .read(noteNotifierProvider.notifier)
          .noteByCreator(widget.userData.id);
        ref
          .read(categoryNotifierProvider.notifier)
          .categoryByCreator(widget.userData.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final data = ref.watch(noteNotifierProvider);

    final totalTask = (data.notes?.length ?? 0).toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyHeader(
              title: widget.userData.username,
              onBackPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Dashboard()),
                );
              },
            ),
            SizedBox(height: 30),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: cs.primary.withOpacity(0.4),
                backgroundImage: widget.userData.image!.isNotEmpty
                    ? NetworkImage(widget.userData.image!)
                    : AssetImage("assets/bayu.jpg") as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                widget.userData.username,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Statistic",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: _buildStatCard(totalTask, "Total task"),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Note Category",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildCategories(context, ref),

          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    final catState = ref.watch(categoryNotifierProvider);
    final noteState = ref.watch(noteNotifierProvider);

    if (catState.categories == null || catState.categories!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text("No categories"),
      );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: catState.categories!.length,
        itemBuilder: (BuildContext context, int index) {
          final category = catState.categories![index];

          return CategoriesCard(userData: widget.userData, category: category);
        },
      ),
    );
  }
}
