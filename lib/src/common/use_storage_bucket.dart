import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

PageStorageBucket usePageStorageBucket() {
  return use(const _PageStorageBucketHook());
}

class _PageStorageBucketHook extends Hook<PageStorageBucket> {
  const _PageStorageBucketHook();
  @override
  HookState<PageStorageBucket, Hook<PageStorageBucket>> createState() =>
      _PageStorageBucketState();
}

class _PageStorageBucketState
    extends HookState<PageStorageBucket, _PageStorageBucketHook> {
  late final PageStorageBucket _bucket;
  @override
  void initHook() {
    super.initHook();
    _bucket = PageStorageBucket();
  }

  @override
  PageStorageBucket build(BuildContext context) {
    return _bucket;
  }
}
