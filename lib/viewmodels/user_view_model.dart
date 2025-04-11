import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  List<User> _users = [];
  List<User> get users => _users;

   Future<void> loadUsers() async {
    _users = await _repository.fetchAll();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    final insertedId = await _repository.insert(user);
    final newUser = await _repository.fetchById(insertedId);
    if (newUser != null) {
      _users.insert(0, newUser); // Add to top of the list
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    await _repository.delete(id);
    _users.removeWhere((u) => u.id == id);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    final updated = await _repository.update(user);
    if (updated > 0) {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    }
  }

  Future<User?> getUserByEmail(String email) async {
    return await _repository.getByEmail(email);
  }
}
