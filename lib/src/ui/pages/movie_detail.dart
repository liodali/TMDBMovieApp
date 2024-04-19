import 'package:data_package/data_package.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:movie_app/src/common/app_localization.dart';
import 'package:movie_app/src/common/routes.dart';
import 'package:movie_app/src/model/i_state.dart';
import 'package:movie_app/src/ui/component/more_information_movie.dart';
import 'package:movie_app/src/ui/component/overview_detail_movie.dart';
import 'package:movie_app/src/ui/widget/action_dialog.dart';
import 'package:movie_app/src/ui/widget/flexible_movie_detail.dart';
import 'package:movie_app/src/viewmodel/detail_movie_view_model.dart';

class MovieDetail extends StatelessWidget {
  final Movie movie;

  const MovieDetail({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        selectedMovieProvider.overrideWith((ref) => movie),
      ],
      child: const MovieDetailCore(),
    );
  }
}

class MovieDetailCore extends ConsumerWidget {
  const MovieDetailCore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(detailMovieProvider.notifier);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(
                  right: 8,
                  top: 5,
                  bottom: 5,
                ),
                child: FavoriteButtonAction(),
              ),
            ],
            pinned: true,
            flexibleSpace: const FlexibleAppBarMovieDetail(),
            expandedHeight: 256,
            //backgroundColor: Colors.transparent,
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: true,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        MoreInformationMovie(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: OverviewDetailMovie(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButtonAction extends ConsumerWidget {
  const FavoriteButtonAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final localization = MyAppLocalizations.of(context);
        final scafoldMessenger = ScaffoldMessenger.of(context);
        final detailVM = ref.read(detailMovieProvider.notifier);

        int response = await showDialog(
          context: context,
          builder: (context) {
            return ActionDialog(
              action: () async {
                final navigate = Navigator.of(context);
                int response = 0;
                if (!detailVM.isFav) {
                  response = await detailVM.addToFavorite();
                } else {
                  response = await detailVM.removeFromFavorite();
                }
                navigate.pop(response);
              },
            );
          },
        );
        var message = "";
        switch (response) {
          case 200:
            message = detailVM.isFav
                ? localization!.successRemoveFromFav
                : localization!.successAddToFav;
            break;
          case 400:
            message = detailVM.isFav
                ? localization!.failedToRemoveFromFav
                : localization!.failedToAddToFav;

            break;
        }

        scafoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
        detailVM.setIsFav(!detailVM.isFav);
      },
      iconSize: 24,
      icon: const IconFavoritDetailMovie(),
    );
  }
}

class IconFavoritDetailMovie extends ConsumerWidget {
  const IconFavoritDetailMovie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      detailMovieProvider.select(
        (state) => state is DetailMovieState ? state.isFavorit : false,
      ),
    );
    return Icon(
      isFav ? Icons.bookmark : Icons.bookmark_border,
      color: isFav ? Colors.amber : null,
      size: 24,
    );
  }
}
