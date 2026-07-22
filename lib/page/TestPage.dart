import 'package:color_scheme_demo/util/AppNavigator.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final scrollController = ScrollController();

// 👇 数据源定义
  List<Item> items = [
    Item(header: '标题 1', body: '这里是内容 1'),
    Item(header: '标题 2', body: '这里是内容 2'),
    Item(header: '标题 3', body: '这里是内容 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          IconButton(
            onPressed: () {
              DLog.d([
                "Colors.green",
                Colors.green,
              ]);
            },
            icon: const Icon(
              Icons.color_lens,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ExpansionPanelList(
              elevation: 0,
              expansionCallback: (index, isExpanded) {
                items[index].isExpanded = isExpanded;
                setState(() {});
                DLog.d(items);
              },
              children: items.map((item) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: item.isExpanded ? Colors.green : Colors.yellow,
                  headerBuilder: (context, isExpanded) {
                    return Material(
                      // color: Colors.white,
                      child: ListTile(
                        title: Text(item.header),
                      ),
                    );
                  },
                  body: Material(
                    color: item.isExpanded ? Colors.green : Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(item.body),
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ 模型类定义
class Item {
  Item({
    required this.header,
    required this.body,
    this.isExpanded = false,
  });

  String header;
  String body;
  bool isExpanded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['header'] = header;
    map['body'] = body;
    map['isExpanded'] = isExpanded;
    return map;
  }

  @override
  String toString() {
    return "$runtimeType ${toJson()}";
  }
}
