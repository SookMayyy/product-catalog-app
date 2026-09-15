import 'package:flutter/material.dart';
import '../../domain/product_detail_controller.dart';
import '../../domain/view_state.dart';
import '../../data/sources/product_api_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> { 
  late final ProductDetailController _controller;

  @override
  void initState() { 
    super.initState();
    final repository = ProductRepositoryImpl(ProductApiDataSource());
    _controller = ProductDetailController(repository, widget.productId);
    _controller.loadProduct();
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          switch (_controller.status) {
            case ViewStatus.initial:
            case ViewStatus.loading:
              return const LoadingView();

            case ViewStatus.error:
              return ErrorView(
                message: _controller.errorMessage,
                onRetry: _controller.retry,
              );

            case ViewStatus.empty:
            case ViewStatus.success:
              final product = _controller.product;
              if (product == null) return const LoadingView();

              final imageUrls =
                  product.images.isEmpty ? [product.thumbnail] : product.images; // fallback to thumbnail if images are empty

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrls[index],
                              width: 220,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  width: 220,
                                  color: Colors.grey.shade200,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                width: 220,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(product.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(product.rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(product.description),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}