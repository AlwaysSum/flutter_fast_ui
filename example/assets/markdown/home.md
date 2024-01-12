# flutter_fast_ui

* 🤪Developing....正在开发中❗️❗️❗️

## Getting Started

## ❤️概念相关

FastUI 是一个通过轻量快捷的 UI构建框架。可以通过 JSON 数据构建 UI 界面，并进行一些的交互逻辑等。

* 组件：可以将 JSON 文件解析成一个Widget。可以 build 成一个 Widget。
* 装饰器：一些作用于组件，让组件添加效果的组件。它们有且只有一个 child。
* 类型转换器：用于将一些特殊类型转换为原始类型。
* 函数解析器： 用来解析 JSON 数据的函数名称，进行函数绑定操作。
* 组件解析器： 用来解析 JSON 数据中的Widget 组件，进行渲染。
* 装饰器解析器：用来解析 JSON 数据中的 装饰器(decorates)，进行组件的一些效果处理。

## 基本使用

一、渲染一个容器，里面使用文本渲染文字"张三".

> 更多的组件使用，参考详细文档。

```dart

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 数据 JSON:可以来源于网络或者本地资源
    const dataJson = r"""{
      "name": "张三",
    }""";

    // 组件 JSON:可以来源于网络或者本地资源
    const widgetJson = r"""{
      "type": "container",
      "color": "#00ff00",
      "child": {
        "type": "text",
        "text": "Hello,${"name"}"
      }
    }""";

    return FastDynamicView(
      data: jsonDecode(dataJson),
      config: jsonDecode(widgetJson),
    );
  }
}
```

二、动态数据： 以下效果实现了，通过点击文本"张三"将文本替换成了"李四"。

> 其中： ":name" 变量前新增了":"，将转换为动态变量。所有使用到的子组件将监听它的变化而改变。
> "onTap"事件调用了内置的`set`函数 ，它将设置的值赋予了:name。

```dart

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 数据 JSON:可以来源于网络或者本地资源
    const dataJson = r"""{
      ":name": "张三",
    }""";

    // 组件 JSON:可以来源于网络或者本地资源
    const widgetJson = r"""{
      "type": "container",
      "color": "#00ff00",
      "child": {
        "type": "text",
        "text": "Hello,${":name"}",
        "decorates":[{
           "type": "padding",
           "padding": 20,
          },{
           "type": "event",
           "onTap": "@{set(${:name},李四)}"
        }]
      }
    }""";

    return FastDynamicView(
      data: jsonDecode(dataJson),
      config: jsonDecode(widgetJson),
    );
  }
}

```

## ☀️ 函数的传递

以下例子通过自定义onRefresh 函数，实现了同时更新多个变量并刷新了相关使用组件。

```dart

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 数据 JSON:可以来源于网络或者本地资源
    const dataJson = r"""{
      ":name": "张三",
      ":padding": 20,
    }""";

    // 组件 JSON:可以来源于网络或者本地资源
    const widgetJson = r"""{
      "type": "container",
      "color": "#00ff00",
      "child": {
        "type": "text",
        "text": "Hello,${":name"}",
        "decorates":[{
           "type": "padding",
           "padding": "${:padding}",
          },{
           "type": "event",
           "onTap": "@{onRefresh(${:name},${:padding})}"
        }]
      }
    }""";

    return FastDynamicView(
      data: jsonDecode(dataJson),
      config: jsonDecode(widgetJson),
      methods: {
        "onRefresh": (context,List args) {
          final [ValueNotifier<String> name, ValueNotifier<num> padding] = args;
          return () {
            name.value = "${name.value}!!";
            padding.value = min(padding.value + 10, 50);
            name.notifyListeners();
            padding.notifyListeners();
          };
        }
      },
    );
  }
}

```
## 🐶自定义组件渲染器

```dart
void main() {
  /// 项目启动后，添加一个自定义Widget
  /// 添加后就可以使用 { "type":"test","name":"自定义参数" } 来渲染一个该组件了。
  FastUI.addWidgetParser({
    "test": FastConfigParserBuilder(
      scheme: {
        "name": FastScheme<String>()
      },
      builder: (context, parser, config) {
        return Container(
          child: Text("这是一个自定义组件:${config['name']}"),
        );
      },
    )
  });

  runApp(const MyApp());
}
```

## 🐱自定义装饰渲染器

```dart
void main() {
  /// 项目启动后，添加一个自定义Widget
  /// 添加后就可以使用 { "type":"onlyPC" } 来控制某个租金是否只能在 PC 上显示了。
  FastUI.addDecorateParser({
    //通过该装饰器，设置某些组件只在 PC 上显示
    'onlyPC': FastConfigParserBuilder<FastDecorate>(
        scheme: {
          "width": FastScheme<num>(),
        },
        builder: (context, parser, config) {
          final width = config["width"] ?? 720;
          final show = MediaQuery
              .of(context)
              .size
              .width > width;
          return FastDecorateWidget(
                  (context, parser, child) => show ? child : const SizedBox());
        })
  });

  runApp(const MyApp());
}
```

## 🏀 全局的函数和数据设置

```dart
void main() {
  // 项目启动后
  //添加了全局的函数，可以在任何组件内调用，无需再次设置 methods
  FastUI.addMethodsParser({
    "globalMethod": (context,args) {
      print("调用了一个全局函数");
    },
  });

  //添加了全局的参数，可以在任何组件内调用，无需再次设置 data
  FastUI.addDataParser({
    "appName": "FastUI",
  });

  runApp(const MyApp());
}
```


## 📚待办清单

### 1、内置组件：

###### 基础组件

1. [x] Container
2. [x] Text
3. [x] Row
4. [x] Column
5. [ ] Stack
6. [ ] Warp
7. [ ] List
8. [x] Image
9. [ ] Icon
10. [ ] Button
11. [ ] GridView
12. [ ] PageView
13. [ ] Divider
14. [ ] TabView

### 表单组件

1. [ ] Switch
2. [ ] TextFiled
3. [ ] Dropdown
4. [ ] RadioGroup
5. [ ] CheckBox
6. [ ] Slider
7. [ ] RatingBar
8. [ ] PinColo
9. [ ] CounterButton
10. [ ] Selector


##### 2、JSON 转换相关：

1. [x] 支持通过 JSON 解析成组件。
2. [x] 支持 JSON 中支持原始数据类型转换成特定类型，如：Color、Alignment、EdgeInsets等
3. [ ] 支持自定义一些类型转换器
4. [x] 支持绑定组件的装饰器，如 Padding、Align、Expand等
5. [x] 支持自定义组件的装饰器
6. [x] 支持事件、函数列表 的绑定
7. [x] 支持自定义事件周期
8. [x] 支持绑定参数池，根据状态池刷新组件
9. [ ] JSON 解析失败的各种异常处理，目前未处理
10.[ ] JSON 编写时的代码提示工具
11.[ ] ...

##### 3、fast-app-editor 编辑器相关（另一个项目）：

1. [ ] 解析项目配置生产组件列表
2. [ ] 拖拽组件生成配置文件
3. [ ] 设置面板设置组件属性
4. [ ] 页面管理器
5. [ ] 组件管理器
6. [ ] API管理器
7. [ ] 事件管理器