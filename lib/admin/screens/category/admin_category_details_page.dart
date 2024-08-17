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
import 'package:go_green/admin/screens/category/category_details_screen.dart';
import 'package:go_green/admin/screens/category/edit_category_screen.dart';
import 'package:go_green/utility/color_utilities.dart';

class AdminCategoryDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> categoriesList = [
    {'id': 1, 'name': 'Chairs', 'image': 'assets/img/Chair.png'},
    {'id': 2, 'name': 'Lights', 'image': 'assets/img/light.png'},
    {'id': 3, 'name': 'Clocks', 'image': 'assets/img/clock.png'},
    {'id': 4, 'name': 'Metals', 'image': 'assets/img/metalchair.png'},
    {'id': 5, 'name': 'Chairs', 'image': 'assets/img/Chair.png'},
    {'id': 6, 'name': 'Lights', 'image': 'assets/img/light.png'},
    {'id': 7, 'name': 'Clocks', 'image': 'assets/img/clock.png'},
    {'id': 8, 'name': 'Metals', 'image': 'assets/img/metalchair.png'},
    {'id': 9, 'name': 'Chairs', 'image': 'assets/img/Chair.png'},
    {'id': 10, 'name': 'Lights', 'image': 'assets/img/light.png'},
    {'id': 11, 'name': 'Clocks', 'image': 'assets/img/clock.png'},
    {'id': 12, 'name': 'Metals', 'image': 'assets/img/metalchair.png'},
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Adjust padding for FAB
        child: ListView.builder(
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
            final category = categoriesList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Image.asset(
                    category['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Handle edit action
                          Get.to(EditCategoryScreen(category: category));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Handle delete action
                          // _showDeleteConfirmation(context, category['id']);
                          _confirmDelete(context, index, categoriesList);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle view details action
                    Get.to(CategoryDetailsScreen(category: category));
                  },
                ),
              ),
            );
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
              onPressed: () {
                // Perform delete operation
                categoriesList.removeAt(index);
                Navigator.of(context).pop();
                // Get.snackbar('Deleted', 'Category deleted successfully');
                Get.snackbar('Deleted', 'Category ${index + 1} deleted successfully');
              },
            ),
          ],
        );
      },
    );
  }

  // void _showDeleteConfirmation(BuildContext context, int categoryId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Delete Category'),
  //         content: Text('Are you sure you want to delete this category?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Implement delete functionality
  //               _deleteCategory(categoryId);
  //               Get.back();
  //             },
  //             child: Text('Delete'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void _deleteCategory(int categoryId) {
  //   // Implement delete logic here, e.g., remove from list, update database, etc.
  //   print('Category with ID $categoryId deleted');
  // }
}