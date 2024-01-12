import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';

import '../parser/fast_parser.dart';

abstract class FastWidgetBuilder implements FastConfigParserBuilder<Widget> {
  @override
  Widget? Function(BuildContext context, FastParser parser, FastUIConfig config)
      get builder => buildWidget;

  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config);
}
