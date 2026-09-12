import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Center(child: Text('Product #$productId — coming in Phase 9')),
    );
  }
}