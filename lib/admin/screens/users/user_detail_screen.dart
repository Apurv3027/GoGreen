import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailScreen extends StatefulWidget {

  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.userId);
  }

  Future<void> fetchUserDetails(String userId) async {
    final url = liveApiDomain + 'api/users/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          user = json.decode(response.body)['user'];
          isLoading = false;
        });
      } else {
        print('Failed to load user');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? '${user!['fullname']} Details' : 'User Details'),
        backgroundColor: cactusGreen,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user!['fullname']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user!['email']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${user!['mobile_number']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            adminCommonMatButton(
              onPressed: () {
                print('Edit user: ${user!['fullname']}');
                Get.snackbar('Success', 'Edit user: ${user!['fullname']}', snackPosition: SnackPosition.BOTTOM);
              },
              txt: 'Edit User',
              buttonColor: Colors.blue,
            ),
            SizedBox(height: 10),
            adminCommonMatButton(
              onPressed: () {
                print('Delete user: ${user!['fullname']}');
                Get.snackbar('Success', 'Delete user: ${user!['fullname']}', snackPosition: SnackPosition.BOTTOM);
              },
              txt: 'Delete User',
              buttonColor: Colors.red,
            ),
          ],
        ),
      )
          : Center(child: Text('User not found')),
    );
  }
}