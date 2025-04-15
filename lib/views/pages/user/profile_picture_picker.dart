// profile_picture_picker.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePicturePicker extends StatefulWidget {
  final Function(XFile?) onImagePicked;
  final XFile? initialImage;

  const ProfilePicturePicker({super.key, required this.onImagePicked, this.initialImage});

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage; // Initialize with initial image
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
          widget.onImagePicked(_image);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
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
    );
  }
}
