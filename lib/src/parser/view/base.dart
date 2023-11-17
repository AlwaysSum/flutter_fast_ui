import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/const/keys.dart';
import 'package:flutter_fast_ui/src/parser/decorates/base.dart';

import '../../types.dart';
import '../scheme/scheme.dart';

abstract class FastWidget extends Widget {
  const FastWidget({super.key, this.decorates});

  ///组件解析方式
  Widget build(BuildContext context);

  final List<FastDecorate>? decorates;
}

extension FastWidgetExt on FastWidget {
  ///应用装饰后构建
  applyDecorateAfterBuild(BuildContext context) {
    Widget result = this;
    if (decorates != null) {
      for (var value in decorates!) {
        result = value.build(context, result);
      }
    }
    return result;
  }
}
