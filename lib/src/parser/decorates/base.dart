import 'package:flutter/material.dart';

///组件的装饰器
abstract class FastDecorate {
  ///组件解析方式
  Widget build(BuildContext context, Widget child);
}
