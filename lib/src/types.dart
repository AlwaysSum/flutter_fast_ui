import 'package:flutter/cupertino.dart';
import 'package:flutter_fast_ui/src/parser/fast_parser.dart';

import 'scheme/scheme.dart';

///配置
typedef FastUIConfig = Map<String, dynamic>;

///通过配置构造一个组件
typedef FastConfigFunction = Function(BuildContext context, List args);

typedef FastSchemeValueFunction<T> = Function(
    String type, String key, dynamic value, FastScheme<T> scheme);

///构建器
class FastConfigParserBuilder<T> {
  final Map<String, FastScheme> scheme;
  final T? Function(
      BuildContext context, FastParser parser, FastUIConfig config) builder;

  FastConfigParserBuilder({required this.scheme, required this.builder});
}
