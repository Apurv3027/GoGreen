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

class EditProductDetailsScreen extends StatefulWidget {

  final Map<String, dynamic> productData;

  const EditProductDetailsScreen({Key? key, required this.productData}) : super(key: key);

  @override
  State<EditProductDetailsScreen> createState() => _EditProductDetailsScreenState();
}

class _EditProductDetailsScreenState extends State<EditProductDetailsScreen> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  late TextEditingController _productDescriptionController;
  late TextEditingController _productQuantityController;
  late TextEditingController _productCategoryController;

  File? _pickedImage;

  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.productData['title']);
    _productPriceController = TextEditingController(text: widget.productData['price']);
    imageUrl = widget.productData['image'];
    _productDescriptionController = TextEditingController(text: widget.productData['description']);
    _productQuantityController = TextEditingController(text: widget.productData['quantity'].toString());
    _productCategoryController = TextEditingController(text: widget.productData['category']);

  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescriptionController.dispose();
    _productQuantityController.dispose();
    _productCategoryController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // Get the current description
      String name = _productNameController.text;
      String price = _productPriceController.text;
      String description = _productDescriptionController.text;
      int quantity = int.parse(_productQuantityController.text);
      String category = _productCategoryController.text;

      if (_pickedImage != null) {
        // Upload the image and get the URL
        imageUrl = await _uploadImage(_pickedImage!);
      }

      // Prepare the data to be sent
      var data = {
        'product_name': name,
        'product_price': price,
        'product_image_url': imageUrl,
        'product_description': description,
        'product_quantity': quantity,
        'product_category': category,

      };

      // Send data to the server
      var response = await http.post(
        // Update banner endpoint
        Uri.parse(
            liveApiDomain + 'api/products/${widget.productData['id']}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product Updated Successfully')),
        );
        _productNameController.clear();
        _productPriceController.clear();
        _productDescriptionController.clear();
        _productQuantityController.clear();
        _productCategoryController.clear();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product')),
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
            liveApiDomain + 'api/upload-product-image'),
      );
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['product_image_url'];
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
        title: Text(
          'Edit Product',
        ),
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
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    hintText: "Product 1",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _productPriceController,
                  decoration: InputDecoration(
                    labelText: "Product Price",
                    hintText: "₹ 1500",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Category Image
                Text(
                  'Product Image',
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
                    widget.productData['image'] ?? defaultURL,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap on the image to update',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),SizedBox(height: 10),
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Product Description",
                    hintText: "Product Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  scrollPhysics: ClampingScrollPhysics(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _productQuantityController,
                  decoration: InputDecoration(
                    labelText: "Product Quantity",
                    hintText: "Product Quantity",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _productCategoryController,
                  decoration: InputDecoration(
                    labelText: "Product Category",
                    hintText: "Product Category",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                adminCommonMatButton(
                  onPressed: _updateProduct,
                  txt: 'Update Product',
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