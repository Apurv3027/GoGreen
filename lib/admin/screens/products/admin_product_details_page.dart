import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/products/edit_product_details_screen.dart';
import 'package:go_green/utility/color_utilities.dart';

class AdminProductDetailsPage extends StatelessWidget {
  const AdminProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example product data list (in a real app, this would come from a database)
    List<Map<String, dynamic>> productList = [
      {
        'image': 'assets/img/Chair.png',
        'name': 'Wooden Chair',
        'description': 'High-quality wooden chair',
        'price': '\$120.00',
        'stock': 'Available',
      },
      {
        'image': 'assets/img/Lamps.png',
        'name': 'Modern Lamp',
        'description': 'Elegant modern lamp for home',
        'price': '\$80.00',
        'stock': 'Available',
      },
      {
        'image': 'assets/img/Ceiling.png',
        'name': 'Coffee Table',
        'description': 'Stylish coffee table',
        'price': '\$150.00',
        'stock': 'Out of Stock',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
        ),
        backgroundColor: cactusGreen,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return Card(
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
                        image: AssetImage(productList[index]['image']),
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
                          productList[index]['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),

                        // Product Description
                        Text(
                          productList[index]['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),

                        // Product Price
                        Text(
                          'Price: ${productList[index]['price']}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),

                        // Product Stock Status
                        Text(
                          'Stock: ${productList[index]['stock']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: productList[index]['stock'] == 'Available'
                                ? Colors.green
                                : Colors.red,
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
                          Get.to(EditProductDetailsScreen(product: productList[index]));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          // Handle product delete
                          _showDeleteConfirmationDialog(
                              context, productList[index]);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Handle delete action
                Navigator.of(context).pop();
                // Here you would typically call a method to remove the product from the list or database
              },
            ),
          ],
        );
      },
    );
  }
}