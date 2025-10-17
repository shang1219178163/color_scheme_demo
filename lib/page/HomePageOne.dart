import 'package:color_scheme_demo/util/AppThemeService.dart';
import 'package:flutter/material.dart';

import '../widget/seed_color_box.dart';

class HomePageOne extends StatefulWidget {
  const HomePageOne({super.key});

  @override
  State<HomePageOne> createState() => _HomePageOneState();
}

class _HomePageOneState extends State<HomePageOne> with TickerProviderStateMixin, SeedColorMixin {
  int _selectedIndex = 0;
  bool _isChecked = true;
  bool _isSwitched = true;
  double _sliderValue = 50;
  double _rangeStart = 20;
  double _rangeEnd = 80;
  int _radioValue = 1;
  int _selectedChip = 0;
  String _selectedOption = '选项1';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _currentPage = 0;

  late final _tabController = TabController(length: 3, vsync: this);
  final _pageController = PageController();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // useMaterial3: false,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onPrimary,
          foregroundColor: colorScheme.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          toolbarTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          actionsIconTheme: IconThemeData(
            size: 24.0, // 图标大小
            opacity: 0.8, // 图标透明度
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Material 3 组件全集'),
          actions: [],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '基础组件'),
              Tab(text: '导航组件'),
              Tab(text: '输入组件'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBasicComponents(colorScheme),
            _buildNavigationComponents(colorScheme),
            _buildInputComponents(colorScheme),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: '首页'),
            NavigationDestination(icon: Icon(Icons.search), label: '搜索'),
            NavigationDestination(icon: Icon(Icons.favorite), label: '收藏'),
            NavigationDestination(icon: Icon(Icons.person), label: '个人'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        drawer: _buildDrawer(colorScheme),
      ),
    );
  }

  Widget _buildBasicComponents(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SeedColorBox(
            onColorChanged: (v) {
              setState(() {});
              debugPrint("onColorChanged $v");
            },
            onBrightnessChanged: (v) {
              setState(() {});
              debugPrint("onBrightnessChanged $v");
            },
          ),
          // 按钮组
          _buildSectionTitle('按钮'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              FilledButton.tonal(onPressed: () {}, child: const Text('Tonal')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text')),
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
              FloatingActionButton.small(onPressed: () {}, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 16),

          // 卡片
          _buildSectionTitle('卡片'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.album, color: colorScheme.primary),
                    title: const Text('卡片标题'),
                    subtitle: const Text('这是一个支持操作的卡片'),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(onPressed: () {}, child: const Text('取消')),
                      FilledButton(onPressed: () {}, child: const Text('确定')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 芯片
          _buildSectionTitle('芯片'),
          Wrap(
            spacing: 8,
            children: [
              InputChip(
                label: const Text('输入芯片'),
                onPressed: () {},
              ),
              FilterChip(
                label: const Text('筛选芯片'),
                selected: _selectedChip == 0,
                onSelected: (selected) => setState(() => _selectedChip = selected ? 0 : -1),
              ),
              ActionChip(
                label: const Text('操作芯片'),
                onPressed: () {},
              ),
              ChoiceChip(
                label: const Text('选择芯片'),
                selected: _selectedChip == 1,
                onSelected: (selected) => setState(() => _selectedChip = selected ? 1 : -1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 进度指示器
          _buildSectionTitle('进度指示器'),
          LinearProgressIndicator(value: _sliderValue / 100),
          const SizedBox(height: 8),
          CircularProgressIndicator(value: _sliderValue / 100),
          const SizedBox(height: 16),

          // 对话框示例区域
          _buildSectionTitle('对话框'),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => _showAlertDialog(context),
                child: const Text('警告对话框'),
              ),
              OutlinedButton(
                onPressed: () => _showSimpleDialog(context),
                child: const Text('选择对话框'),
              ),
              TextButton(
                onPressed: () => _showModalBottomSheet(context),
                child: const Text('底部面板'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationComponents(ColorScheme colorScheme) {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用栏类型
            _buildSectionTitle('应用栏类型'),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _showAppBarDemo(context, 'small'),
                  child: const Text('小应用栏'),
                ),
                FilledButton(
                  onPressed: () => _showAppBarDemo(context, 'medium'),
                  child: const Text('中应用栏'),
                ),
                FilledButton(
                  onPressed: () => _showAppBarDemo(context, 'large'),
                  child: const Text('大应用栏'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 导航栏
            _buildSectionTitle('导航栏'),
            NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.explore), label: '探索'),
                NavigationDestination(icon: Icon(Icons.commute), label: '通勤'),
                NavigationDestination(icon: Icon(Icons.bookmark), label: '书签'),
              ],
            ),
            const SizedBox(height: 16),

            // 导航抽屉
            _buildSectionTitle('导航抽屉'),
            FilledButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Text('打开抽屉'),
            ),
            const SizedBox(height: 16),

            // 分页指示器
            _buildSectionTitle('分页指示器'),
            SizedBox(
              height: 200,
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  Container(color: colorScheme.primaryContainer, child: const Center(child: Text('页面 1'))),
                  Container(color: colorScheme.secondaryContainer, child: const Center(child: Text('页面 2'))),
                  Container(color: colorScheme.tertiaryContainer, child: const Center(child: Text('页面 3'))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 0
                      ? () =>
                          _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)
                      : null,
                ),
                Text('${_currentPage + 1} / 3'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < 2
                      ? () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 标签栏
            // _buildSectionTitle('标签栏'),
            // TabBar(
            //   tabs: const [
            //     Tab(text: '标签1'),
            //     Tab(text: '标签2'),
            //     Tab(text: '标签3'),
            //   ],
            // ),
            const SizedBox(height: 16),

            // 面包屑导航
            _buildSectionTitle('面包屑导航'),
            Wrap(
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('首页'),
                ),
                const Icon(Icons.chevron_right),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('分类'),
                ),
                const Icon(Icons.chevron_right),
                const Text('详情', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputComponents(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 文本输入
          _buildSectionTitle('文本输入'),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: '普通输入框',
              hintText: '请输入内容',
              prefixIcon: Icon(Icons.text_fields),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: '密码输入框',
              hintText: '请输入密码',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: '多行文本',
              hintText: '请输入多行内容',
              prefixIcon: Icon(Icons.subject),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // 选择控件
          _buildSectionTitle('选择控件'),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) => setState(() => _isChecked = value!),
              ),
              const Text('复选框'),
              const SizedBox(width: 20),
              Switch(
                value: _isSwitched,
                onChanged: (value) => setState(() => _isSwitched = value),
              ),
              const Text('开关'),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            children: [
              Radio<int>(
                value: 1,
                groupValue: _radioValue,
                onChanged: (value) => setState(() => _radioValue = value!),
              ),
              const Text('选项1'),
              Radio<int>(
                value: 2,
                groupValue: _radioValue,
                onChanged: (value) => setState(() => _radioValue = value!),
              ),
              const Text('选项2'),
              Radio<int>(
                value: 3,
                groupValue: _radioValue,
                onChanged: (value) => setState(() => _radioValue = value!),
              ),
              const Text('选项3'),
            ],
          ),
          const SizedBox(height: 16),

          // 滑块
          _buildSectionTitle('滑块'),
          Text('单滑块: ${_sliderValue.round()}'),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _sliderValue = value),
          ),
          const SizedBox(height: 12),
          Text('范围滑块: ${_rangeStart.round()} - ${_rangeEnd.round()}'),
          RangeSlider(
            values: RangeValues(_rangeStart, _rangeEnd),
            min: 0,
            max: 100,
            onChanged: (values) => setState(() {
              _rangeStart = values.start;
              _rangeEnd = values.end;
            }),
          ),
          const SizedBox(height: 16),

          // 选择器
          _buildSectionTitle('选择器'),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: () => _showDatePicker(context),
                child: const Text('日期选择器'),
              ),
              FilledButton(
                onPressed: () => _showTimePicker(context),
                child: const Text('时间选择器'),
              ),
              FilledButton(
                onPressed: showSeedColorPicker,
                child: const Text('颜色选择器'),
              ),
            ],
          ),
          if (_selectedDate != null) Text('选择日期: ${_selectedDate!.toLocal()}'),
          if (_selectedTime != null) Text('选择时间: ${_selectedTime!.format(context)}'),
          const SizedBox(height: 16),

          // 下拉选择
          _buildSectionTitle('下拉选择'),
          DropdownButton<String>(
            value: _selectedOption,
            items: const [
              DropdownMenuItem(value: '选项1', child: Text('选项1')),
              DropdownMenuItem(value: '选项2', child: Text('选项2')),
              DropdownMenuItem(value: '选项3', child: Text('选项3')),
            ],
            onChanged: (value) => setState(() => _selectedOption = value!),
          ),
          const SizedBox(height: 16),

          // 搜索框
          _buildSectionTitle('搜索框'),
          SearchBar(
            hintText: '搜索...',
            onTap: () {},
            trailing: const [Icon(Icons.search)],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDrawer(ColorScheme colorScheme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: const Text(
              '导航菜单',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首页'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('设置'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('帮助'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('退出'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('警告'),
        content: const Text('这是一个警告对话框示例。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择选项'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('选择了选项1')),
              );
            },
            child: const Text('选项1'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('选择了选项2')),
              );
            },
            child: const Text('选项2'),
          ),
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('底部面板内容'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppBarDemo(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Scaffold(
          appBar: type == 'small'
              ? AppBar(title: const Text('小应用栏'))
              : type == 'medium'
                  ? AppBar(
                      title: const Text('中应用栏'),
                      flexibleSpace: const Placeholder(), // 模拟中等高度
                    )
                  : AppBar(
                      title: const Text('大应用栏'),
                      // expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ColoredBox(color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                    ),
          body: const Center(child: Text('应用栏演示')),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }
}
