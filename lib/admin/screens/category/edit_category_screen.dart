import 'package:flutter/material.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/admin/utility/adminCommonTextField.dart';
import 'package:go_green/utility/color_utilities.dart';

class EditCategoryScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  EditCategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {

    TextEditingController categoryNameController = TextEditingController();
    TextEditingController categoryImageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${category['name']}'),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit details for ${category['name']}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Product Name',
            //     border: OutlineInputBorder(),
            //   ),
            //   controller: TextEditingController(text: product['name']),
            // ),
            adminCommonTextField(
              name: 'Category Name',
              suggestionTxt: category['name'],
              controller: categoryNameController,
              action: TextInputAction.next,
            ),
            SizedBox(height: 15),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Description',
            //     border: OutlineInputBorder(),
            //   ),
            //   controller: TextEditingController(text: product['description']),
            // ),
            adminCommonTextField(
              name: 'Category Image',
              suggestionTxt: category['image'],
              controller: categoryImageController,
              action: TextInputAction.next,
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Handle save action
            //   },
            //   child: Text('Save Changes'),
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.symmetric(vertical: 16),
            //     textStyle: TextStyle(fontSize: 18),
            //   ),
            // ),
            adminCommonMatButton(
              onPressed: () {
                // Handle save action
              },
              txt: 'Save Changes',
              buttonColor: cactusGreen,
            ),
          ],
        ),
      ),
    );
  }
}