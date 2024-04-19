import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/model/movie_list_state.dart';
import 'package:movie_app/src/ui/component/item_movie.dart';
import 'package:movie_app/src/ui/widget/empty_list.dart';
import 'package:movie_app/src/ui/widget/loading_widget.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';
import 'package:movie_app/src/viewmodel/movies_view_model.dart';

class BodyListMovies extends ConsumerWidget {
  final CategoryMovies categoryMovie;
  const BodyListMovies({
    super.key,
    required this.categoryMovie,
  });

  @override
  Widget build(BuildContext context, ref) {
    final moviesState = ref.watch(moviesProvider(categoryMovie));
    return switch (moviesState) {
      MovieListState() => moviesState.movies.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 196,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          ref.read(selectedMovieProvider.notifier).state =
                              moviesState.movies[index];
                          await context.navigate(
                            AppRouter.detailMovieNamePage,
                            arguments: moviesState.movies[index],
                          );
                        },
                        child: ItemMovie(
                          movie: moviesState.movies[index],
                        ),
                      );
                    },
                    itemCount: moviesState.movies.length,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                  ),
                ),
                if (moviesState.isLoading) ...[
                  const SimpleLoadingWidget(),
                ],
              ],
            )
          : EmptyList(
              messageEmptyList: MyAppLocalizations.of(context)!.emptyList,
            ),
      LoadingState() => LoadingWidget(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          loadingText: MyAppLocalizations.of(context)!.moreMovies,
        ),
      ErrorState<StreamListState<Movie, String>>() => const Center(
          child: Center(
            child: Text("error!"),
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
