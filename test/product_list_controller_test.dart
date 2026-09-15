import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_app/domain/product_list_controller.dart';
import 'package:product_catalog_app/domain/view_state.dart';
import 'package:product_catalog_app/data/models/product.dart';
import 'package:product_catalog_app/data/models/category.dart';
import 'package:product_catalog_app/data/repositories/product_repository.dart';

class FakeProductRepository implements ProductRepository { 
  final List<Product> productsToReturn;
  final bool throwError;

  FakeProductRepository({
    this.productsToReturn = const [], 
    this.throwError = false
  });

  @override
  Future<List<Product>> getProducts({
    required int limit, 
    required int skip
  }) async {
    if (throwError) throw Exception('fake network error');
    return productsToReturn;
}

  @override
  Future<List<Product>> searchProducts(String query) async { 
    if (throwError) throw Exception('fake network error');
    return productsToReturn
      .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
  }

  @override
  Future<Product> getProductById(int id) async { 
    throw UnimplementedError('not needed for these tests');
  }

  @override
  Future<List<Category>> getCategories() async {
    return const [];
  }

  @override
  Future<List<Product>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  }) async {
    if (throwError) throw Exception('fake network error');
    return productsToReturn.where((p) => p.category == category).toList();
  }
}

Product _makeProduct(int id, String title, {String category = 'test-category'}) => Product( 
  id: id,
  title: title,
  description: 'A test product',
  price: 9.99,
  rating: 4.5,
  thumbnail: 'https://example.com/thumbnail.jpg',
  images: const [],
  category: category,
);

void main() {
  group('ProductListController', () {
    test('loadInitial() sets status to success and stores products', () async {
      final repo = FakeProductRepository(
        productsToReturn: [_makeProduct(1, 'Phone'), _makeProduct(2, 'Laptop')],
      );
      final controller = ProductListController(repo);

      await controller.loadInitial();

      expect(controller.status, ViewStatus.success);
      expect(controller.products.length, 2);
    });

    test('loadInitial() sets status to empty when repository returns nothing', () async {
      final repo = FakeProductRepository(productsToReturn: []);
      final controller = ProductListController(repo);

      await controller.loadInitial();

      expect(controller.status, ViewStatus.empty);
      expect(controller.products, isEmpty);
    });

    test('loadInitial() sets status to error when repository throws', () async {
      final repo = FakeProductRepository(throwError: true);
      final controller = ProductListController(repo);

      await controller.loadInitial();

      expect(controller.status, ViewStatus.error);
    });

    test('filterByCategory() fetches only products in that category', () async {
      final repo = FakeProductRepository(
        productsToReturn: [
          _makeProduct(1, 'Lipstick', category: 'beauty'),
          _makeProduct(2, 'Laptop', category: 'laptops'),
        ],
      );
      final controller = ProductListController(repo);

      controller.filterByCategory('beauty');
      await Future.delayed(Duration.zero); // let the async loadInitial() finish

      expect(controller.status, ViewStatus.success);
      expect(controller.products.length, 1);
      expect(controller.products.first.title, 'Lipstick');
    });
  });
}