import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/parser/decorates/base.dart';
import 'package:flutter_fast_ui/src/types.dart';
import '../scheme/scheme.dart';

///内边距
class FastEvent implements FastDecorate {
  const FastEvent({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, Widget child) {
    return InkWell(
      onTap: onTap,
      child: child,
    );
  }

  ///声明配置
  static Map<String, FastScheme> scheme = {
    "onTap": FastScheme<Function>(),
  };

  factory FastEvent.fromJson(FastUIConfig config) {
    print("@!!!! $config");
    return FastEvent(onTap: config['onTap']);
  }
}
