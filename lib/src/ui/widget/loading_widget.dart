import 'package:flutter/material.dart';
import '../../common/app_localization.dart';

class LoadingWidget extends StatelessWidget {
  final String? loadingText;
  final bool showWithoutText;
  final EdgeInsetsGeometry padding;
  const LoadingWidget({
    super.key,
    this.loadingText,
    this.showWithoutText = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: showWithoutText
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    loadingText ?? MyAppLocalizations.of(context)!.loadingText,
                  )
                ],
              ),
      ),
    );
  }
}

class SimpleLoadingWidget extends StatelessWidget {
  const SimpleLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
