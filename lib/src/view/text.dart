import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';

import 'base.dart';

class FastText extends StatelessWidget with FastWidget {
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

  ///声明配置
  @override
  static Map<String, FastScheme> scheme = {
    "color": FastScheme<Color>(),
    "text": FastScheme<String>(),
  };

  /// 解析配置
  factory FastText.fromJson(FastUIConfig config) {
    return FastText(
      config['text'],
      color: config['color'],
    );
  }
}
