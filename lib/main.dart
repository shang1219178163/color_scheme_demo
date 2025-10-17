import 'package:color_scheme_demo/page/RestorationMixinDemo.dart';
import 'package:color_scheme_demo/util/AppNavigator.dart';
import 'package:color_scheme_demo/util/AppRouter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app', // 🌟 开启全局 Restoration 支持
      title: 'ColorScheme 配色方案生成器',
      navigatorKey: AppNavigator.navigatorKey,
      navigatorObservers: [AppNavigatorObserver()],
      initialRoute: AppRouter.initial,
      routes: AppRouter.routeMap,
    );
  }
}
