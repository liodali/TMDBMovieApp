import 'package:flutter/material.dart';

class MovieInformation extends StatelessWidget {
  final Widget icon;
  final String? information;
  final Widget? informationWidget;

  const MovieInformation({
    super.key,
    required this.icon,
    this.information,
    this.informationWidget,
  }) : assert(information != null || informationWidget != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: icon,
        ),
        if (information != null) ...[
          Text(information!),
        ] else if (informationWidget != null)
          informationWidget!,
      ],
    );
  }
}
