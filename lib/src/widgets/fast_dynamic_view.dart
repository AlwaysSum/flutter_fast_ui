import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';

/// 通过动态解码配置文件渲染一个组件
class FastDynamicView extends StatefulWidget {
  const FastDynamicView({super.key, required this.config});

  ///当前 View 的相关配置
  final Map<String, dynamic> config;

  @override
  State<FastDynamicView> createState() => _FastDynamicViewState();
}

class _FastDynamicViewState extends State<FastDynamicView> {
  @override
  Widget build(BuildContext context) {
    final ui = FastUI.decodeConfig(widget.config);
    if (ui != null) {
      return ui.applyDecorateAfterBuild(context);
    }
    return const Placeholder();
  }
}
