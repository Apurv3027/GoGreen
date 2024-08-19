import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/admin/utility/adminCommonTextField.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  const EditCategoryScreen({Key? key, required this.categoryData})
      : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;

  String defaultURL = "assets/img/Welcome_WhiteLogo.png";

  File? _pickedImage;

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.categoryData['title']);
    imageUrl = widget.categoryData['image'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      // Get the current description
      String name = _titleController.text;

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
        // Update banner endpoint
        Uri.parse(
            liveApiDomain + 'api/categories/${widget.categoryData['id']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category Updated Successfully')),
        );
        _titleController.clear();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update category')),
        );
      }
    }
  }

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

  Future<String?> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://your-laravel-api-endpoint.com/api/upload'),
        Uri.parse(
            liveApiDomain + 'api/upload-category-image'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
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
        title: Text('Edit Category'),
        backgroundColor: cactusGreen,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Category Name",
                    hintText: "Category 1",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Category Image
                Text(
                  'Category Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await _pickImage(); // First, pick the image
                    if (_pickedImage != null) {
                      await _uploadImage(_pickedImage!); // Then, upload it
                    }
                  },
                  child: _pickedImage != null
                      ? Image.file(
                    _pickedImage!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    widget.categoryData['image'] ?? defaultURL,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap on the image to update',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                adminCommonMatButton(
                  onPressed: _updateCategory,
                  txt: 'Update Category',
                  buttonColor: cactusGreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
