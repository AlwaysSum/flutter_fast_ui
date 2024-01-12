import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../parser/fast_parser.dart';

class FastImageBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config) {
    return FastImage(
      src: config['src'],
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "src": FastScheme<String>(),
      };
}

/// FastImage
class FastImage extends StatelessWidget {
  //配置文件
  final String src;

  const FastImage({
    required this.src,
    super.key,
  }) : assert(src is String);

  @override
  Widget build(BuildContext context) {
    return Image.network(src);
  }
}
