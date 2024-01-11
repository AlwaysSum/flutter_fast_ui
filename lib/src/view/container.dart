import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

///构建器
class FastContainerBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(BuildContext context, FastUIConfig config) {
    return FastContainer(
      config['child'],
      color: config['color'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
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

  const FastContainer(
    this.child, {
    super.key,
    this.color,
  }) : assert(color is Color?);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    print("@@@ $child");
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: child,
    );
  }
}
