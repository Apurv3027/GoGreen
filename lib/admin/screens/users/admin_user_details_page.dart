import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/users/user_detail_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_green/utility/cs.dart';

class AdminUserDetailsPage extends StatefulWidget {
  const AdminUserDetailsPage({super.key});

  @override
  State<AdminUserDetailsPage> createState() => _AdminUserDetailsPageState();
}

class _AdminUserDetailsPageState extends State<AdminUserDetailsPage> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  String defaultURL = "assets/img/Welcome_WhiteLogo.png";

  @override
  void initState() {
    super.initState();
    // _categoriesFuture = fetchCategories();
    setState(() {
      _usersFuture = fetchUsers();
    });
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse(liveApiDomain + 'api/users'),
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
            responseData.containsKey('users')) {
          List<dynamic> productsData = responseData['users'];

          return productsData.map((user) {
            return {
              'id': user['id'].toString() ?? '0',
              'fullname': user['fullname'] ?? 'No Data',
              'email': user['email'] ?? 'No Data',
              'mobile_number': user['mobile_number'] ?? '-',
              'addresses': user['addresses'] ?? [],
            };
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: cactusGreen,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh the banners data
          setState(() {
            _usersFuture = fetchUsers();
          });
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            print('Snapshot connection state: ${snapshot.connectionState}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Snapshot error: ${snapshot.error}');
              return Center(child: Text('Failed to load users'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No users found');
              return Center(child: Text('No users found'));
            } else {
              final usersList = snapshot.data!;
              print('User loaded: ${usersList.length}');
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    final user = usersList[index];
                    final addresses = user['addresses'] ?? [];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        onTap: () {
                          Get.to(
                            UserDetailScreen(
                              userId: usersList[index]['id'],
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        title: Text(
                          user['fullname'] ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ${user['email'] ?? ''}',
                            ),
                            Text('Phone: ${user['mobile_number'] ?? ''}'),
                          ],
                        ),
                        // trailing: PopupMenuButton<String>(
                        //   onSelected: (value) {
                        //     if (value == 'View Details') {
                        //       Get.to(UserDetailScreen(
                        //           userId: usersList[index]['id']));
                        //     } else if (value == 'Delete') {
                        //       // Implement delete functionality here
                        //       print(
                        //           'Delete user: ${usersList[index]['fullname']}');
                        //       Get.snackbar('Success',
                        //           'Delete user: ${usersList[index]['fullname']}',
                        //           snackPosition: SnackPosition.BOTTOM);
                        //     }
                        //   },
                        //   itemBuilder: (BuildContext context) {
                        //     return {'View Details', 'Delete'}
                        //         .map((String choice) {
                        //       return PopupMenuItem<String>(
                        //         value: choice,
                        //         child: Text(choice),
                        //       );
                        //     }).toList();
                        //   },
                        // ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      // body: ListView.builder(
      //   itemCount: usersList.length,
      //   itemBuilder: (context, index) {
      //     return Card(
      //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //       child: ListTile(
      //         leading: Icon(
      //           Icons.person,
      //           color: Colors.blue,
      //         ),
      //         title: Text(
      //           usersList[index]['name']!,
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //         subtitle: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text('Email: ${usersList[index]['email']}'),
      //             Text('Phone: ${usersList[index]['phone']}'),
      //           ],
      //         ),
      //         trailing: PopupMenuButton<String>(
      //           onSelected: (value) {
      //             if (value == 'View Details') {
      //               Get.to(UserDetailScreen(user: usersList[index]));
      //             } else if (value == 'Delete') {
      //               // Implement delete functionality here
      //               print('Delete user: ${usersList[index]['name']}');
      //             }
      //           },
      //           itemBuilder: (BuildContext context) {
      //             return {'View Details', 'Delete'}.map((String choice) {
      //               return PopupMenuItem<String>(
      //                 value: choice,
      //                 child: Text(choice),
      //               );
      //             }).toList();
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // ).paddingOnly(bottom: 20),
    );
  }
}
