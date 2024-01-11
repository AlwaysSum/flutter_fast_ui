import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';

abstract class FastWidgetBuilder implements FastConfigParserBuilder<Widget> {
  @override
  Widget? Function(BuildContext context, FastUIConfig config) get builder =>
      buildWidget;

  Widget buildWidget(BuildContext context, FastUIConfig config);
}
