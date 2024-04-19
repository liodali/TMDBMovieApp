import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/common/use_init.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/ui/component/movies_favorites.dart';
import 'package:movie_app/src/ui/widget/empty_list.dart';
import 'package:movie_app/src/ui/widget/loading_widget.dart';
import 'package:movie_app/src/viewmodel/favorite_movie_view_model.dart';

class FavoriteMovieList extends HookConsumerWidget {
  const FavoriteMovieList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    useInitState(() {
      Future.microtask(() {
        ref.read(favoriteMoviesProvider.notifier).getMovieFavoriteList();
      });
    });
    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  if (ref.read(favoriteMoviesToDelete).isNotEmpty) {
                    ref.read(canDeleteMovies.notifier).state = true;
                  }
                  ScaffoldMessenger.of(context).clearSnackBars();
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(
                MyAppLocalizations.of(context)!.favMovieTitle,
              ),
            ),
            const MoviesFavorite(),
          ],
        ),
      ),
    );
  }
}

class MoviesFavorite extends ConsumerWidget {
  const MoviesFavorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteMoviesProvider);
    return switch (state) {
      MovieState() => state.data.isEmpty
          ? SliverFillRemaining(
              child: EmptyList(
                messageEmptyList:
                    MyAppLocalizations.of(context)!.emptyListFavorite,
              ),
            )
          : MoviesFavorites(
              movies: state.data,
            ),
      LoadingState() => const SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: LoadingWidget(),
        ),
      ErrorState() || _ => const SliverFillRemaining(
          fillOverscroll: false,
          hasScrollBody: false,
          child: Center(
            child: Text("Error!"),
          ),
        ),
    };
  }
}
