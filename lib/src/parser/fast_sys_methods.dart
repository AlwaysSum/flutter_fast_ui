import 'package:flutter/material.dart';

///一些系统预设函数
class FastSysMethods {
  Map<String, Function> methods = {
    "set": (List args) {
      final [ValueNotifier data, value] = args;
      return () {
        data.value = value;
        data.notifyListeners();
      };
    },
    "add": (List args) {
      final [ValueNotifier data, String value] = args;
      return () {
        print("@@@$value ${data.value is num} ${num.tryParse(value)}");
        if (data.value is num) {
          final newValue = num.parse(value);
          data.value = data.value + newValue;
          data.notifyListeners();
        } else {
          data.value = data.value + value;
          data.notifyListeners();
        }
      };
    }
  };
}
