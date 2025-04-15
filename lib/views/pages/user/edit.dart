// edit_user_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_picture_picker.dart';
import 'user_form.dart';
import '../../../models/user.dart';

class EditUserView extends StatefulWidget {
  final dynamic user;

  const EditUserView({super.key, required this.user});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  XFile? _image;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email ?? '';
    _roleController.text = widget.user.role ?? '';
    _passwordController.text = widget.user.password ?? '';
    _image = widget.user.image != null ? XFile(widget.user.image) : null;
    _isActive = widget.user.isActive; // default to true if null
  }

  @override
  void dispose() {
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
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
        title: const Text('Edit User'),
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
                ProfilePicturePicker(
                  onImagePicked: _onImagePicked,
                  initialImage: _image,
                ),
                const SizedBox(height: 32),
                SwitchListTile(
                  title: Text(
                    'Active',
                    style: TextStyle(
                      color: colorScheme.onSurface, // Maintain color
                    ),
                  ),
                  value: _isActive,
                  activeColor: colorScheme.primary, // Maintain color
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                UserForm(
                  isEdit: true,
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
                      final updatedUser = User(
                        id: widget.user.id, // Important: Pass the existing user ID
                        email: _emailController.text,
                        password: _passwordController.text,
                        role: _roleController.text,
                        image: _image?.path,
                        isActive: _isActive,
                      );
                      userVM.updateUser(updatedUser);
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
