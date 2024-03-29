import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../../parser/fast_parser.dart';

///构建器
class FastContainerBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(BuildContext context, FastParser parser,
      FastUIConfig config) {
    return FastContainer(
      child:config['child'],
      color: config['color'],
    );
  }

  @override
  Map<String, FastScheme> get scheme =>
      {
        "color": FastScheme<Color>(),
        "child": FastScheme<FastUIConfig>(),
      };
}

///一个基础容器
class FastContainer extends StatelessWidget {
  // 颜色
  final Color? color;

  //配置文件
  final Widget? child;

  final BoxConstraints? constraints;

  const FastContainer({
    required this.child,
    super.key,
    this.color,
    this.constraints,
  }) : assert(color is Color?);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: this.constraints,
      decoration: BoxDecoration(
        color: color,
      ),
      child: child,
    );
  }
}
