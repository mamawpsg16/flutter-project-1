// add_user_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_picture_picker.dart';
import 'user_form.dart';
import '../../../models/user.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  XFile? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _onImagePicked(XFile? image) {
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: const Text('Add Employee'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                ProfilePicturePicker(onImagePicked: _onImagePicked),
                const SizedBox(height: 32),
                UserForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  roleController: _roleController,
                  passwordController: _passwordController,
                  obscurePassword: _obscurePassword,
                  onToggleObscurePassword: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  onSave: () {
                    if (_formKey.currentState!.validate()) {
                      final newUser = User(
                        email: _emailController.text,
                        password: _passwordController.text,
                        role: _roleController.text,
                        image: _image?.path,
                      );
                      userVM.addUser(newUser);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
