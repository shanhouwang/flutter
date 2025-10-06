import 'package:flutter/material.dart';
import '../utils/android_bridge.dart';
import '../models/product.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(name: 'iPhone 15', price: '¥5999', icon: Icons.phone_iphone),
      Product(name: 'MacBook Pro', price: '¥12999', icon: Icons.laptop_mac),
      Product(name: 'iPad Air', price: '¥4599', icon: Icons.tablet_mac),
      Product(name: 'Apple Watch', price: '¥2999', icon: Icons.watch),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品列表'),
        backgroundColor: Colors.purple.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AndroidBridge.goBack(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: Icon(
                        product.icon,
                        color: Colors.purple,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text(product.price),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: product,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => AndroidBridge.goBack(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回 Android'),
            ),
          ),
        ],
      ),
    );
  }
}