import 'package:flutter/material.dart';
import 'package:go_green/admin/utility/adminCommonMaterialButton.dart';
import 'package:go_green/utility/color_utilities.dart';

class UserDetailScreen extends StatelessWidget {
  final Map<String, String> user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user['name']} Details'),
        backgroundColor: cactusGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user['email']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${user['phone']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement edit user functionality here
            //     print('Edit user: ${user['name']}');
            //   },
            //   child: Text('Edit User'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     padding: EdgeInsets.symmetric(vertical: 16),
            //     textStyle: TextStyle(fontSize: 18),
            //   ),
            // ),
            adminCommonMatButton(
              onPressed: () {
                // Implement edit user functionality here
                print('Edit user: ${user['name']}');
              },
              txt: 'Edit User',
              // buttonColor: cactusGreen,
              buttonColor: Colors.blue,
            ),
            SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement delete user functionality here
            //     print('Delete user: ${user['name']}');
            //   },
            //   child: Text('Delete User'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     padding: EdgeInsets.symmetric(vertical: 16),
            //     textStyle: TextStyle(fontSize: 18),
            //   ),
            // ),
            adminCommonMatButton(
              onPressed: () {
                // Implement edit user functionality here
                print('Delete user: ${user['name']}');
              },
              txt: 'Delete User',
              // buttonColor: cactusGreen,
              buttonColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}