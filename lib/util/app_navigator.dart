import 'dart:convert';

import 'package:color_scheme_demo/page/unknown_page.dart';
import 'package:flutter/material.dart';
import 'app_router.dart';

export 'dlog.dart';

/// 路由管理（API 对齐 GetX 导航契约）
class AppNavigator {
  static bool isLog = false;

  /// 全局 NavigatorKey
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// 当前 Navigator
  static NavigatorState get navigator => navigatorKey.currentState!;

  /// 未知页面
  static WidgetBuilder unknownPageBuilder = (context) => const UnknownPage();

  static Map<String, WidgetBuilder> get routeMap => AppRouter.routeMap;

  static final List<PageRoute<Object?>> _pageRoutes = [];
  static List<PageRoute<Object?>> get pageRoutes => _pageRoutes;

  static List<String?> get pageRouteNames => pageRoutes.map((e) => e.settings.name).toList();

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

  /// 类似 Get.arguments
  static Object? get arguments => route?.arguments;

  /// 类似 Get.currentRoute / Get.routing.current
  static String? get routeName => route?.name;
  static String get currentRoute => routeName ?? '';

  /// 类似 Get.parameters（从当前路由 URI query 解析）
  static Map<String, String> get parameters {
    final name = routeName;
    if (name == null || name.isEmpty) return const {};
    return Uri.tryParse(name)?.queryParameters ?? const {};
  }

  /// 监听列表
  static final List<void Function({Route? from, Route? to})> _listeners = [];

  // 添加监听
  static void addListener(void Function({Route? from, Route? to}) cb) {
    if (_listeners.contains(cb)) {
      return;
    }
    _listeners.add(cb);
  }

  // 移除监听
  static void removeListener(void Function({Route? from, Route? to}) cb) {
    _listeners.remove(cb);
  }

  /// 通知所有监听器
  static void notifyListeners({required Route? from, required Route? to}) {
    for (var ltr in _listeners) {
      ltr(from: from, to: to);
    }
  }

