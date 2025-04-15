// user_form.dart
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController roleController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscurePassword;
  final VoidCallback onSave;
  final bool isEdit; // Flag to determine if it is an edit form

  const UserForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.roleController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscurePassword,
    required this.onSave,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              labelStyle: TextStyle(color: colorScheme.onSurface),
              prefixIcon: Icon(Icons.email, color: colorScheme.primary),
            ),
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter email" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: roleController,
            decoration: InputDecoration(
              labelText: "Role/Position",
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              labelStyle: TextStyle(color: colorScheme.onSurface),
              prefixIcon: Icon(Icons.assignment_ind, color: colorScheme.primary),
            ),
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter Role/Position" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              labelStyle: TextStyle(color: colorScheme.onSurface),
              prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.primary,
                ),
                onPressed: onToggleObscurePassword,
              ),
            ),
            validator: (value) =>
                (value == null || value.isEmpty && !isEdit) ? "Enter password" : null, // Password is not required for edit
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Employee"),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}
