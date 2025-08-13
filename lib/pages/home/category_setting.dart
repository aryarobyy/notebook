import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/component/categories_card.dart';
import 'package:to_do_list/component/widget/header.dart';
import 'package:to_do_list/models/category_model.dart';
import 'package:to_do_list/models/index.dart';
import 'package:to_do_list/notifiers/category_notifier.dart';
import 'package:to_do_list/pages/dashboard.dart';

class CategorySetting extends ConsumerStatefulWidget {
  final List<CategoryModel>? categories;
  final UserModel userData;
  const CategorySetting({
    this.categories,
    required this.userData,
    super.key,
  });

  @override
  ConsumerState<CategorySetting> createState() => _CategorySettingState();
}

class _CategorySettingState extends ConsumerState<CategorySetting> {
  @override
  void initState() {
    super.initState();
    if (widget.categories == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyHeader(
              title: 'Favourite Notebook',
              onBackPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Dashboard()));
              },
            ),
            _buildCategories(context,ref)
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoryNotifierProvider);

    if (state.categories == null || state.categories!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text("No categories"),
      );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.categories!.length,
        itemBuilder: (BuildContext context, int index) {
          final category = state.categories![index];

          return CategoriesCard(
            userData: widget.userData,
            category: category,
          );
        },
      ),
    );
  }
}