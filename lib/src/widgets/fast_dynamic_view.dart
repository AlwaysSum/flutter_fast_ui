import 'package:flutter/material.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:flutter_fast_ui/src/parser/view/base.dart';

/// 通过动态解码配置文件渲染一个组件

class FastDynamicView extends StatelessWidget {
  const FastDynamicView(
      {super.key, required this.config, this.data, this.methods});

  ///当前 View 的相关配置
  final Map<String, dynamic> config;

  ///当前 View 所具备的数据
  final Map<String, dynamic>? data;

  ///当前 View 所具备的函数
  final Map<String, Function>? methods;

  @override
  Widget build(BuildContext context) {
    ///动态值转换
    final ui = FastUI.decodeConfig(
      config,
      data: data,
      methods: methods,
    );

    if (ui != null) {
      return FastWidget.buildWidget(context, ui);
    }

    return const Placeholder();
  }
}
