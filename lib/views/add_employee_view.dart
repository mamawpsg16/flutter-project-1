import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/employee_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';  // Add permission_handler package
import 'package:path_provider/path_provider.dart';

class AddEmployeeView extends StatefulWidget {
  const AddEmployeeView({super.key});

  @override
  State<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers when they are no longer needed
    _nameController.dispose();
    _roleController.dispose();

    super.dispose(); // Call the super.dispose() to ensure proper disposal
  }
  Future<String> _saveImageToPermanentStorage(XFile pickedImage) async {
    try {
      // Get app directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Create a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'employee_$timestamp.jpg';
      final permanentPath = '${directory.path}/$fileName';
      
      // Copy the image file to the permanent location
      final File sourceFile = File(pickedImage.path);
      final File destinationFile = await sourceFile.copy(permanentPath);
      
      return permanentPath; // Return the absolute path
    } catch (e) {
      print('Error saving image: $e');
      return ''; // Return empty string if save fails
    }
  }

// Update the _pickImage method
  void _pickImage(ImageSource source) async {
    try {
      // Request permissions first
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
      
      // Pick the image
      final XFile? pickedImage = await _picker.pickImage(source: source);
      
      if (pickedImage != null) {
        // Save image and get permanent path
        final String savedPath = await _saveImageToPermanentStorage(pickedImage);
        
        if (savedPath.isNotEmpty) {
          setState(() {
            _image = XFile(savedPath);
          });
          print('Image picked and saved: $savedPath');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeVM = Provider.of<EmployeeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Show dialog to pick image from gallery or camera
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick an option'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                          child: const Text('Camera'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                          child: const Text('Gallery'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null 
                    ? FileImage(File(_image!.path))
                    : AssetImage('assets/default_profile.png') as ImageProvider,
                child: _image == null 
                    ? const Icon(Icons.add_a_photo, color: Colors.white) 
                    : Container(),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Enter name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _roleController,
                    decoration: const InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? "Enter role" : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Employee"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        employeeVM.addEmployee(
                          _nameController.text,
                          _roleController.text,
                          _image?.path,
                        );
                        Navigator.pop(context); // Go back to the employee list page
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
