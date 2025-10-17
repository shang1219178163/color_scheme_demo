import 'package:flutter/material.dart';
import 'AppRouter.dart';

export 'dlog.dart';

/// 路由管理
class AppNavigator {
  static final AppNavigator _instance = AppNavigator._();
  AppNavigator._();
  factory AppNavigator() => _instance;
  static AppNavigator get instance => _instance;

  /// 全局 NavigatorKey
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 当前 Navigator
  static NavigatorState get navigator => navigatorKey.currentState!;

  static Map<String, WidgetBuilder> get routeMap => AppRouter.routeMap;

  /// 之前路由页面
  static RouteSettings? _settingsPre;

  /// 之前路由页面
  static RouteSettings? get settingsPre => _settingsPre;

  /// 当前路由页面
  static RouteSettings? _settings;

  /// 当前路由页面
  static RouteSettings? get settings => _settings;

  static Object? get argumentsPre => settingsPre?.arguments ?? {};
  static String? get routeNamePre => settingsPre?.name;

  static Object? get arguments => settings?.arguments ?? {};
  static String? get routeName => settings?.name;

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
}

/// 导航监听
class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is! PopupRoute) {
      AppNavigator._settingsPre = previousRoute?.settings;
      AppNavigator._settings = route.settings;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    AppNavigator._settingsPre = previousRoute?.settings;
    AppNavigator._settings = route.settings;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    AppNavigator._settingsPre = oldRoute?.settings;
    AppNavigator._settings = newRoute?.settings;
  }
}
