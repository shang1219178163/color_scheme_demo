import 'package:flutter/material.dart';

class SheetUtil {
  /// 展示自定义UI
  static Future showCustom({
    required BuildContext context,
    Widget? topControl,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xff181829) : Colors.white;
    final barrierColor = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.1);
    final borderColor = isDark ? Colors.black : Colors.white;

    final titleColor = isDark ? Colors.white : Color(0xff313135);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.8) : Color(0xff7C7C85);

    return showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      barrierColor: barrierColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      elevation: 0,
      builder: (context) {
        return Scrollbar(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 500,
              minHeight: 200,
            ),
            child: SingleChildScrollView(
              child: Material(
                color: backgroundColor,
                // elevation: 0,
                // shadowColor: backgroundColor,
                // shape: RoundedRectangleBorder(
                //   side: BorderSide(color: Colors.red),
                // ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  // BottomSheetHelper.showBottomMenu(
  //   context: context,
  //   items: [
  //     (
  //       title: "即时",
  //       onTap: () {},
  //     ),
  //     (
  //       title: "赛前",
  //       onTap: () {},
  //     ),
  //   ],
  // );
  /// 显示选择菜单
  static Future showBottomMenu({
    required BuildContext context,
    required List<({String title, VoidCallback onTap})> items,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Color(0xff181829) : Color(0xffF6F6F6);
    final cardColor = isDark ? Color(0xff242434) : Colors.white;

    final titleColor = isDark ? Colors.white : Color(0xff313135);
    final subtitleColor = isDark ? Colors.white.withOpacity(0.6) : Color(0xff7C7C85);
    final cancelColor = Color(0xffE44554);

    return showCustom(
      context: context,
      topControl: const SizedBox(),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map((e) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  e.onTap();
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 1),
                  decoration: BoxDecoration(
                    color: cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(fontSize: 14, color: titleColor),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 8),
            GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: cardColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  "取消",
                  style: TextStyle(fontSize: 14, color: titleColor),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
