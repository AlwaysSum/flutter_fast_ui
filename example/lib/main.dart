import 'dart:async';
import 'dart:convert';

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
"padding": 100
},
{
"type": "event",
"onTap": "@{onRefresh(${:name})}"
}
],
"text": "Running on: FastUI ${:name}"
}
}""";

    final configMap = jsonDecode(config);

    print("@@@nihao---->$_platformVersion");

    final data = {":name": ValueNotifier("小明")};
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FastDynamicView(
            data: data,
            methods: {
              "onRefresh": (List args) {
                final [ValueNotifier name] = args;
                print("@@@！！ ${name}");
                return () {
                  print("@@@>>>> ${name}");
                  name.value = "${name.value}!!";
                  name.notifyListeners();
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
