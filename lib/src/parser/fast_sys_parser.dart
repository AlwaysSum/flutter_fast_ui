import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/scheme/scheme_edge_inset.dart';

import '../scheme/scheme_color.dart';

///系统的解析器
class FastSystemParser {
  ///组件解析
  final Map<String, FastConfigParserBuilder<Widget>> parser = {
    'text': FastTextBuilder(),
    'button': FastButtonBuilder(),
    'container': FastContainerBuilder(),
    'row': FastRowBuilder(),
    'column': FastColumnBuilder(),
    'image': FastImageBuilder(),
    'list': FastListBuilder(),
  };

  ///装饰器解析
  final Map<String, FastConfigParserBuilder<FastDecorate>> parserDecorate = {
    'padding': FastPaddingBuilder(),
    'expand': FastExpandBuilder(),
    'event': FastEventBuilder(),
  };

  /// 值类型解析
  // final Map<Type,FastSchemeValueFunction> parserValues = {
  //   Color: (color),
  // };
  final List<FastSchemeParser> parserValues = [
    FastSchemeColorParser(),
    FastSchemeEdgeInsetsParser(),
  ];
}
