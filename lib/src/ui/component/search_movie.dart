import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/common/use_init.dart';
import 'package:movie_app/src/ui/component/item_movie_fav.dart';
import 'package:movie_app/src/ui/widget/stream_component.dart';
import 'package:movie_app/src/viewmodel/favorite_movie_view_model.dart';
import 'package:movie_app/src/viewmodel/search_movie_view_model.dart';

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return IconButton(
        onPressed: () {
          ref.invalidate(searchMovieProvier);
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
        ),
      );
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        useEffect(() {
          final searchVM = ref.read(searchMovieProvier.notifier);
          if (query != searchVM.query) {
            searchVM.setQuery(query);
          }
          searchVM.update();
          return;
        }, [query]);
        return const SearchMovieResult();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class SearchMovieResult extends HookConsumerWidget {
  const SearchMovieResult({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final searchVM = ref.read(searchMovieProvier.notifier);

    if (searchVM.isQueryEmpty) {
      return const SizedBox.shrink();
    }

    return StreamComponent<List<Movie>>(
      stream: searchVM.stream,
      builder: (movies) {
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () async {
                await context.navigate(
                  AppRouter.detailMovieNamePage,
                  arguments: movies[index],
                );
              },
              child: ItemMovieFav(
                titleSearchToColor: searchVM.query,
                actionMovie: (movie) => IconFavWidget(
                  movie: movie,
                ),
                movie: movies[index],
              ),
            );
          },
        );
      },
    );
  }
}

class IconFavWidget extends HookConsumerWidget {
  final Movie movie;
  const IconFavWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateFav = useState(false);
    useInitState(() {
      Future.delayed(Duration.zero, () async {
        stateFav.value = await ref
            .read(favoriteMoviesProvider.notifier)
            .checkMovieInFavorite(movie.id);
      });
    });
    return Icon(
      stateFav.value ? Icons.bookmark : Icons.bookmark_border,
      color: stateFav.value ? Colors.amber : null,
      size: 24,
    );
  }
}
