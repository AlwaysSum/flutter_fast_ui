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

  ///声明配置
  static Map<String, FastScheme> scheme = {
    "padding": FastScheme<EdgeInsets>(),
  };

  factory FastPadding.fromJson(FastUIConfig config) {
    return FastPadding(padding: config['padding']);
  }
}
