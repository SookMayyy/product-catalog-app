import '../models/product.dart';

abstract class ProductRepository { 
  Future<List<Product>> getProducts({ 
    required int limit,
    required int skip,
  });

  Future<List<Product>> searchProducts(String query);

  Future<Product> getProductById(int id);
}