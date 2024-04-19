import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/viewmodel/commons.dart';

class TabMoviesTypes extends StatelessWidget {
  final Function(CategoryMovies) onSelectedCategory;

  const TabMoviesTypes({
    super.key,
    required this.onSelectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: CategoryMovies.values
          .map(
            (category) => TabItem(
              categoryMovies: category,
              onSelectedCategory: onSelectedCategory,
            ),
          )
          .toList(),
    );
  }
}

class TabItem extends ConsumerWidget {
  final CategoryMovies categoryMovies;
  final Function(CategoryMovies) onSelectedCategory;
  const TabItem({
    super.key,
    required this.categoryMovies,
    required this.onSelectedCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedCategoryProvider.notifier).state = categoryMovies;
          onSelectedCategory(categoryMovies);
        },
        child: Tab(
          child: Text(
            categoryMovies.name,
            style: TextStyle(
              fontSize: categoryMovies == selectedCategory ? 16 : 14,
              color: categoryMovies == selectedCategory
                  ? Colors.white
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
