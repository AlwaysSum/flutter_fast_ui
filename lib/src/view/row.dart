import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';

/// Row
class FastRow extends StatelessWidget  {
  //配置文件
  final List<Widget> children;

  const FastRow({
    required this.children,
    super.key,
  }) : assert(children is List<Widget>?);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children,
    );
  }

  static Map<String, FastScheme> scheme = {
    "children": FastScheme<List<FastUIConfig>>(),
  };

  /// 解析配置
  factory FastRow.fromJson(FastUIConfig config) {
    return FastRow(
      children: config['children'],
    );
  }
}
