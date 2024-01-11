import 'package:flutter/material.dart';

///组件的装饰器
abstract class FastDecorate {
  ///组件解析方式
  Widget build(BuildContext context, Widget child);
}

extension FastDecorateExt on List<FastDecorate>? {
  Widget applyAfterBuild(BuildContext context, Widget widget) {
    Widget result = widget;
    if (this != null) {
      for (var value in this!) {
        result = value.build(context, result);
      }
    }
    return result;
  }
}
