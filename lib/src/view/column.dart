import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../parser/fast_parser.dart';

class FastColumnBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config) {
    return FastColumn(
      children: config['children'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "children": FastScheme<List<Widget>>(),
      };
}

/// Row
class FastColumn extends StatelessWidget {
  //配置文件
  final List<Widget> children;

  const FastColumn({
    required this.children,
    super.key,
  }) : assert(children is List<Widget>?);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}
