import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AndroidBridge.goBack(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              '页面未找到',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('抱歉，您访问的页面不存在'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => AndroidBridge.goBack(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回 Android'),
            ),
          ],
        ),
      ),
    );
  }
}