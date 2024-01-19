import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

import '../../parser/fast_parser.dart';

class FastRowBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config) {
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

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final Widget Function(BuildContext context, int index)? buildSpace;

  const FastRow({
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
    return Row(
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
