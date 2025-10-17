import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 首页（带计数器和输入框）
class RestorationMixinDemo extends StatefulWidget {
  const RestorationMixinDemo({super.key});

  @override
  State<RestorationMixinDemo> createState() => _RestorationMixinDemoState();
}

class _RestorationMixinDemoState extends State<RestorationMixinDemo> with RestorationMixin {
  final RestorableInt _counter = RestorableInt(0);
  final RestorableTextEditingController _controller = RestorableTextEditingController();

  late final RestorableRouteFuture<void> _dialogRoute;
  late final RestorableRouteFuture<void> _detailRoute;

  @override
  String? get restorationId => '$this'; // 唯一标识符

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'counter');
    registerForRestoration(_controller, 'text');
    _dialogRoute = RestorableRouteFuture<void>(
      onPresent: (navigator, args) => navigator.restorablePush(_dialogBuilder),
    );
    _detailRoute = RestorableRouteFuture<void>(
      onPresent: (navigator, args) => navigator.restorablePush(_detailBuilder),
    );
    registerForRestoration(_dialogRoute, 'dialog');
    registerForRestoration(_detailRoute, 'detail');
  }

  static Route<void> _dialogBuilder(BuildContext context, Object? args) {
    return DialogRoute<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('状态恢复提示'),
        content: const Text('这个弹窗在 App 重启后仍会自动弹出。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  static Route<void> _detailBuilder(BuildContext context, Object? args) {
    return MaterialPageRoute<void>(
      builder: (_) => const DetailPage(),
      settings: const RouteSettings(name: 'detail_page'),
    );
  }

  void _increment() => setState(() => _counter.value++);

  @override
  void dispose() {
    _counter.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restoration 多页面示例')),
      body: ListView(
        restorationId: 'home_list', // 🌟 滚动位置自动恢复
        padding: const EdgeInsets.all(16),
        children: [
          // 计数器
          Card(
            child: ListTile(
              title: Text(
                '计数值：${_counter.value}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _increment,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 输入框
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller.value,
                decoration: const InputDecoration(
                  labelText: '输入框内容可恢复',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 跳转按钮
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward),
            label: const Text('进入详情页（状态可恢复）'),
            onPressed: _detailRoute.present,
          ),
          const SizedBox(height: 16),

          // 弹窗按钮
          ElevatedButton.icon(
            icon: const Icon(Icons.message_outlined),
            label: const Text('打开可恢复弹窗'),
            onPressed: _dialogRoute.present,
          ),
        ],
      ),
    );
  }
}

/// 详情页（独立状态）
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with RestorationMixin {
  final _count = RestorableInt(100);
  final _noteController = RestorableTextEditingController();

  @override
  String? get restorationId => '$this';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_count, 'count');
    registerForRestoration(_noteController, 'note');
  }

  @override
  void dispose() {
    _count.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _increment() => setState(() => _count.value++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('详情页 (Restoration 示例)')),
      body: ListView(
        restorationId: 'detail_list',
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(
                '详情计数：${_count.value}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _noteController.value,
                decoration: const InputDecoration(
                  labelText: '备注内容（可恢复）',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回首页'),
          ),
        ],
      ),
    );
  }
}
