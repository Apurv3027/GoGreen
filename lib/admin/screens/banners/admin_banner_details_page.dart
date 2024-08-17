import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/banners/add_banner_screen.dart';
import 'package:go_green/admin/screens/banners/edit_banner_screen.dart';
import 'package:go_green/utility/color_utilities.dart';

class AdminBannersDetailsPage extends StatelessWidget {
  const AdminBannersDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample list of banners
    final List<Map<String, String>> bannersList = [
      {
        'image': 'assets/img/collectionBg.png',
        'title': 'Summer Sale',
        'description': 'Get up to 50% off on selected items!',
      },
      {
        'image': 'assets/img/collectionBg.png',
        'title': 'New Arrivals',
        'description': 'Check out the latest trends in our collection.',
      },
      {
        'image': 'assets/img/collectionBg.png',
        'title': 'Clearance Sale',
        'description': 'Last chance to grab items at unbeatable prices!',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Banner Details',
        ),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        // padding: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          itemCount: bannersList.length,
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
                      // Banner Image
                      Image.asset(
                        bannersList[index]['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),

                      // Banner Title
                      Text(
                        bannersList[index]['title']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),

                      // Banner Description
                      Text(
                        bannersList[index]['description']!,
                        style: TextStyle(
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
                              // Handle edit banner
                              Get.to(EditBannerScreen(
                                  bannerData: bannersList[index]));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Handle delete banner
                              _confirmDelete(context, index, bannersList);
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
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle add new category
      //     // Get.to(AddCategoryScreen());
      //   },
      //   backgroundColor: cactusGreen,
      //   child: Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new category
          Get.to(AddBannerScreen());
        },
        backgroundColor: cactusGreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, int index, List<Map<String, String>> bannersList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Banner'),
          content: Text('Are you sure you want to delete this banner?'),
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
                bannersList.removeAt(index);
                Navigator.of(context).pop();
                // Get.snackbar('Deleted', 'Banner deleted successfully');
                Get.snackbar('Deleted', 'Banner ${index + 1} deleted successfully');
              },
            ),
          ],
        );
      },
    );
  }
}
