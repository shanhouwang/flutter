import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.orange.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AndroidBridge.goBack(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('推送通知'),
                subtitle: const Text('接收应用通知'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                secondary: const Icon(Icons.notifications),
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('深色模式'),
                subtitle: const Text('使用深色主题'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                secondary: const Icon(Icons.dark_mode),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text('语言'),
                subtitle: Text('简体中文'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('关于'),
                subtitle: Text('版本 1.0.0'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Spacer(),
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