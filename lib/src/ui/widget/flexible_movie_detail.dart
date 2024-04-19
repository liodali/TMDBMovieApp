import 'dart:ui';

import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/ui/widget/app_hero.dart';
import 'package:movie_app/src/ui/widget/movie_image.dart';
import 'package:movie_app/src/ui/widget/note_movie.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';

const maxPaddingLeft = 120.0;
const minPaddingLeft = 48.0;
const maxPaddingBottom = 42.0;
const minPaddingBottom = 4.0;
const maxFontSizeText = 16.0;
const minFontSizeText = 13.0;
const maxHeight = 315.0;

class FlexibleAppBarMovieDetail extends HookConsumerWidget {
  const FlexibleAppBarMovieDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.read(selectedMovieProvider)!;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final currentMaxHeight = constraints.maxHeight;
        final factor = currentMaxHeight / maxHeight;
        final paddingLeft =
            lerpDouble(minPaddingLeft, maxPaddingLeft, factor) ??
                maxPaddingLeft;
        final paddingBottom =
            lerpDouble(minPaddingBottom, maxPaddingBottom, factor) ??
                maxPaddingBottom;
        final fontSizeText =
            lerpDouble(minFontSizeText, maxFontSizeText, factor) ??
                maxFontSizeText;
        return FlexibleSpaceBar(
          background: MovieDetailBody(
            movie: movie,
          ),
          title: AppHero(
            tag: "${movie.title}_${movie.id}",
            child: Text(
              movie.title,
              style: TextStyle(
                fontSize: fontSizeText,
              ),
              maxLines: paddingLeft == minPaddingLeft ? 1 : 2,
            ),
          ),
          titlePadding: EdgeInsets.only(
            left: paddingLeft.toDouble(),
            bottom: paddingBottom.toDouble(),
            right: 5,
          ),
          centerTitle: false,
        );
      },
    );
  }
}

class MovieDetailBody extends StatelessWidget {
  final Movie movie;
  const MovieDetailBody({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (movie.backdrop != null) ...[
          MovieImage(
            url: "w780${movie.backdrop!}",
            size: Size(MediaQuery.of(context).size.width, 256),
            fit: BoxFit.fill,
            borderRadius: BorderRadius.zero,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(1)
                ],
                stops: const [0.2, 0.8],
              ),
            ),
          ),
        ],
        Positioned(
          height: 136,
          bottom: 12,
          left: 12,
          width: 96,
          child: AppHero(
            tag: movie.id.toString(),
            child: MovieImage(
              url: "w780${movie.poster!}",
              size: const Size.fromHeight(136),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 120,
          child: AppHero(
            tag: "${movie.vote * movie.voteCount * movie.id}",
            child: SizedBox(
              child: NoteMovie(
                note: movie.vote,
                votes: context.mounted ? movie.voteCount : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
