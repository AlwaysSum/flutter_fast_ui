import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    print(details);
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterFastUiPlugin = FastUI();

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _flutterFastUiPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    const config = r"""{
    "type": "container",
    "color": 4294901760,
    "child": {
        "type": "text",
        "color": 4294967295,
        "decorates": [
            {
                "type": "padding",
                "padding": "${:padding}"
            },
            {
                "type": "event",
                "onTap": "@{add(${:padding},20)}"
            }
        ],
        "text": "Running on: FastUI , ${:name}"
    }
}""";

    const data = r"""
          {
              ":name": "小明",
              ":padding": 10
            }
    """;

    final configMap = jsonDecode(config);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FastDynamicView(
            data: jsonDecode(data),
            methods: {
              "onRefresh": (List args) {
                print("@@@ $args");
                final [ValueNotifier<String> name, ValueNotifier<num> padding] =
                    args;
                return () {
                  name.value = "${name.value}!!";
                  padding.value = min(padding.value + 10, 50);
                  name.notifyListeners();
                  padding.notifyListeners();
                };
              }
            },
            config: configMap,
          ),
        ),
      ),
    );
  }
}
