import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/use_storage_bucket.dart';
import 'package:movie_app/src/ui/component/search_movie.dart';
import 'package:movie_app/src/ui/widget/search_text_movie.dart';
import 'package:movie_app/src/ui/widget/tab_movies_types.dart';

import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/viewmodel/commons.dart';
import 'package:movie_app/src/viewmodel/favorite_movie_view_model.dart';
import 'package:movie_app/src/viewmodel/movies_view_model.dart';
import 'package:movie_app/src/ui/component/list_movies.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(canDeleteMovies, (prev, next) {
      if ((prev != null || !prev!) && next) {
        if (ref.read(favoriteMoviesToDelete).isNotEmpty) {
          final ids = ref.read(favoriteMoviesToDelete);
          Future.microtask(() async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .removeMoviesFromFavorite(ids);
            ref.read(canDeleteMovies.notifier).state = false;
            ref.read(favoriteMoviesToDelete.notifier).state = [];
          });
        }
      }
    });
    final tabViewController =
        useTabController(initialLength: CategoryMovies.values.length);

    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final selectedCategory = ref.read(selectedCategoryProvider);
          final maxScroll = notification.metrics.maxScrollExtent;
          final currentScroll = notification.metrics.pixels;
          final isLoading =
              ref.read(moviesProvider(selectedCategory).notifier).isLoading;
          if (currentScroll > (maxScroll * 0.75) &&
              notification.direction == ScrollDirection.reverse &&
              !isLoading) {
            Future.microtask(
              ref.read(moviesProvider(selectedCategory).notifier).getMovies,
            );
          }
          return true;
        },
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            HomeSliverAppBar(
              tabController: tabViewController,
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: true,
                child: TabBarViewMovies(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSliverAppBar extends HookWidget {
  final TabController tabController;
  const HomeSliverAppBar({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    return SliverAppBar(
      title: SearchTextMovie(
        textController: textController,
        hint: MyAppLocalizations.of(context)!.searchHint,
        onTap: () async {
          final focusScope = FocusScope.of(context);
          await showSearch(context: context, delegate: SearchMovieDelegate());
          focusScope.unfocus();
          focusScope.requestFocus(FocusNode());
        },
      ),
      pinned: true,
      floating: false,
      forceElevated: true,
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          child: ElevatedButton(
            onPressed: () async {
              await context.navigate(AppRouter.favoriteMoviesNamePage);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: TabMoviesTypes(
          onSelectedCategory: (category) {
            tabController.animateTo(category.index);
          },
        ),
      ),
    );
  }
}

class TabBarViewMovies extends HookConsumerWidget {
  const TabBarViewMovies({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucketStorage = usePageStorageBucket();
    final category = ref.watch(selectedCategoryProvider);
    return PageStorage(
      bucket: bucketStorage,
      child: BodyListMovies(
        key: PageStorageKey<String>(category.name),
        categoryMovie: category,
      ),
    );
  }
}
