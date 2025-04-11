import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/user.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<String> _saveImageToPermanentStorage(XFile pickedImage) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'employee_$timestamp.jpg';
      final permanentPath = '${directory.path}/$fileName';
      final File sourceFile = File(pickedImage.path);
      final File destinationFile = await sourceFile.copy(permanentPath);
      return permanentPath;
    } catch (e) {
      print('Error saving image: $e');
      return '';
    }
  }

  void _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        if (await Permission.camera.request() != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera permission denied')),
          );
          return;
        }
      } else {
        if (await Permission.storage.request() != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
          return;
        }
      }

      final XFile? pickedImage = await _picker.pickImage(source: source);

      if (pickedImage != null) {
        final String savedPath = await _saveImageToPermanentStorage(pickedImage);
        if (savedPath.isNotEmpty) {
          setState(() {
            _image = XFile(savedPath);
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Choose Photo', style: TextStyle(color: colorScheme.onSurface)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt, color: colorScheme.primary),
                              title: const Text('Take Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library, color: colorScheme.primary),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: colorScheme.primaryContainer,
                          backgroundImage: _image != null
                              ? FileImage(File(_image!.path))
                              : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primary,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
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
                        controller: _roleController,
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
                        controller: _passwordController,
                        obscureText: _obscurePassword,
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
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: colorScheme.primary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty) ? "Enter password" : null,
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
                        onPressed: () {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
