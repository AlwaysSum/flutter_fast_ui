import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../parser/fast_parser.dart';

class FastRowBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(BuildContext context,FastParser parser, FastUIConfig config) {
    return FastRow(
      children: config['children'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "children": FastScheme<List<Widget>>(),
      };
}

/// Row
class FastRow extends StatelessWidget {
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
}
