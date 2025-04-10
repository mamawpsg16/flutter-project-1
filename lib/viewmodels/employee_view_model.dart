import 'package:flutter/foundation.dart';
import '../models/employee.dart';

class EmployeeViewModel extends ChangeNotifier {
  final List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  // Add a default image path
  final String defaultImagePath = 'assets/images/default_profile.png';

  void addEmployee(String name, String role, String? profileImage) {
    final newEmployee = Employee(
      id: _employees.length + 1,
      name: name,
      role: role,
      profileImage: profileImage ?? defaultImagePath,
    );

    _employees.add(newEmployee);

    notifyListeners();
  }

  // Update Employee method
  void updateEmployee(int id, String name, String role, String? profileImage) {
    // Find the employee by id
    final employeeIndex = _employees.indexWhere((employee) => employee.id == id);

    if (employeeIndex != -1) {
      final updatedEmployee = Employee(
        id: id,
        name: name,
        role: role,
        profileImage: profileImage ?? _employees[employeeIndex].profileImage,
      );

      // Replace the old employee with the updated one
      _employees[employeeIndex] = updatedEmployee;

      // Notify listeners to update the UI
      notifyListeners();
    }
  }
}
