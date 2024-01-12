import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/src/types.dart';
import '../parser/fast_parser.dart';
import '../scheme/scheme.dart';
import 'base.dart';

///内边距
class FastExpand implements FastDecorate {
  const FastExpand({this.flex});

  final int? flex;

  @override
  Widget build(BuildContext context, FastParser parser, Widget child) {
    return Expanded(
      flex: flex ?? 1,
      child: child,
    );
  }
}

///构建器
class FastExpandBuilder extends FastDecorateBuilder {
  @override
  FastDecorate? buildDecorate(
      BuildContext context, FastParser parser, FastUIConfig config) {
    return FastExpand(flex: config['flex'] ?? 1);
  }

  @override
  Map<String, FastScheme> get scheme => {
        "flex": FastScheme<num>(),
      };
}
