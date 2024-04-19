import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/ui/component/item_movie_fav.dart';
import 'package:movie_app/src/ui/widget/empty_list.dart';
import 'package:movie_app/src/viewmodel/favorite_movie_view_model.dart';

class MoviesFavorites extends HookWidget {
  final List<Movie> movies;

  const MoviesFavorites({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final moviesState = useState(movies);
    if (moviesState.value.isEmpty) {
      return EmptyList(
        messageEmptyList: MyAppLocalizations.of(context)!.emptyListFavorite,
      );
    }
    //final animatedKey = useMemoized(() => GlobalKey<SliverAnimatedListState>());
    return SliverAnimatedList(
      initialItemCount: moviesState.value.length,
      itemBuilder: (ctx, index, animation) {
        return FadeTransition(
          opacity: animation,
          child: AnimatedMovieFavorite(
            index: index,
            movie: moviesState.value[index],
            removeItemFromList: (movie) => moviesState.value.remove(movie),
            resetItem: (index, movie) {
              moviesState.value.insert(index, movie);
            },
          ),
        );
      },
    );
  }
}

class AnimatedMovieFavorite extends HookConsumerWidget {
  final int index;
  final Movie movie;
  final bool Function(Movie) removeItemFromList;
  final Function(int, Movie) resetItem;
  const AnimatedMovieFavorite({
    super.key,
    required this.index,
    required this.movie,
    required this.removeItemFromList,
    required this.resetItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final stateAnimatedList = SliverAnimatedList.of(context);
        await context.navigate(
          AppRouter.detailMovieNamePage,
          arguments: movie,
        );
        bool isFav = await ref
            .read(favoriteMoviesProvider.notifier)
            .checkMovieInFavorite(movie.id);
        if (!isFav) {
          final isRemoved = removeItemFromList(movie);
          Movie? removed = isRemoved ? movie : null;
          if (removed != null) {
            stateAnimatedList.removeItem(
              index,
              (context, animation) => FadeTransition(
                opacity: animation,
                child: ItemMovieFav(
                  movie: removed,
                  actionMovie: (_) => const SizedBox.shrink(),
                ),
              ),
            );
          }
        }
      },
      child: ItemMovieFav(
        actionMovie: (movie) {
          return DeleteFavIconButton(
            index: index,
            movie: movie,
            removeItemFromList: removeItemFromList,
            resetItem: resetItem,
          );
        },
        movie: movie,
      ),
    );
  }
}

class DeleteFavIconButton extends HookConsumerWidget {
  final int index;
  final Movie movie;
  final bool Function(Movie) removeItemFromList;
  final Function(int, Movie) resetItem;
  const DeleteFavIconButton({
    super.key,
    required this.index,
    required this.movie,
    required this.removeItemFromList,
    required this.resetItem,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int?> previousMovie = useState(null);
    ValueNotifier<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?>
        snackBarController = useState(null);
    return IconButton(
      onPressed: () async {
        final sliverAnimatedList = SliverAnimatedList.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final localisation = MyAppLocalizations.of(context);
        final listToDelete = ref.read(favoriteMoviesToDelete);
         final favoriesToDeleteVM = ref.read(favoriteMoviesToDelete.notifier);
        //remove already the movie that removed from the list
        if (snackBarController.value != null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          if (previousMovie.value != null) {
            listToDelete.remove(previousMovie.value);
            favoriesToDeleteVM.state = listToDelete;
            await ref
                .read(favoriteMoviesProvider.notifier)
                .removeMovieFromFavoriteList(previousMovie.value!);
          }
        }
        // add the movie id to fav list that will be removed
        listToDelete.add(movie.id);
        favoriesToDeleteVM.state = listToDelete;
        final isRemoved = removeItemFromList(movie);
        Movie? removed = isRemoved ? movie : null;
        sliverAnimatedList.removeItem(
          index,
          (context, animation) => FadeTransition(
            opacity: animation,
            child: ItemMovieFav(
              movie: removed!,
              actionMovie: (_) => const SizedBox.shrink(),
            ),
          ),
        );
        previousMovie.value = removed?.id;
       
        snackBarController.value = scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              "${removed?.title} ${localisation!.successRemoveFromFavMod}",
            ),
            action: SnackBarAction(
              onPressed: () {
                listToDelete.remove(previousMovie.value);
                favoriesToDeleteVM.state = listToDelete;
                resetItem(index, movie);
                sliverAnimatedList.insertItem(index);
                scaffoldMessenger.hideCurrentSnackBar();
                removed = null;
                previousMovie.value = null;
              },
              label: "UNDO",
            ),
          ),
        );
        snackBarController.value!.closed.then((value) async {
          if (removed != null) {
            if (context.mounted) {
              removed = null;
              previousMovie.value = null;
              snackBarController.value = null;
            }
          }
        });
      },
      icon: const Icon(Icons.delete),
    );
  }
}
