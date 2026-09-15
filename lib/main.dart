import 'package:flutter/material.dart';
import 'domain/product_list_controller.dart';
import 'data/sources/product_api_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'view/screens/product_list_screen.dart';
import 'view/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const ProductCatalogApp(),
    ));
}

class ProductCatalogApp extends StatelessWidget {
  const ProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProductRepositoryImpl(ProductApiDataSource());
    final controller = ProductListController(repository);

    return MaterialApp(
      title: 'Product Catalog',
      theme: AppTheme.light(),
      home: ProductListScreen(controller: controller),
      debugShowCheckedModeBanner: false,
    );
  }
}