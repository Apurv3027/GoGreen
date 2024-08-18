import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class EditBannerScreen extends StatefulWidget {
  final Map<String, dynamic> bannerData;
  const EditBannerScreen({Key? key, required this.bannerData})
      : super(key: key);

  @override
  State<EditBannerScreen> createState() => _EditBannerScreenState();
}

class _EditBannerScreenState extends State<EditBannerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String defaultURL = "assets/img/Welcome_WhiteLogo.png";

  File? _pickedImage;

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bannerData['title']);
    _descriptionController =
        TextEditingController(text: widget.bannerData['description']);
    imageUrl = widget.bannerData['image'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateBanner() async {
    if (_formKey.currentState!.validate()) {
      // Get the current description
      String name = _titleController.text;
      String description = _descriptionController.text;

      if (_pickedImage != null) {
        // Upload the image and get the URL
        imageUrl = await _uploadImage(_pickedImage!);
      }

      // Prepare the data to be sent
      var data = {
        'banner_name': name,
        'banner_description': description,
        'banner_image_url': imageUrl,
      };

      // Send data to the server
      var response = await http.post(
        // Update banner endpoint
        Uri.parse(
            'https://tortoise-new-emu.ngrok-free.app/api/banners/${widget.bannerData['id']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Banner Updated Successfully')),
        );
        _titleController.clear();
        _descriptionController.clear();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update banner')),
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
            'https://tortoise-new-emu.ngrok-free.app/api/upload-banner-image'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['banner_image_url'];
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
        title: Text('Edit Banner'),
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
                    labelText: bannerName,
                    hintText: bannerNameEX,
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
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: bannerDescription,
                    hintText: bannerDescriptionEX,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Banner Image
                // Image.network(
                //   widget.bannerData['image'] ?? defaultURL,
                //   height: 180,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Text(
                  'Banner Image',
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
                          widget.bannerData['image'] ?? defaultURL,
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
                  onPressed: _updateBanner,
                  txt: 'Update Banner',
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
