import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';
import 'package:flutter_fast_ui/src/types.dart';

import '../decorates/base.dart';

///一个基础容器
class FastValueBuilder extends StatelessWidget implements FastWidget {
  // 颜色
  final List<ValueListenable> values;

  //配置文件
  final WidgetBuilder builder;

  @override
  final List<FastDecorate>? decorates;

  const FastValueBuilder({
    super.key,
    required this.values,
    required this.builder,
    this.decorates,
  }) : assert(values is List<ValueListenable>);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    Widget? child;
    for (var value in values) {
      print("@@!@#!!@  ${value}");
      final buildChild = child;
      child = ValueListenableBuilder(
        valueListenable: value,
        builder: (context, value, __) {
          return (buildChild ?? builder(context));
        },
      );
    }
    return child ?? const SizedBox();
  }

  static Map<String, FastScheme> scheme = {
    "values": FastScheme<List<ValueListenable>>(),
    "builder": FastScheme<WidgetBuilder>(),
  };

  /// 解析配置
  factory FastValueBuilder.fromJson(FastUIConfig config) {
    return FastValueBuilder(
      builder: config['builder'],
      values: config['values'],
      decorates: config[FastKey.decorate],
    );
  }
}
