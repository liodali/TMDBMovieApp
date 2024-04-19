import 'package:flutter/material.dart';

class BadgeMovie extends StatelessWidget {
  final double elevation;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;
  final Widget? icon;
  final Widget title;

  const BadgeMovie({
    super.key,
    this.elevation = 0.0,
    this.color,
    this.padding,
    this.shape,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 12,
          ),
      labelPadding: EdgeInsets.zero,
      avatar: icon,
      label: title,
    );
  }
}
