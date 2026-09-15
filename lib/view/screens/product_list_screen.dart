import 'package:flutter/material.dart';
import '../../domain/product_list_controller.dart';
import '../../domain/view_state.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/empty_view.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final ProductListController controller;

  const ProductListScreen({super.key, required this.controller});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.loadInitial();
    widget.controller.loadCategories();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final nearBottom = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (nearBottom) {
      widget.controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: Column(
        children: [
          SearchBarWidget(onChanged: widget.controller.onSearchChanged),
          
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) => CategoryFilterBar(
              categories: widget.controller.categories,
              selectedCategory: widget.controller.selectedCategory,
              onSelected: widget.controller.filterByCategory,
            ),
          ),
          
          Expanded(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                switch (widget.controller.status) {
                  case ViewStatus.initial:
                  case ViewStatus.loading:
                    return const LoadingView();

                  case ViewStatus.error:
                    return ErrorView(
                      message: widget.controller.errorMessage,
                      onRetry: widget.controller.retry,
                    );

                  case ViewStatus.empty:
                    return const EmptyView();

                  case ViewStatus.success:
                    final products = widget.controller.products;
                    return RefreshIndicator(
                      onRefresh: widget.controller.loadInitial,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            products.length + (widget.controller.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= products.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(productId: product.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}