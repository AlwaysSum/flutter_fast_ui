import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';
import '../scheme/scheme.dart';
import 'base.dart';

///事件
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
}

///构建器
class FastEventBuilder extends FastDecorateBuilder {
  @override
  FastDecorate? buildDecorate(BuildContext context, FastUIConfig config) {
    return FastEvent(onTap: config['onTap']);
  }

  @override
  Map<String, FastScheme> get scheme => {
        "onTap": FastScheme<Function>(),
      };
}
