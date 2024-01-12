import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_ui/src/parser/fast_parser.dart';

import 'scheme/scheme.dart';

///配置
typedef FastUIConfig = Map<String, dynamic>;

///通过配置构造一个组件

class FastConfigParserBuilder<T> {
  final Map<String, FastScheme> scheme;
  final T? Function(
      BuildContext context, FastParser parser, FastUIConfig config) builder;

  FastConfigParserBuilder({required this.scheme, required this.builder});
}
