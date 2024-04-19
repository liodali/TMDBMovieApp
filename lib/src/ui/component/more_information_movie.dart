import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/utilities.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/ui/widget/badge_movie.dart';
import 'package:movie_app/src/ui/widget/movie_information.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';

class MoreInformationMovie extends ConsumerWidget {
  const MoreInformationMovie({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final detailMovie = ref.watch(detailMovieProvider);
    return DetailMovieInformation(
      detailMovie:
          detailMovie is DetailMovieState ? detailMovie.detailMovie : null,
    );
  }
}

class DetailMovieInformation extends StatelessWidget {
  final DetailMovie? detailMovie;

  const DetailMovieInformation({super.key, required this.detailMovie});

  @override
  Widget build(BuildContext context) {
    final durationMovie = detailMovie != null &&
            detailMovie?.runtime != null &&
            detailMovie?.runtime != 0
        ? calculateDurationMovie(detailMovie!.runtime!)
        : "-";
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieInformation(
          icon: const Icon(Icons.access_time),
          information: durationMovie,
        ),
        const SizedBox(
          height: 5,
        ),
        MovieInformation(
          icon: const Icon(Icons.public),
          information: detailMovie?.originalLanguage?.toUpperCase() ?? "-",
        ),
        const SizedBox(
          height: 5,
        ),
        MovieInformation(
          icon: const Icon(Icons.local_movies),
          informationWidget: SizedBox(
            width: MediaQuery.of(context).size.width - 64,
            child: detailMovie != null
                ? Wrap(
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    spacing: 5.0,
                    children: detailMovie?.genres
                            .map((e) => e.name)
                            .map(
                              (e) => BadgeMovie(
                                elevation: 1,
                                color: Theme.of(context).dividerColor,
                                title: Text(e),
                              ),
                            )
                            .toList() ??
                        [],
                  )
                : const Text("-"),
          ),
        ),
      ],
    );
  }
}
