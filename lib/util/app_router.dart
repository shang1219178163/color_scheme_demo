import 'package:color_scheme_demo/page/more_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:color_scheme_demo/page/restoration_mixin_demo.dart';
import 'package:color_scheme_demo/page/home_page.dart';
import 'package:color_scheme_demo/page/home_page_one.dart';
import 'package:color_scheme_demo/page/home_page_two.dart';
import 'package:color_scheme_demo/page/unknown_page.dart';

import '../page/test_page.dart';

export 'app_navigator.dart';

/// 路由页面
class AppPage {
  AppPage({
    required this.name,
    required this.page,
  });

  final String name;

  final WidgetBuilder page;
}

/// 路由定义
class AppRouter {
  static const String initial = homePage;

  static const String notFoundPage = '/notFoundPage';
  static const String homePage = '/homePage';
  static const String homePageOne = '/homePageOne';
  static const String homePageTwo = '/homePageTwo';
  static const String restorationMixinDemo = '/restorationMixinDemo';
  static const String detailPage = '/detailPage';
  static const String morePage = '/morePage';
  static const String testPage = '/testPage';

  static Map<String, WidgetBuilder> routeMap = Map<String, WidgetBuilder>.fromEntries(
    routes.map((e) => MapEntry<String, WidgetBuilder>(e.name, e.page)),
  );

  static final List<AppPage> routes = [
    AppPage(
      name: AppRouter.notFoundPage,
      page: (context) => const UnknownPage(),
    ),
    AppPage(
      name: AppRouter.homePage,
      page: (context) => const HomePage(),
    ),
    AppPage(
      name: AppRouter.homePageOne,
      page: (context) => const HomePageOne(),
    ),
    AppPage(
      name: AppRouter.homePageTwo,
      page: (context) => const HomePageTwo(),
    ),
    AppPage(
      name: AppRouter.restorationMixinDemo,
      page: (context) => const RestorationMixinDemo(),
    ),
    AppPage(
      name: AppRouter.morePage,
      page: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? <String, dynamic>{};
        return MorePage(
          id: args['id'],
          arguments: args,
        );
      },
    ),
    AppPage(
      name: AppRouter.testPage,
      page: (context) => const TestPage(),
    ),
  ];
}
