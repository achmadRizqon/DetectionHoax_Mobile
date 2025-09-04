import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UbahGambarScreen extends StatefulWidget {
  final Function(File) onImageSelected;

  const UbahGambarScreen({super.key, required this.onImageSelected});

  @override
  _UbahGambarScreenState createState() => _UbahGambarScreenState();
}

class _UbahGambarScreenState extends State<UbahGambarScreen> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _confirmImage() {
    if (_selectedImage != null) {
      widget.onImageSelected(_selectedImage!);
      Navigator.pop(context, _selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Gambar Profil")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _confirmImage,
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}