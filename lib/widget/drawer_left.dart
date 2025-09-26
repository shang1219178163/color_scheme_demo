import 'package:flutter/material.dart';

class DrawerLeft extends StatefulWidget {
  const DrawerLeft({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<DrawerLeft> createState() => _DrawerLeftState();
}

class _DrawerLeftState extends State<DrawerLeft> {
  @override
  void didUpdateWidget(covariant DrawerLeft oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // const UserAccountsDrawerHeader(
          //   accountName: Text('用户名'),
          //   accountEmail: Text('user@example.com'),
          //   currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          // ),
          const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Text('Drawer Header')),
          ListTile(leading: const Icon(Icons.home), title: const Text('首页'), onTap: () {}),
          ListTile(leading: const Icon(Icons.settings), title: const Text('设置'), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.info), title: const Text('关于'), onTap: () {}),
        ],
      ),
    );
  }
}
