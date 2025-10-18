import 'dart:convert';

import 'package:color_scheme_demo/util/dlog.dart';
import 'package:flutter/material.dart';
import 'AppRouter.dart';

export 'dlog.dart';

/// 路由管理
class AppNavigator {
  static bool isLog = true;

  /// 全局 NavigatorKey
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 当前 Navigator
  static NavigatorState get navigator => navigatorKey.currentState!;

  static Map<String, WidgetBuilder> get routeMap => AppRouter.routeMap;

  static final List<PageRoute<Object?>> _pageRoutes = [];
  List<PageRoute<Object?>> get pageRoutes => _pageRoutes;

  List<String?> get pageRouteNames => pageRoutes.map((e) => e.settings.name).toList();

  /// 之前路由页面
  static RouteSettings? _routePre;

  /// 之前路由页面
  static RouteSettings? get routePre => _routePre;

  /// 当前路由页面
  static RouteSettings? _route;

  /// 当前路由页面
  static RouteSettings? get route => _route;

  static Object? get argumentsPre => routePre?.arguments;
  static String? get routeNamePre => routePre?.name;

  static Object? get arguments => route?.arguments;
  static String? get routeName => route?.name;

  /// 匿名跳转（类似 Get.to）
  static Future<T?> to<T>(Widget page, {Object? arguments}) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page, settings: RouteSettings(arguments: arguments)),
    );
  }

  /// 命名跳转（类似 Get.toNamed）
  static Future<T?>? toNamed<T>(String routeName, {Object? arguments}) {
    final builder = routeMap[routeName];
    if (builder == null) throw Exception('Route "$routeName" not found.');
    return navigator.push<T>(
      MaterialPageRoute(builder: builder, settings: RouteSettings(name: routeName, arguments: arguments)),
    );
  }

  /// 替换当前页面（类似 Get.off）
  static Future<T?> off<T>(Widget page, {Object? arguments}) {
    return navigator.pushReplacement<T, T>(
      MaterialPageRoute(builder: (_) => page, settings: RouteSettings(arguments: arguments)),
    );
  }

  /// 命名替换（类似 Get.offNamed）
  static Future<T?>? offNamed<T>(String routeName, {Object? arguments}) {
    final builder = routeMap[routeName];
    if (builder == null) throw Exception('Route "$routeName" not found.');
    return navigator.pushReplacement<T, T>(
      MaterialPageRoute(builder: builder, settings: RouteSettings(name: routeName, arguments: arguments)),
    );
  }

  void until(RoutePredicate predicate) {
    return navigator.popUntil(predicate);
  }

  Future<T?>? offUntil<T>(Route<T> page, RoutePredicate predicate, {int? id}) {
    return navigator.pushAndRemoveUntil<T>(page, predicate);
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.<br><br>
  Future<T?>? offNamedUntil<T>(
    String page,
    RoutePredicate predicate, {
    int? id,
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return navigator.pushNamedAndRemoveUntil<T>(
      page,
      predicate,
      arguments: arguments,
    );
  }

  /// **Navigation.popAndPushNamed()** shortcut.<br><br>
  Future<T?>? offAndToNamed<T>(
    String page, {
    dynamic arguments,
    dynamic result,
    Map<String, String>? parameters,
  }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return navigator.popAndPushNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  void removeRoute(Route<dynamic> route) {
    return navigator.removeRoute(route);
  }

  /// 清空栈并跳转（类似 Get.offAll）
  static Future<T?> offAll<T>(Widget page, {Object? arguments}) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page, settings: RouteSettings(arguments: arguments)),
      (route) => false,
    );
  }

  /// 命名清栈跳转（类似 Get.offAllNamed）
  static Future<T?>? offAllNamed<T>(String routeName, {Object? arguments}) {
    final builder = routeMap[routeName];
    if (builder == null) throw Exception('Route "$routeName" not found.');
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: builder, settings: RouteSettings(name: routeName, arguments: arguments)),
      (route) => false,
    );
  }

  /// 返回上一级（类似 Get.back）
  static void back<T>([T? result]) {
    if (!navigator.canPop()) {
      return;
    }
    return navigator.pop(result);
  }

  /// **Navigation.popUntil()** (with predicate) shortcut .<br><br>
  void close(int times, [int? id]) {
    if (times < 1) {
      times = 1;
    }
    var count = 0;
    var back = navigator.popUntil((route) => count++ == times);
    return back;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageRoutes'] = pageRoutes.map((e) => e.toString()).toList();
    data['routeNames'] = pageRouteNames;
    data['settingsPre'] = routePre.toString();
    data['routeNamePre'] = routeNamePre;
    data['routeName'] = routeName;
    return data;
  }

  @override
  String toString() {
    var encoder = const JsonEncoder.withIndent('  ');
    final descption = encoder.convert(toJson());
    return "$runtimeType: $descption";
  }
}

/// 导航监听
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute is PageRoute) {
      AppNavigator._routePre = previousRoute.settings;
    }
    if (route is PageRoute) {
      AppNavigator._route = route.settings;
      AppNavigator._pageRoutes.add(route);
    }

    if (AppNavigator.isLog) {
      DLog.d([route.settings.name, previousRoute?.settings.name, AppNavigator()].asMap());
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // DLog.d(["didPop", route.settings, previousRoute?.settings].asMap());
    if (previousRoute is PageRoute) {
      AppNavigator._route = previousRoute.settings;
    }

    if (route is PageRoute) {
      AppNavigator._routePre = route.settings;
      AppNavigator._pageRoutes.remove(route);
    }

    if (AppNavigator.isLog) {
      DLog.d([route.settings.name, previousRoute?.settings.name, AppNavigator()].asMap());
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // DLog.d(["didReplace", newRoute?.settings, oldRoute?.settings].asMap());
    if (oldRoute is PageRoute) {
      AppNavigator._routePre = oldRoute.settings;
      AppNavigator._pageRoutes.remove(oldRoute);
    }

    if (newRoute is PageRoute) {
      AppNavigator._route = newRoute.settings;
      AppNavigator._pageRoutes.add(newRoute);
    }

    if (AppNavigator.isLog) {
      DLog.d([newRoute?.settings.name, oldRoute?.settings.name, AppNavigator()].asMap());
    }
  }
}
