import '../models/product.dart';
import '../sources/product_api_source.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int skip,
  }) {
    return _dataSource.fetchProducts(limit: limit, skip: skip);
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return _dataSource.searchProducts(query);
  }

  @override
  Future<Product> getProductById(int id) {
    return _dataSource.fetchProductById(id);
  }
}