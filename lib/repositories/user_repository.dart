import '../models/user.dart';
import '../database/tables/user_table.dart';

class UserRepository {
  Future<List<User>> fetchAll() => UserTable.getAll();
  Future<int> insert(User user) => UserTable.insert(user);
  Future<User?> getByEmail(String email) => UserTable.getByEmail(email);
  Future<User?> fetchById(int id) => UserTable.getById(id); // Add this
  Future<int> update(User user) => UserTable.update(user); // Add this
  Future<int> delete(int id) => UserTable.delete(id); // Add this
}
