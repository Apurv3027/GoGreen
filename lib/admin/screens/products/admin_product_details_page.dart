import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/products/add_product_screen.dart';
import 'package:go_green/admin/screens/products/edit_product_details_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminProductDetailsPage extends StatefulWidget {
  const AdminProductDetailsPage({super.key});

  @override
  State<AdminProductDetailsPage> createState() =>
      _AdminProductDetailsPageState();
}

class _AdminProductDetailsPageState extends State<AdminProductDetailsPage> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  String defaultURL = "assets/img/Welcome_WhiteLogo.png";

  @override
  void initState() {
    super.initState();
    // _categoriesFuture = fetchCategories();
    setState(() {
      _productsFuture = fetchProducts();
    });
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if responseData is a Map and contains a key with the list
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('products')) {
          List<dynamic> productsData = responseData['products'];

          return productsData.map((category) {
            // Construct the full URL if needed (assuming URLs are relative)
            String imageUrl = category['product_image_url'] ?? defaultURL;
            if (imageUrl.startsWith('/')) {
              imageUrl = liveApiDomain + 'storage' + imageUrl;
            }

            return {
              'id': category['id'].toString() ?? '0',
              'image': imageUrl,
              'title': category['product_name'] ?? 'No Data',
              'price': category['product_price'] ?? 'No Data',
              'description': category['product_description'] ?? 'No Data',
              'quantity': category['product_quantity'] ?? 0,
              'category': category['product_category'] ?? 'No Data',
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
        ),
        backgroundColor: cactusGreen,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh the banners data
          setState(() {
            _productsFuture = fetchProducts();
          });
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            print('Snapshot connection state: ${snapshot.connectionState}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Snapshot error: ${snapshot.error}');
              return Center(child: Text('Failed to load products'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No products found');
              return Center(child: Text('No products found'));
            } else {
              final productsList = snapshot.data!;
              print('Product loaded: ${productsList.length}');
              return Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ListView.builder(
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      productsList[index]['image'] ??
                                          defaultURL,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(width: 15),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product Name
                                    Text(
                                      productsList[index]['title'] ??
                                          "Product Name",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),

                                    // Product Description
                                    Text(
                                      productsList[index]['description'] ??
                                          "Product Description",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),

                                    // Product Price
                                    Text(
                                      '₹ ' + productsList[index]['price'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),

                                    // Product Stock Status
                                    Text(
                                      'Stock: ${productsList[index]['quantity']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: productsList[index]['quantity'] == 0
                                            ? Colors.red
                                            : productsList[index]['quantity'] < 5
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Action Buttons (Edit/Delete)
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.blue,
                                    onPressed: () {
                                      // Handle product edit
                                      Get.to(EditProductDetailsScreen(
                                          productData: productsList[index]));
                                      print(productsList[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      _confirmDelete(context, index, productsList);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new category
          Get.to(AddProductScreen());
        },
        backgroundColor: cactusGreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, int index, List<Map<String, dynamic>> productsList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // Perform delete operation
                var productId = productsList[index]['id'];
                var response = await http.delete(
                  Uri.parse(liveApiDomain + 'api/products/$productId'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  productsList.removeAt(index);
                  Navigator.of(context).pop();
                  Get.snackbar('Deleted', 'Product ${index + 1} deleted successfully');
                  setState(() {
                    _productsFuture = fetchProducts();
                  });
                } else {
                  Navigator.of(context).pop();
                  Get.snackbar('Error', 'Failed to delete product');
                }
                print(response.body);
              },
            ),
          ],
        );
      },
    );
  }
}
