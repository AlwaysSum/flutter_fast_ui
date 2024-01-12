import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fast_ui/flutter_fast_ui.dart';
import 'package:markdown_widget/markdown_widget.dart';

void initCustomFastUI() {
  ///添加自定义的Widget构建器
  FastUI.addWidgetParser({
    ///解析 markdown
    "markdown": FastConfigParserBuilder(
      scheme: {
        "url": FastScheme<String>(),
      },
      builder: (context, parser, config) {
        return FutureBuilder(
          future: rootBundle.loadString(config['url']),
          builder: (context, data) {
            if (data.hasError || !data.hasData || data.data == null) {
              return Center(
                child: Text("加载Markdown失败，请检查文件地址:\n${config["url"]}"),
              );
            }
            return Center(
              child: MarkdownWidget(data: data.data!),
            );
          },
        );
      },
    )
  });
}
