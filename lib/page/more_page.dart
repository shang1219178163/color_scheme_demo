import 'package:color_scheme_demo/util/app_navigator.dart';
import 'package:color_scheme_demo/util/sheet_util.dart';
import 'package:flutter/material.dart';

class MorePage extends StatefulWidget {
  const MorePage({
    super.key,
    this.id,
    this.arguments,
  });

  final String? id;

  final Map<String, dynamic>? arguments;

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant MorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("id: ${widget.id}"),
              Text("arguments: ${widget.arguments}"),
              TextButton(
                onPressed: () {
                  AppNavigator.back(result: {"class": "$widget", ...?widget.arguments});
                },
                child: const Text('带参返回'),
              ),
              TextButton(
                onPressed: () {
                  onShowSheet(
                    text: '返回',
                    onTap: () {
                      AppNavigator.back();
                      DLog.d(AppNavigator());
                    },
                  );
                },
                child: const Text('showSheet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future onShowSheet({
    required String text,
    required VoidCallback onTap,
  }) {
    return SheetUtil.showCustom(
      context: context,
      child: Container(
        width: double.infinity,
        height: 400,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        child: Center(
          child: GestureDetector(
            onTap: onTap,
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
