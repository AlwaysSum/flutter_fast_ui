import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';

///组件的装饰器
abstract class FastDecorate {
  ///组件解析方式
  Widget build(BuildContext context, Widget child);
}

///构建器
abstract class FastDecorateBuilder
    implements FastConfigParserBuilder<FastDecorate> {
  @override
  FastDecorate? Function(BuildContext context, FastUIConfig config)
      get builder => buildDecorate;

  FastDecorate? buildDecorate(BuildContext context, FastUIConfig config);
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