  /// 将 GetX 风格 parameters 拼进路由 URI
  static String _withParameters(String page, Map<String, String>? parameters) {
    if (parameters == null || parameters.isEmpty) return page;
    final uri = Uri.tryParse(page);
    if (uri == null) {
      return Uri(path: page, queryParameters: parameters).toString();
    }
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...parameters,
    }).toString();
  }

  /// 路由表查找只用 path，忽略 query
  static String _routePath(String page) {
    final uri = Uri.tryParse(page);
    if (uri == null || uri.path.isEmpty) return page;
    return uri.path;
  }

  static WidgetBuilder _builderFor(String page) {
    return routeMap[_routePath(page)] ?? unknownPageBuilder;
  }

  /// **Navigation.push()** shortcut.（对齐 Get.to）
  ///
  /// 使用 `AppNavigator.to(() => Page())`，不要直接传 Widget 实例。
  ///
  /// 若因 [preventDuplicates] 未跳转，返回已完成的 `Future.value(null)`（非 null Future）。
  static Future<T?> to<T>(
    Widget Function() page, {
    dynamic arguments,
    bool preventDuplicates = true,
    String? routeName,
    bool fullscreenDialog = false,
  }) {
    // page 是工厂函数，runtimeType 是 Closure；用调用结果取页面类型作默认路由名
    final widget = page();
    routeName ??= '/${widget.runtimeType}';
    if (!routeName.startsWith('/')) {
      routeName = '/$routeName';
    }
    if (preventDuplicates && routeName == currentRoute) {
      return Future<T?>.value(null);
    }
    return navigator.push<T>(
      MaterialPageRoute<T>(
        builder: (_) => widget,
        fullscreenDialog: fullscreenDialog,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    );
  }

  /// **Navigation.pushNamed()** shortcut.（对齐 Get.toNamed）
  static Future<T?> toNamed<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    page = _withParameters(page, parameters);
    if (preventDuplicates && _routePath(page) == _routePath(currentRoute)) {
      return Future<T?>.value(null);
    }
    return navigator.push<T>(
      MaterialPageRoute<T>(
        builder: _builderFor(page),
        settings: RouteSettings(name: page, arguments: arguments),
      ),
    );
  }

  /// **Navigation.pushReplacement()** shortcut.（对齐 Get.off）
  static Future<T?> off<T>(
    Widget Function() page, {
    dynamic arguments,
    bool preventDuplicates = true,
    String? routeName,
    bool fullscreenDialog = false,
  }) {
    final widget = page();
    routeName ??= '/${widget.runtimeType}';
    if (!routeName.startsWith('/')) {
      routeName = '/$routeName';
    }
    if (preventDuplicates && routeName == currentRoute) {
      return Future<T?>.value(null);
    }
    return navigator.pushReplacement<T, Object?>(
      MaterialPageRoute<T>(
        builder: (_) => widget,
        fullscreenDialog: fullscreenDialog,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
    );
  }

  /// **Navigation.pushReplacementNamed()** shortcut.（对齐 Get.offNamed）
  static Future<T?> offNamed<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) {
    page = _withParameters(page, parameters);
    if (preventDuplicates && _routePath(page) == _routePath(currentRoute)) {
      return Future<T?>.value(null);
    }
    return navigator.pushReplacement<T, Object?>(
      MaterialPageRoute<T>(
        builder: _builderFor(page),
        settings: RouteSettings(name: page, arguments: arguments),
      ),
    );
  }

  /// **Navigation.popUntil()** shortcut.（对齐 Get.until）
  static void until(RoutePredicate predicate) {
    navigator.popUntil(predicate);
  }

  /// **Navigation.pushAndRemoveUntil()** shortcut.（对齐 Get.offUntil）
  static Future<T?> offUntil<T>(
    Widget Function() page,
    RoutePredicate predicate, {
    Object? arguments,
    String? routeName,
  }) {
    final widget = page();
    routeName ??= '/${widget.runtimeType}';
    if (!routeName.startsWith('/')) {
      routeName = '/$routeName';
    }
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: (_) => widget,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
      predicate,
    );
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.（对齐 Get.offNamedUntil）
  static Future<T?> offNamedUntil<T>(
    String page,
    RoutePredicate predicate, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    page = _withParameters(page, parameters);
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: _builderFor(page),
        settings: RouteSettings(name: page, arguments: arguments),
      ),
      predicate,
    );
  }

  /// **Navigation.popAndPushNamed()** shortcut.（对齐 Get.offAndToNamed）
  static Future<T?> offAndToNamed<T>(
    String page, {
    dynamic arguments,
    dynamic result,
    Map<String, String>? parameters,
  }) {
    page = _withParameters(page, parameters);
    if (navigator.canPop()) {
      navigator.pop(result);
    }
    return navigator.push<T>(
      MaterialPageRoute<T>(
        builder: _builderFor(page),
        settings: RouteSettings(name: page, arguments: arguments),
      ),
    );
  }

  /// **Navigation.removeRoute()** shortcut.（对齐 Get.removeRoute(String name)）
  static void removeRoute(String name) {
    final path = _routePath(name);
    PageRoute<Object?>? target;
    for (var i = _pageRoutes.length - 1; i >= 0; i--) {
      final route = _pageRoutes[i];
      final routeName = route.settings.name;
      if (routeName == name || _routePath(routeName ?? '') == path) {
        target = route;
        break;
      }
    }
    if (target != null) {
      navigator.removeRoute(target);
      _pageRoutes.remove(target);
    }
  }

  /// **Navigation.pushAndRemoveUntil()** shortcut.（对齐 Get.offAll）
  static Future<T?> offAll<T>(
    Widget Function() page, {
    RoutePredicate? predicate,
    dynamic arguments,
    String? routeName,
    bool fullscreenDialog = false,
  }) {
    final widget = page();
    routeName ??= '/${widget.runtimeType}';
    if (!routeName.startsWith('/')) {
      routeName = '/$routeName';
    }
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: (_) => widget,
        fullscreenDialog: fullscreenDialog,
        settings: RouteSettings(name: routeName, arguments: arguments),
      ),
      predicate ?? (route) => false,
    );
  }

  /// **Navigation.pushNamedAndRemoveUntil()** shortcut.（对齐 Get.offAllNamed）
  static Future<T?> offAllNamed<T>(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    page = _withParameters(page, parameters);
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute<T>(
        builder: _builderFor(page),
        settings: RouteSettings(name: page, arguments: arguments),
      ),
      (route) => false,
    );
  }

  /// **Navigation.pop()** shortcut.（对齐 Get.back）
  ///
  /// - [result] 返回给上一个路由
  /// - [canPop] 为 true 时仅在 canPop 时 pop
  /// - [times] 连续返回次数（`Get.back(times: 2)`）
  static void back<T>({
    T? result,
    bool canPop = true,
    int times = 1,
  }) {
    if (times < 1) {
      times = 1;
    }
    if (times > 1) {
      // popUntil 先判断当前栈顶：需弹出 times 次后再停下
      var count = 0;
      navigator.popUntil((_) => ++count > times);
      return;
    }
    if (canPop) {
      if (navigator.canPop()) {
        navigator.pop(result);
      }
    } else {
      navigator.pop(result);
    }
  }

  /// 连续 pop [times] 次（经典 Get.close(times) 行为）。
  ///
  /// 新版 GetX 的 `close` 用于关闭 overlay；本项目无 overlay 栈，
  /// 因此保留该常用语义，内部等价于 `back(times: times)`。
  static void close(int times) {
    back(times: times);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageRoutes'] = pageRoutes.map((e) => e.toString()).toList();
    data['routeNames'] = pageRouteNames;
    data['settingsPre'] = routePre.toString();
    data['routeNamePre'] = routeNamePre;
    data['routeName'] = routeName;
    data['parameters'] = parameters;
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
      AppNavigator.notifyListeners(from: previousRoute, to: route);
    }

    if (AppNavigator.isLog) {
      DLog.d([route.settings.name, previousRoute?.settings.name, AppNavigator()].asMap());
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      AppNavigator._route = previousRoute.settings;
    }

    if (route is PageRoute) {
      AppNavigator._routePre = route.settings;
      AppNavigator._pageRoutes.remove(route);
      AppNavigator.notifyListeners(from: previousRoute, to: route);
    }

    if (AppNavigator.isLog) {
      DLog.d([route.settings.name, previousRoute?.settings.name, AppNavigator()].asMap());
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute is PageRoute) {
      AppNavigator._routePre = oldRoute.settings;
      AppNavigator._pageRoutes.remove(oldRoute);
    }

    if (newRoute is PageRoute) {
      AppNavigator._route = newRoute.settings;
      AppNavigator._pageRoutes.add(newRoute);
      AppNavigator.notifyListeners(from: oldRoute, to: newRoute);
    }

    if (AppNavigator.isLog) {
      DLog.d([newRoute?.settings.name, oldRoute?.settings.name, AppNavigator()].asMap());
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      AppNavigator._pageRoutes.remove(route);
    }
    if (previousRoute is PageRoute) {
      AppNavigator._route = previousRoute.settings;
    }
  }
}
