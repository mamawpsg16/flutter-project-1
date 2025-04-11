import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class EditUserView extends StatefulWidget {
  final dynamic user;

  const EditUserView({super.key, required this.user});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  // final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
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
    // _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String> _saveImageToPermanentStorage(XFile pickedImage) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'user_$timestamp.jpg';
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
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Edit Photo', style: TextStyle(color: colorScheme.onSurface)),
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
                          border: Border.all(color: colorScheme.primary, width: 3),
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
                        child: Icon(Icons.camera_alt, size: 18, color: colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // TextFormField(
                      //   controller: _nameController,
                      //   decoration: InputDecoration(
                      //     labelText: "Name",
                      //     border: const OutlineInputBorder(),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      //     ),
                      //     labelStyle: TextStyle(color: colorScheme.onSurface),
                      //     prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                      //   ),
                      //   validator: (value) => value == null || value.isEmpty ? "Enter name" : null,
                      // ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isActive ? Icons.check_circle : Icons.cancel,
                                color: _isActive ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  color: _isActive ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isActive,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
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
                        validator: (value) => value == null || value.isEmpty ? "Enter email" : null,
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
                            value == null || value.isEmpty ? "Enter Role/Position" : null,
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
                        validator: (value) => value == null || value.isEmpty ? "Enter password" : null,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Save Changes"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedUser = widget.user.copyWith(
                              email: _emailController.text,
                              role: _roleController.text,
                              password: _passwordController.text,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
