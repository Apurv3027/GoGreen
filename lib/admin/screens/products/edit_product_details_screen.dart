import 'package:flutter/material.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/admin/utility/adminCommonTextField.dart';
import 'package:go_green/utility/color_utilities.dart';

class EditProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController productNameController = TextEditingController();
    TextEditingController productDescriptionController = TextEditingController();
    TextEditingController productPriceController = TextEditingController();
    TextEditingController productStockController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Product',
        ),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit details for ${product['name']}',
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
              name: 'Product Name',
              suggestionTxt: product['name'],
              controller: productNameController,
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
              name: 'Product Description',
              suggestionTxt: product['description'],
              controller: productDescriptionController,
              action: TextInputAction.next,
            ),
            SizedBox(height: 15),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Price',
            //     border: OutlineInputBorder(),
            //   ),
            //   controller: TextEditingController(text: product['price']),
            // ),
            adminCommonTextField(
              name: 'Product Price',
              suggestionTxt: product['price'],
              controller: productPriceController,
              action: TextInputAction.next,
            ),
            SizedBox(height: 15),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Stock Status',
            //     border: OutlineInputBorder(),
            //   ),
            //   controller: TextEditingController(text: product['stock']),
            // ),
            adminCommonTextField(
              name: 'Product Stock',
              suggestionTxt: product['stock'],
              controller: productStockController,
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