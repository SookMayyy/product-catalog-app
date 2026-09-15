import '../models/product.dart';
import '../models/category.dart';

abstract class ProductRepository { 
  Future<List<Product>> getProducts({ 
    required int limit,
    required int skip,
  });

  Future<List<Product>> searchProducts(String query);

  Future<Product> getProductById(int id);

  Future<List<Category>> getCategories();

  Future <List<Product>> getProductsByCategory({
    required String category,
    required int limit,
    required int skip,
  });
}