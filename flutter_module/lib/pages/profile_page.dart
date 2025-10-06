import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        backgroundColor: Colors.green.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AndroidBridge.goBack(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('邮箱'),
                subtitle: Text('user@example.com'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text('电话'),
                subtitle: Text('+86 138 0000 0000'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text('地址'),
                subtitle: Text('北京市朝阳区'),
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