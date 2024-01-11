import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

class FastText extends StatelessWidget {
  //文本颜色
  final Color? color;

  //文本
  final String? data;

  const FastText(
    this.data, {
    super.key,
    this.color,
  }) : assert(color is Color?);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    return Text(
      data ?? '',
      style: TextStyle(
        color: color,
      ),
    );
  }
}

///构建器
class FastTextBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(BuildContext context, FastUIConfig config) {
    return FastText(
      config['text'],
      color: config['color'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "color": FastScheme<Color>(),
        "text": FastScheme<String>(),
      };
}
