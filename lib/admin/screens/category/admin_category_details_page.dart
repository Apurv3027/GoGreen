// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_green/admin/screens/category/add_category_screen.dart';
// import 'package:go_green/admin/screens/category/category_details_screen.dart';
// import 'package:go_green/admin/screens/category/edit_category_screen.dart';
// import 'package:go_green/utility/color_utilities.dart';
//
// class AdminCategoryDetailsPage extends StatelessWidget {
//   final List<Map<String, dynamic>> categoriesList = [
//     {'id': 1, 'name': 'Chairs', 'image': 'assets/img/Chair.png'},
//     {'id': 2, 'name': 'Lights', 'image': 'assets/img/light.png'},
//     {'id': 3, 'name': 'Clocks', 'image': 'assets/img/clock.png'},
//     {'id': 4, 'name': 'Metals', 'image': 'assets/img/metalchair.png'},
//     // Add more categories as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Category Details'),
//         backgroundColor: cactusGreen,
//       ),
//       body: ListView.builder(
//         itemCount: categoriesList.length,
//         itemBuilder: (context, index) {
//           final category = categoriesList[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 leading: Image.asset(
//                   category['image'],
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//                 title: Text(
//                   category['name'],
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () {
//                         // Handle edit action
//                         Get.to(EditCategoryScreen(category: category));
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         // Handle delete action
//                         _showDeleteConfirmation(context, category['id']);
//                       },
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   // Handle view details action
//                   Get.to(CategoryDetailsScreen(category: category));
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle add new category
//           Get.to(AddCategoryScreen());
//         },
//         backgroundColor: cactusGreen,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showDeleteConfirmation(BuildContext context, int categoryId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Category'),
//           content: Text('Are you sure you want to delete this category?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Implement delete functionality
//                 _deleteCategory(categoryId);
//                 Get.back();
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _deleteCategory(int categoryId) {
//     // Implement delete logic here, e.g., remove from list, update database, etc.
//     print('Category with ID $categoryId deleted');
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/category/add_category_screen.dart';
import 'package:go_green/admin/screens/category/edit_category_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminCategoryDetailsPage extends StatefulWidget {
  const AdminCategoryDetailsPage({super.key});

  @override
  State<AdminCategoryDetailsPage> createState() =>
      _AdminCategoryDetailsPageState();
}

class _AdminCategoryDetailsPageState extends State<AdminCategoryDetailsPage> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  String defaultURL = "assets/img/Welcome_WhiteLogo.png";

  @override
  void initState() {
    super.initState();
    // _categoriesFuture = fetchCategories();
    setState(() {
      _categoriesFuture = fetchCategories();
    });
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if responseData is a Map and contains a key with the list
        if (responseData is Map<String, dynamic> && responseData.containsKey('categories')) {
          List<dynamic> categoriesData = responseData['categories'];

          return categoriesData.map((category) {
            // Construct the full URL if needed (assuming URLs are relative)
            String imageUrl = category['category_image_url'] ?? defaultURL;
            if (imageUrl.startsWith('/')) {
              imageUrl = 'https://tortoise-new-emu.ngrok-free.app/storage' + imageUrl;
            }

            return {
              'id': category['id'].toString() ?? '0',
              'image': imageUrl,
              'title': category['category_name'] ?? 'No Title',
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        backgroundColor: cactusGreen,
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          // Refresh the banners data
          setState(() {
            _categoriesFuture = fetchCategories();
          });
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            print('Snapshot connection state: ${snapshot.connectionState}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Snapshot error: ${snapshot.error}');
              return Center(child: Text('Failed to load categories'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No categories found');
              return Center(child: Text('No categories found'));
            } else {
              final categoriesList = snapshot.data!;
              print('Banners loaded: ${categoriesList.length}');
              return Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ListView.builder(
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Image
                              Image.network(
                                categoriesList[index]['image'] ?? defaultURL,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),

                              // Category ID
                              Text(
                                'ID: ' + categoriesList[index]['id'] ?? 'No Title',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),

                              // Category Title
                              Text(
                                'Name: ' + categoriesList[index]['title'] ?? 'No Title',
                                style: TextStyle(
                                  // fontSize: 20,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 10),

                              // Edit and Delete Actions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      // Handle edit category
                                      Get.to(EditCategoryScreen(
                                          categoryData: categoriesList[index]));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // Handle delete category
                                      _confirmDelete(context, index, categoriesList);
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
          Get.to(AddCategoryScreen());
        },
        backgroundColor: cactusGreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, int index, List<Map<String, dynamic>> categoriesList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
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
                var categoryId = categoriesList[index]['id'];
                var response = await http.delete(
                  Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/categories/$categoryId'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  categoriesList.removeAt(index);
                  Navigator.of(context).pop();
                  Get.snackbar('Deleted', 'Category ${index + 1} deleted successfully');
                  setState(() {
                    _categoriesFuture = fetchCategories();
                  });
                } else {
                  Navigator.of(context).pop();
                  Get.snackbar('Error', 'Failed to delete category');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
