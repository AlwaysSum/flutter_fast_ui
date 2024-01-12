import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../parser/fast_parser.dart';

///构建器
class FastButtonBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config) {
    return FastButton(
      config['text'],
      color: config['color'],
      onTap: config['onTap'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "color": FastScheme<Color>(),
        "text": FastScheme<String>(),
        "onTap": FastScheme<Function>(),
      };
}

class FastButton extends StatelessWidget {
  //文本颜色
  final Color? color;

  //文本
  final String? data;
  final VoidCallback? onTap;

  const FastButton(
    this.data, {
    super.key,
    this.color,
    this.onTap,
  }) : assert(color is Color?);

  /// 解析方式
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Text(
        data ?? '',
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
