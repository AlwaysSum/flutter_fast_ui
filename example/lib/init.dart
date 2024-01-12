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
        final tocController = TocController();

        return FutureBuilder(
          future: rootBundle.loadString(config['url']),
          builder: (context, data) {
            if (data.hasError || !data.hasData || data.data == null) {
              return Center(
                child: Text("加载Markdown失败，请检查文件地址:\n${config["url"]}"),
              );
            }
            final show = MediaQuery.of(context).size.width > 720;
            return Row(
              children: [
                Expanded(
                  flex: 4,
                  child: MarkdownWidget(
                    data: data.data!,
                    tocController: tocController,
                  ),
                ),
                if (show) Expanded(child: TocWidget(controller: tocController)),
              ],
            );
          },
        );
      },
    )
  });

  FastUI.addDecorateParser({
    //通过该装饰器，设置某些组件只在 PC 上显示
    'onlyPC': FastConfigParserBuilder<FastDecorate>(
        scheme: {
          "width": FastScheme<num>(),
        },
        builder: (context, parser, config) {
          final width = config["width"] ?? 720;
          final show = MediaQuery.of(context).size.width > width;
          return FastDecorateWidget(
              (context, parser, child) => show ? child : const SizedBox());
        })
  });


}
