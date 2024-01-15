import 'package:flutter/material.dart';

import '../../flutter_fast_ui.dart';
import '../utils/utils_value.dart';

class FastSchemeColorParser extends FastSchemeParser<Color> {
  @override
  Color parserJson(value) {
    if (value is int) {
      return Color(value);
    } else if (value is String) {
      return UtilsValue.fromHexColor(value);
    } else {
      throw Exception("值必须为 int 类型或者 hex 字符串。 value:$value");
    }
  }
}
