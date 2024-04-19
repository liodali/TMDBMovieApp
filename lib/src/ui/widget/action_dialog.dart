import 'package:flutter/material.dart';
import 'package:movie_app/src/ui/widget/loading_widget.dart';

class ActionDialog extends StatefulWidget {
  final Function() action;

  const ActionDialog({
    super.key,
    required this.action,
  });

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      widget.action();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: SizedBox(
        height: 128,
        child: LoadingWidget(),
      ),
    );
  }
}
