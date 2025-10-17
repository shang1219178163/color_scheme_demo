//
//  APPNotFoundPage.dart
//  flutter_templet_project
//
//  Created by shang on 5/20/21 5:31 PM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

import '../util/AppNavigator.dart';
import '../util/dlog.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  late final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 200.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("$args"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('哎呀, 你的页面跑路了!'),
            ),
            TextButton(
              onPressed: () {
                DLog.d('哎呀, 你的页面跑路了!');
              },
              child: Text('立即捉它回家!'),
            ),
            TextButton(
              onPressed: () {
                AppNavigator.back({"$this": args});
              },
              child: Text('带参返回'),
            ),
          ],
        ),
      ),
    );
  }
}
