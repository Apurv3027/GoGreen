import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:image_picker/image_picker.dart';

// class AddBannerScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Banner'),
//         backgroundColor: cactusGreen,
//       ),
//       body: Center(child: Text('Add new banner functionality goes here')),
//     );
//   }
// }

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _pickedImage;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _pickedImage = File(pickedFile.path);
  //     });
  //   }
  // }

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

  void _submitBanner() {
    if (_formKey.currentState!.validate()) {
      // Handle the submission of the form
      String name = _nameController.text;
      String description = _descriptionController.text;

      // Print the values to the console (in real applications, this data would be sent to a backend or saved to a database)
      print("Banner Name: $name");
      print("Banner Description: $description");
      print("Banner Image Path: ${_pickedImage?.path}");

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Banner Added Successfully')),
      );

      // Clear the form
      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _pickedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Banner'),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: bannerName,
                  hintText: bannerNameEX,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a banner name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
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
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: bannerDescription,
                  hintText: bannerDescriptionEX,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
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
                onPressed: _submitBanner,
                txt: 'Add Banner',
                buttonColor: cactusGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
