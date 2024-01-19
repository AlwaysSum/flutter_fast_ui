import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../../parser/fast_parser.dart';

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
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final Widget Function(BuildContext context, int index)? buildSpace;

  const FastColumn({
    required this.children,
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0,
    this.buildSpace,
  }) : assert(children is List<Widget>?);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacing > 0 || buildSpace != null
          ? children.joinItem((index) => buildSpace != null
              ? buildSpace!(context, index)
              : SizedBox(height: spacing))
          : children,
    );
  }
}
