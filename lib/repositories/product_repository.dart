import '../models/product.dart';
import '../database/tables/product_table.dart';

class ProductRepository {
  Future<List<Product>> fetchAll() => ProductTable.getAll();
  Future<int> insert(Product product) => ProductTable.insert(product);
  Future<int> update(Product product) => ProductTable.update(product);
  Future<int> delete(int id) => ProductTable.delete(id);
  Future<Product?> fetchById(int id) => ProductTable.getById(id);

}
