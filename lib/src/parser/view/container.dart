import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';
import 'package:flutter_fast_ui/src/types.dart';

import '../decorates/base.dart';

///一个基础容器
class FastContainer extends StatelessWidget implements FastWidget {
  // 颜色
  final Color? color;

  //配置文件
  final FastWidget? child;

  @override
  final List<FastDecorate>? decorates;

  const FastContainer(
    this.child, {
    super.key,
    this.color,
    this.decorates,
  }) : assert(color is Color?);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: FastWidget.buildWidget(context, child),
    );
  }

  static Map<String, FastScheme> scheme = {
    "color": FastScheme<Color>(),
    "child": FastScheme<FastUIConfig>(),
  };

  /// 解析配置
  factory FastContainer.fromJson(FastUIConfig config) {
    return FastContainer(
      config['child'],
      color: config['color'],
      decorates: config[FastKey.decorate],
    );
  }
}
