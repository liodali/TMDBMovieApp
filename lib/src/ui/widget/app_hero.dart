import 'package:flutter/material.dart';

class AppHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const AppHero({
    super.key,
    required this.tag,
    required this.child,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
