# flutter_fast_ui

## Getting Started

## 一、概念相关

一个轻量快捷的 UI构建框架。

* 组件：可以转换成 json，以及从 json 转换过来。可以 build 成一个 Widget。
* 装饰器：一些作用于组件，让组件添加效果的组件。它们有且只有一个 child。
* 类型转换器：用于将一些特殊类型转换为原始类型。

## 二、待办清单

### 1、内置组件：

###### 基础组件

1. [ ] Container
2. [ ] Text
3. [ ] Row
4. [ ] Column
5. [ ] Stack
6. [ ] Warp
7. [ ] List
8. [ ] Image
9. [ ] Icon
10. [ ] Button
11. [ ] GridView
12. [ ] PageView
13. [ ] Divider

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
4. [ ] 支持绑定组件的装饰器，如 Padding、Align、Expand等
5. [x] 支持自定义组件的装饰器
6. [ ] 支持事件、函数列表 的绑定
7. [ ] 支持自定义事件周期
8. [ ] 支持绑定参数池，根据状态池刷新组件

##### 3、fast-app-editor 编辑器相关（另一个项目）：

1. [ ] 解析项目配置生产组件列表
2. [ ] 拖拽组件生成配置文件
3. [ ] 设置面板设置组件属性
4. [ ] 页面管理器
5. [ ] 组件管理器
6. [ ] API管理器
7. [ ] 事件管理器