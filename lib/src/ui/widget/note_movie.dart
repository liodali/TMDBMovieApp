import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/common/app_localization.dart';

class NoteMovie extends StatelessWidget {
  final double note;
  final int? votes;
  final double elevation;
  final EdgeInsetsGeometry? marginBadgeVote;
  const NoteMovie({
    super.key,
    required this.note,
    this.votes,
    this.elevation = 1,
    this.marginBadgeVote,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BadgeVoteAverage(
          note: note,
          elevation: elevation,
          margin: marginBadgeVote,
        ),
        if (votes != null) ...[
          Flexible(
            child: AutoSizeText(
              "($votes ${MyAppLocalizations.of(context)!.votes})",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
              ),
              minFontSize: 5,
              maxFontSize: 13,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ]
      ],
    );
  }
}

class BadgeVoteAverage extends StatelessWidget {
  final double note;
  final double elevation;
  final EdgeInsetsGeometry? margin;
  const BadgeVoteAverage({
    super.key,
    required this.note,
    this.elevation = 1,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      color: Colors.grey.shade300.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 16,
              color: Colors.amber,
            ),
            Text(
              note.toStringAsFixed(1),
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
