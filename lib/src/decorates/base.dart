import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';

import '../parser/fast_parser.dart';

///组件的装饰器
abstract class FastDecorate {
  ///组件解析方式
  Widget build(BuildContext context, FastParser parser, Widget child);
}

class FastDecorateWidget implements FastDecorate {
  final Widget Function(BuildContext context, FastParser parser, Widget child)
      builder;

  FastDecorateWidget(this.builder);

  @override
  Widget build(BuildContext context, FastParser parser, Widget child) {
    return builder(context, parser, child);
  }
}

///构建器
abstract class FastDecorateBuilder
    implements FastConfigParserBuilder<FastDecorate> {
  @override
  FastDecorate? Function(
          BuildContext context, FastParser parser, FastUIConfig config)
      get builder => buildDecorate;

  FastDecorate? buildDecorate(
      BuildContext context, FastParser parser, FastUIConfig config);
}

extension FastDecorateExt on List<FastDecorate>? {
  Widget applyAfterBuild(
      BuildContext context, FastParser parser, Widget widget) {
    Widget result = widget;
    if (this != null) {
      for (var value in this!) {
        result = value.build(context, parser, result);
      }
    }
    return result;
  }
}
