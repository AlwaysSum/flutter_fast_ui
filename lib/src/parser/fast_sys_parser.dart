import 'package:flutter/cupertino.dart';

import '../decorates/base.dart';
import '../decorates/fast_event.dart';
import '../decorates/fast_padding.dart';
import '../types.dart';
import '../view/container.dart';
import '../view/text.dart';

///系统的解析器
class FastSystemParser {
  ///组件解析
  final Map<String, FastConfigParserBuilder<Widget>> parser = {
    'text': FastConfigParserBuilder(
      scheme: FastText.scheme,
      builder: FastText.fromJson,
    ),
    'container': FastConfigParserBuilder(
      scheme: FastContainer.scheme,
      builder: FastContainer.fromJson,
    ),
  };

  ///装饰器解析
  final Map<String, FastConfigParserBuilder<FastDecorate>> parserDecorate = {
    'padding': FastConfigParserBuilder<FastDecorate>(
      scheme: FastPadding.scheme,
      builder: FastPadding.fromJson,
    ),
    'event': FastConfigParserBuilder<FastDecorate>(
      scheme: FastEvent.scheme,
      builder: FastEvent.fromJson,
    ),
  };
}
