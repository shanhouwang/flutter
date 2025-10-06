import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';
import '../models/product.dart';
import 'not_found_page.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product?;
    
    if (product == null) {
      return const NotFoundPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.indigo.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                product.icon,
                size: 120,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              product.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              product.price,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '产品描述',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '这是一款优秀的产品，具有出色的性能和设计。适合日常使用，性价比很高。',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已添加到购物车')),
                      );
                    },
                    child: const Text('加入购物车'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => AndroidBridge.goBack(),
                    child: const Text('返回 Android'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}