import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useInitState(Function onInit) {
  return use(_InitStateHook(onInit: onInit));
}
class _InitStateHook extends Hook<void> {
  final Function onInit;

  const _InitStateHook({required this.onInit});
  @override
  HookState<void, Hook<void>> createState() => __InitStateHookState();
}

class __InitStateHookState extends HookState<void, _InitStateHook> {
  @override
  void initHook() {
    hook.onInit();
    super.initHook();
  }

  @override
  void build(BuildContext context) {
    return;
  }
}
