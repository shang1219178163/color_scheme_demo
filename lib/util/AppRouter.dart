import 'package:color_scheme_demo/page/MorePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:color_scheme_demo/page/RestorationMixinDemo.dart';
import 'package:color_scheme_demo/page/HomePage.dart';
import 'package:color_scheme_demo/page/HomePageOne.dart';
import 'package:color_scheme_demo/page/HomePageTwo.dart';
import 'package:color_scheme_demo/page/NotFoundPage.dart';

export 'AppNavigator.dart';

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

  static Map<String, WidgetBuilder> routeMap = Map<String, WidgetBuilder>.fromEntries(
    routes.map((e) => MapEntry<String, WidgetBuilder>(e.name, e.page)),
  );

  static final List<AppPage> routes = [
    AppPage(
      name: AppRouter.notFoundPage,
      page: (context) => NotFoundPage(),
    ),
    AppPage(
      name: AppRouter.homePage,
      page: (context) => HomePage(),
    ),
    AppPage(
      name: AppRouter.homePageOne,
      page: (context) => HomePageOne(),
    ),
    AppPage(
      name: AppRouter.homePageTwo,
      page: (context) => HomePageTwo(),
    ),
    AppPage(
      name: AppRouter.restorationMixinDemo,
      page: (context) => RestorationMixinDemo(),
    ),
    AppPage(
      name: AppRouter.detailPage,
      page: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
        return MorePage(
          id: args['id'],
          arguments: args,
        );
      },
    ),
  ];
}
