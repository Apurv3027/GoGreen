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
  const EditBannerScreen({Key? key, required this.bannerData})  : super(key: key);

  @override
  State<EditBannerScreen> createState() => _EditBannerScreenState();
}

class _EditBannerScreenState extends State<EditBannerScreen> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bannerData['title']);
    _descriptionController = TextEditingController(text: widget.bannerData['description']);
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

      // Prepare the data to be sent
      var data = {
        'banner_name': name,
        'banner_description': description,
      };

      // Send data to the server
      var response = await http.post(
        // Update banner endpoint
        Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/banners/${widget.bannerData['id']}'),
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
                // Banner Image
                // Image.network(
                //   bannersList[index]['image'] ?? 'default_image_url',
                //   height: 180,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
                Image.asset(
                  'assets/img/Welcome_WhiteLogo.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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