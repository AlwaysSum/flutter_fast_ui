import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_ui/src/view/column.dart';
import 'package:flutter_fast_ui/src/view/image.dart';
import 'package:flutter_fast_ui/src/view/row.dart';

import '../decorates/base.dart';
import '../decorates/fast_event.dart';
import '../decorates/fast_padding.dart';
import '../types.dart';
import '../view/container.dart';
import '../view/list.dart';
import '../view/text.dart';

///系统的解析器
class FastSystemParser {
  ///组件解析
  final Map<String, FastConfigParserBuilder<Widget>> parser = {
    'text': FastTextBuilder(),
    'container': FastContainerBuilder(),
    'row': FastRowBuilder(),
    'column': FastColumnBuilder(),
    'image': FastImageBuilder(),
    'list': FastListBuilder(),
  };

  ///装饰器解析
  final Map<String, FastConfigParserBuilder<FastDecorate>> parserDecorate = {
    'padding': FastPaddingBuilder(),
    'event': FastEventBuilder(),
  };
}
