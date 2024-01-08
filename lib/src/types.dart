import 'package:flutter_fast_ui/flutter_fast_ui.dart';

///配置
typedef FastUIConfig = Map<String, dynamic>;

///通过配置构造一个组件

class FastConfigParserBuilder<T> {
  final Map<String, FastScheme> scheme;
  final T? Function(FastUIConfig config) builder;

  FastConfigParserBuilder({required this.scheme, required this.builder});
}
