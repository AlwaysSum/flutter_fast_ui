import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

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
}
