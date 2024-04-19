import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/ui/widget/app_hero.dart';
import 'package:movie_app/src/ui/widget/movie_image.dart';
import 'package:movie_app/src/ui/widget/note_movie.dart';

class ItemMovie extends StatelessWidget {
  final Movie movie;
  const ItemMovie({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196,
      child: Card(
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (movie.poster != null) ...[
                Positioned.fill(
                  child: AppHero(
                    tag: movie.id.toString(),
                    child: MovieImage(
                      url: "w780${movie.poster!}",
                      size: const Size.fromHeight(196),
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: FilterTitleImageWidget(),
                )
              ],
              Positioned(
                bottom: 8,
                left: 3,
                right: 3,
                child: TitleRateWidget(
                  movie: movie,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TitleRateWidget extends StatelessWidget {
  final Movie movie;
  const TitleRateWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHero(
          tag: "${movie.title}_${movie.id}",
          child: AutoSizeText(
            movie.title,
            maxLines: 1,
            minFontSize: 11,
            maxFontSize: 18,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppHero(
          tag: "${movie.vote * movie.voteCount * movie.id}",
          child: NoteMovie(
            note: movie.vote,
          ),
        ),
      ],
    );
  }
}

class FilterTitleImageWidget extends StatelessWidget {
  const FilterTitleImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0.6),
          ],
          stops: const [0.3, 0.8],
        ),
      ),
    );
  }
}
