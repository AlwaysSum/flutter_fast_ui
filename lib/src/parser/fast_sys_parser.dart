import 'package:flutter_fast_ui/src/parser/decorates/base.dart';
import 'package:flutter_fast_ui/src/parser/decorates/fast_padding.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';
import 'package:flutter_fast_ui/src/parser/view/container.dart';
import 'package:flutter_fast_ui/src/parser/view/text.dart';

import '../types.dart';

///系统的解析器
class FastSystemParser {
  ///组件解析
  final Map<String, FastConfigParserBuilder<FastWidget>> parser = {
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
  };
}
