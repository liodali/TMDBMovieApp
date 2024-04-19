import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/src/common/app_localization.dart';

class MovieImage extends StatelessWidget {
  final String url;
  final Size? size;
  final BoxFit? fit;
  final Widget? errorWidget;
  final BorderRadius borderRadius;

  const MovieImage({
    super.key,
    required this.url,
    this.size,
    this.fit,
    this.errorWidget,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(12),
    ),
  });

  @override
  Widget build(BuildContext context) {
    final server = dotenv.env['IMAGE_URL']!;
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: "$server/$url",
        maxHeightDiskCache: 100,
        maxWidthDiskCache: 100,
        height: size?.height,
        width: size?.width,
        useOldImageOnUrlChange: true,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        filterQuality: FilterQuality.medium,
        fit: fit,
        errorWidget: (context, _, __) {
          return Center(
            child: errorWidget ??
                Text(
                  MyAppLocalizations.of(context)!.errorLoadImage,
                ),
          );
        },
      ),
    );
  }
}
