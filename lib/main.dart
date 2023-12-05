import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart';

final _logger = Logger();

// 路由配置
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondPage(),
    ),
  ],
);

void main() {
  // 主方法启动app
  runApp(const MyApp());
}

// 主App是个无状态Widget
class MyApp extends StatelessWidget {
  // 构造函数，并且将参数传给父类构造
  const MyApp({super.key});

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 定义颜色
        useMaterial3: true, // 启用Material 3
      ),
      routerConfig: _router, // 路由配置
    );
  }
}

class MyHomePage extends StatefulWidget {
  // 构造方法，并且调用父类构造并传参
  const MyHomePage({super.key});

  // 覆写 createState 方法
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 不需要显式写构造方法

  // 自定义状态
  int _counter = 0;
  final int _currentIndex = 0; // 当前页面的索引，设置导航栏的active

  // 自定义的修改状态的方法
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  void initState() {
    super.initState();
    _logger.d('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.d('didChangeDependencies');
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.d('didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    _logger.d('deactivate');
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('dispose');
  }

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    _logger.d('build');
    return Scaffold(
      // 顶部栏
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      // 侧边栏
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: const Text('侧边菜单，Home'),
            selected: _currentIndex == 0, // active 状态
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            title: const Text('侧边菜单，Second'),
            selected: _currentIndex == 1,
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/second');
            },
          ),
        ]),
      ),
      // 内容部分
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中
          crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴居中
          children: [
            const Text('Home Page'),
            Text('$_counter'),
            ElevatedButton(
              onPressed: () {
                // 处理按钮按下事件
                _logger.d('button pressed');
              },
              child: const Text('Press Me'),
            ),
          ],
        ),
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // active 状态
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Second',
          ),
        ],
        onTap: (int index) {
          // 处理底部导航栏点击事件
          if (index == 0) {
            context.go('/');
          }
          if (index == 1) {
            context.go('/second');
          }
        },
      ),
      // 悬浮按钮
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton.extended是FloatingActionButton的一个扩展版本，它允许在浮动操作按钮上显示文本和图标，以提供更多的信息。
          FloatingActionButton.extended(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
            // 当我们在一个页面种使用两个FloatingActionButton却不覆写它们的heroTag属性，它们会默认使用同一个标识，以致于冲突报错。
            heroTag: 'Increment',
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _decrementCounter,
            icon: const Icon(Icons.remove),
            label: const Text('Decrement'),
            heroTag: 'DecrementR',
          )
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  final int _currentIndex = 1; // 当前页面的索引，设置导航栏的active

  // 覆写 build 方法
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部栏
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Second Page'),
      ),
      // 侧边栏
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: const Text('侧边菜单，Home'),
            selected: _currentIndex == 0, // active状态
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            title: const Text('侧边菜单，Second'),
            selected: _currentIndex == 1,
            onTap: () {
              // 处理侧边栏点击事件
              Navigator.pop(context);
              context.go('/second');
            },
          ),
        ]),
      ),
      // 内容部分
      body: const Text('Second Page'),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // active状态
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Second',
          ),
        ],
        onTap: (int index) {
          // 处理底部导航栏点击事件
          if (index == 0) {
            context.go('/');
          }
          if (index == 1) {
            context.go('/second');
          }
        },
      ),
    );
  }
}
