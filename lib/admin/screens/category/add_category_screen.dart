import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitCategory() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;

      String? imageUrl;

      if (_pickedImage != null) {
        // Upload the image and get the URL
        imageUrl = await _uploadImage(_pickedImage!);
      }

      // Prepare the data to be sent
      var data = {
        'category_name': name,
        'category_image_url': imageUrl,
      };

      // Send data to the server
      var response = await http.post(
        // Uri.parse('https://your-laravel-api-endpoint.com/api/banners'),
        Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/add-category'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category Added Successfully')),
        );
        _nameController.clear();
        Get.back();
        setState(() {
          _pickedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category')),
        );
      }
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://your-laravel-api-endpoint.com/api/upload'),
        Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/upload-category-image'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['category_image_url'];
      } else {
        print('Failed to upload image');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Category'),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: bannerName,
                  hintText: bannerNameEX,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                // onTap: _pickImage,
                onTap: () async {
                  await _pickImage(); // First, pick the image
                  if (_pickedImage != null) {
                    await _uploadImage(_pickedImage!); // Then, upload it
                  }
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _pickedImage == null
                      ? Center(child: Text('Tap to select image'))
                      : Image.file(_pickedImage!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 32),
              // ElevatedButton(
              //   onPressed: _submitBanner,
              //   child: Text('Add Banner'),
              //   style: ElevatedButton.styleFrom(
              //     primary: cactusGreen,
              //     padding: EdgeInsets.symmetric(vertical: 16),
              //     textStyle: TextStyle(fontSize: 16),
              //   ),
              // ),
              adminCommonMatButton(
                onPressed: _submitCategory,
                txt: 'Add Category',
                buttonColor: cactusGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
