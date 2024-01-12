import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

import 'init.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print(details);
  };

  initCustomFastUI();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (setting) {},
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder(
          future: rootBundle.loadString("assets/page/home.json", cache: false),
          builder: (context, data) {
            if (data.hasError || !data.hasData || data.data == null) {
              return const Center(
                child: Text("加载异常"),
              );
            }
            final config = jsonDecode(data.data!);
            return Center(
              child: FastDynamicView(
                data: config['data'],
                config: config['config'],
                methods: {
                  "onRefresh": (List args) {
                    print("@@@ $args");
                    final [
                      ValueNotifier<String> name,
                      ValueNotifier<num> padding
                    ] = args;
                    return () {
                      name.value = "${name.value}!!";
                      padding.value = min(padding.value + 10, 50);
                      name.notifyListeners();
                      padding.notifyListeners();
                    };
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
