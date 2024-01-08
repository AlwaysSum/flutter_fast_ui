import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';

void main() {
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
    const config = """{
"type": "container",
"color": 4294901760,
"child": {
"type": "text",
"color": 4294967295,
"decorates": [
{
"type": "padding",
"padding": 10
},
{
"type": "event",
"onTap": "@{onRefresh}"
}
],
"text": "Running on: FastUI \${name}"
}
}""";

    final configMap = jsonDecode(config);

    print("@@@nihao---->$_platformVersion");

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FastDynamicView(
            data: const {":name": "小明"},
            methods: {
              "onRefresh": () {
                setState(() {
                  _platformVersion = "${_platformVersion}!!!";
                });
              }
            },
            config: configMap,
          ),
        ),
      ),
    );
  }
}
