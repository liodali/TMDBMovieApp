import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'loading_widget.dart';

typedef AppBuilder<T> = Widget Function(T data);

class StreamComponent<T> extends StatelessWidget {
  final AppBuilder<T> builder;
  final Widget? errorWidget;
  final Widget? loading;
  final Stream<T> stream;
  final String? streamKey;

  const StreamComponent({
    super.key,
    this.streamKey,
    required this.builder,
    this.errorWidget,
    this.loading,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (ctx) {
      final hook = useMemoized(() => stream, [streamKey]);
      final snap = useStream(hook, preserveState: true);
      if (snap.connectionState == ConnectionState.waiting) {
        return this.loading ?? const LoadingWidget();
      } else if (snap.connectionState == ConnectionState.active ||
          snap.connectionState == ConnectionState.done) {
        if (snap.hasData) {
          return builder(snap.data as T);
        }
      }
      return this.errorWidget ?? const Text("Opps!Error");
    });
  }
}
