import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();

  File? _pickedImage;

  List<String> categoryNames = [];
  String? selectedCategory;

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

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      String productName = _productNameController.text;
      String productPrice = _productPriceController.text;
      String productDescription = _productDescriptionController.text;
      int productQuantity = int.parse(_productQuantityController.text);
      String productCategory = selectedCategory ?? '';

      String? imageUrl;

      if (_pickedImage != null) {
        // Upload the image and get the URL
        imageUrl = await _uploadImage(_pickedImage!);
      }

      // Prepare the data to be sent
      var data = {
        'product_name': productName,
        'product_price': productPrice,
        'product_image_url': imageUrl,
        'product_description': productDescription,
        'product_quantity': productQuantity,
        'product_category': productCategory,
      };

      // Send data to the server
      var response = await http.post(
        Uri.parse(liveApiDomain + 'api/add-product'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product Added Successfully')),
        );
        _productNameController.clear();
        _productPriceController.clear();
        _productDescriptionController.clear();
        _productQuantityController.clear();
        // _productCategoryController.clear();
        selectedCategory = null;
        Get.back();
        setState(() {
          _pickedImage = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
        print('Failed to add product: ${response.body}');
      }
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        // Uri.parse('https://your-laravel-api-endpoint.com/api/upload'),
        Uri.parse(liveApiDomain + 'api/upload-product-image'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
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

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/categories'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        categoryNames = List<String>.from(data['categories'].map((category) => category['category_name']));
        setState(() {});
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
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
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _productPriceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  hintText: 'Enter product price',
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
                controller: _productDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Product Description',
                  hintText: 'Enter product description',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                scrollPhysics: ClampingScrollPhysics(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _productQuantityController,
                decoration: InputDecoration(
                  labelText: 'Product Quantity',
                  hintText: 'Enter product quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a valid integer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // TextFormField(
              //   controller: _productCategoryController,
              //   decoration: InputDecoration(
              //     labelText: 'Product Category',
              //     hintText: 'Enter product category',
              //     border: OutlineInputBorder(),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a category';
              //     }
              //     return null;
              //   },
              // ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  print('newValue: ${newValue}');
                  setState(() {
                    selectedCategory = newValue; // Update the selected category
                  });
                  print('selectedCategory: ${selectedCategory}');
                },
                items: categoryNames.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Product Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              adminCommonMatButton(
                onPressed: _submitProduct,
                txt: 'Add Product',
                buttonColor: cactusGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
