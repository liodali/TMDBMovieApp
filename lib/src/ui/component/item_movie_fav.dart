import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/ui/widget/app_hero.dart';
import 'package:movie_app/src/ui/widget/movie_image.dart';
import 'package:movie_app/src/ui/widget/note_movie.dart';
import 'package:movie_app/src/ui/widget/search_text_coloration.dart';



class ItemMovieFav extends StatelessWidget {
  final Movie movie;
  final String? titleSearchToColor;
  final Widget Function(Movie) actionMovie;

  const ItemMovieFav({
    super.key,
    required this.movie,
    required this.actionMovie,
    this.titleSearchToColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AppHero(
                  tag: movie.id.toString(),
                  child: MovieImage(
                    url: "w780${movie.poster}",
                    size: const Size(84, 128),
                    fit: BoxFit.fill,
                    errorWidget: const Icon(
                      Icons.movie,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FavoriteMovieBodyTileWidget(
                  movie: movie,
                  titleSearchToColor: titleSearchToColor,
                ),
              ),
              actionMovie(movie),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteMovieBodyTileWidget extends StatelessWidget {
  final Movie movie;
  final String? titleSearchToColor;
  const FavoriteMovieBodyTileWidget({
    super.key,
    required this.movie,
    this.titleSearchToColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListTile(
          title: AppHero(
            tag: "${movie.title}_${movie.id}",
            child: titleSearchToColor != null && titleSearchToColor!.isNotEmpty
                ? SearchTextColoration(
                    movie: movie,
                    titleSearchToColor: titleSearchToColor!,
                  )
                : AutoSizeText(
                    movie.title,
                    minFontSize: 16,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                        ),
                  ),
          ),
          subtitle: AutoSizeText(movie.releaseDate ?? ""),
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 2,
          isThreeLine: false,
        ),
        AppHero(
          tag: "${movie.vote * movie.voteCount * movie.id}",
          child: NoteMovie(
            note: movie.vote,
            votes: movie.voteCount,
            elevation: 3,
            marginBadgeVote: const EdgeInsets.only(right: 3),
          ),
        ),
      ],
    );
  }
}
