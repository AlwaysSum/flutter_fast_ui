import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';
import '../scheme/scheme.dart';
import 'base.dart';

///内边距
class FastPadding implements FastDecorate {
  const FastPadding({this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, Widget child) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: child,
    );
  }
}

///构建器
class FastPaddingBuilder extends FastDecorateBuilder {
  @override
  FastDecorate? buildDecorate(BuildContext context, FastUIConfig config) {
    return FastPadding(padding: config['padding']);
  }

  @override
  Map<String, FastScheme> get scheme => {
        "padding": FastScheme<EdgeInsets>(),
      };
}
