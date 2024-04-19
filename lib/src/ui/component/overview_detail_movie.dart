import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';

class OverviewDetailMovie extends ConsumerWidget {
  const OverviewDetailMovie({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    String? overview = ref.read(selectedMovieProvider)!.overview;
    return Text.rich(
      TextSpan(
        text: "Overview\n\n",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                ) ??
            const TextStyle(
              fontSize: 18,
            ),
        children: [
          TextSpan(
            text: overview,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
