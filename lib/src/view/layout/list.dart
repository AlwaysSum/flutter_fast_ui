import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/types.dart';
import 'package:flutter_fast_ui/src/view/base.dart';

import '../../parser/fast_parser.dart';

class FastListBuilder extends FastWidgetBuilder {
  @override
  Widget buildWidget(
      BuildContext context, FastParser parser, FastUIConfig config) {
    return FastList(
      data: (config['data'] as List).cast<Map<String, dynamic>>(),
      itemBuilder: (BuildContext context, int index) {
        final item = config['data']?[index];
        return item != null
            ? FastDynamicView(
                data: {...parser.data, ...item},
                config: config['config'],
                methods: parser.methods,
              )
            : const SizedBox();
      },
    );
  }

  @override
  Map<String, FastScheme> get scheme => {
        "data": FastScheme<List>(),
        "config": FastScheme<FastUIConfig>(),
      };
}

/// Row
class FastList extends StatelessWidget {
  //配置文件
  final List<Map<String, dynamic>?> data;
  final NullableIndexedWidgetBuilder itemBuilder;

  const FastList({
    super.key,
    required this.data,
    required this.itemBuilder,
  }) : assert(data is List<Map<String, dynamic>?>);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: itemBuilder,
      itemCount: data?.length,
    );
  }
}
