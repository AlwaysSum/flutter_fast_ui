import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../decorates/base.dart';
import '../parser/fast_parser.dart';

///用于动态刷新的装饰器
class FastValueBuilder implements FastDecorate {
  // 颜色
  final List<ValueListenable> values;

  //配置文件
  final Widget Function(BuildContext context, FastParser parser, Widget chlid)
      builder;

  const FastValueBuilder({
    required this.values,
    required this.builder,
  }) : assert(values is List<ValueListenable>);

  /// 解析方式
  @override
  Widget build(BuildContext context, FastParser parser, Widget child) {
    Widget? result;
    for (var value in values) {
      final buildChild = result;
      result = ValueListenableBuilder(
        valueListenable: value,
        builder: (context, value, child) {
          return (buildChild ??
              builder(context, parser, child ?? const SizedBox()));
        },
        child: child,
      );
    }
    return result ?? const SizedBox();
  }
}
