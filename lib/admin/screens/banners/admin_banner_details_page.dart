import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/banners/add_banner_screen.dart';
import 'package:go_green/admin/screens/banners/edit_banner_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminBannersDetailsPage extends StatefulWidget {
  const AdminBannersDetailsPage({super.key});

  @override
  State<AdminBannersDetailsPage> createState() =>
      _AdminBannersDetailsPageState();
}

class _AdminBannersDetailsPageState extends State<AdminBannersDetailsPage> {

  late Future<List<Map<String, dynamic>>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    // _bannersFuture = fetchBanners();
    setState(() {
      _bannersFuture = fetchBanners();
    });// Fetch banners when the screen is initialized
  }

  Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/banners'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print raw response

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Check if responseData is a Map and contains a key with the list
        if (responseData is Map<String, dynamic> && responseData.containsKey('banners')) {
          List<dynamic> bannersData = responseData['banners'];

          return bannersData.map((banner) {
            // Construct the full URL if needed (assuming URLs are relative)
            String imageUrl = banner['banner_image_url'] ?? 'default_image_url';
            if (imageUrl.startsWith('/')) {
              imageUrl = 'https://tortoise-new-emu.ngrok-free.app/storage' + imageUrl;
            }

            return {
              'id': banner['id'].toString() ?? '0',
              'image': imageUrl,
              'title': banner['banner_name'] ?? 'No Title',
              'description': banner['banner_description'] ?? 'No Description',
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching banners: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Banner Details',
        ),
        backgroundColor: cactusGreen,
      ),
      body: RefreshIndicator(
          onRefresh: () async{
            // Refresh the banners data
            setState(() {
              _bannersFuture = fetchBanners();
            });
          },
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _bannersFuture,
            builder: (context, snapshot) {
              print('Snapshot connection state: ${snapshot.connectionState}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Snapshot error: ${snapshot.error}');
                return Center(child: Text('Failed to load banners'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('No banners found');
                return Center(child: Text('No banners found'));
              } else {
                final bannersList = snapshot.data!;
                print('Banners loaded: ${bannersList.length}');
                return Padding(
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
                                // Image.network(
                                //   bannersList[index]['image'] ?? 'default_image_url',
                                //   height: 180,
                                //   width: double.infinity,
                                //   fit: BoxFit.cover,
                                // ),
                                Image.asset(
                                  'assets/img/Welcome_WhiteLogo.png',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),

                                // Banner Title
                                Text(
                                  bannersList[index]['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),

                                // Banner Description
                                Text(
                                  bannersList[index]['description'] ?? 'No Description',
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
                );
              }
            },
          ),
      ),
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
      BuildContext context, int index, List<Map<String, dynamic>> bannersList) {
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
              // onPressed: () {
              //   // Perform delete operation
              //   bannersList.removeAt(index);
              //   Navigator.of(context).pop();
              //   // Get.snackbar('Deleted', 'Banner deleted successfully');
              //   Get.snackbar(
              //       'Deleted', 'Banner ${index + 1} deleted successfully');
              // },
              onPressed: () async {
                // Perform delete operation
                var bannerId = bannersList[index]['id'];
                var response = await http.delete(
                  Uri.parse('https://tortoise-new-emu.ngrok-free.app/api/banners/$bannerId'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  bannersList.removeAt(index);
                  Navigator.of(context).pop();
                  Get.snackbar('Deleted', 'Banner ${index + 1} deleted successfully');
                  setState(() {
                    _bannersFuture = fetchBanners();
                  });
                } else {
                  Navigator.of(context).pop();
                  Get.snackbar('Error', 'Failed to delete banner');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
