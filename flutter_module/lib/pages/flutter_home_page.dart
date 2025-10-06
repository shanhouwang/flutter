import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/android_bridge.dart';

class FlutterHomePage extends StatefulWidget {
  const FlutterHomePage({super.key});

  @override
  State<FlutterHomePage> createState() => _FlutterHomePageState();
}

class _FlutterHomePageState extends State<FlutterHomePage> {
  int _visitCount = 0;
  String _message = "欢迎来到 Flutter 页面！";

  void _incrementVisit() {
    setState(() {
      _visitCount++;
      _message = "您已经访问了 $_visitCount 次";
    });
  }

  void _resetCounter() {
    setState(() {
      _visitCount = 0;
      _message = "计数器已重置";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 首页'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AndroidBridge.goBack(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  _message,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          '访问次数',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$_visitCount',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // 导航按钮
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                      icon: const Icon(Icons.person),
                      label: const Text('个人资料'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                      icon: const Icon(Icons.settings),
                      label: const Text('设置'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/products'),
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('商品列表'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _incrementVisit,
                      icon: const Icon(Icons.add),
                      label: const Text('增加'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _resetCounter,
                      icon: const Icon(Icons.refresh),
                      label: const Text('重置'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => AndroidBridge.goBack(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('返回 Android'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}