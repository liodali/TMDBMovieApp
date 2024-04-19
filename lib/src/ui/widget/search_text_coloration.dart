import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/ui/widget/text_coloration_by_search.dart';

class SearchTextColoration extends StatelessWidget {
  final Movie movie;
  final String titleSearchToColor;

  const SearchTextColoration({
    super.key,
    required this.movie,
    required this.titleSearchToColor,
  });

  @override
  Widget build(BuildContext context) {
    return TilteColorationWidget(
      title: movie.title,
      textToColor: titleSearchToColor,
      textColor: Theme.of(context).colorScheme.error,
      defaultTextStyleColor: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onBackground,
          ),
      maxlines: 2,
      size: const Size.fromHeight(56),
    );
  }
}