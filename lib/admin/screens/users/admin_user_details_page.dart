import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/users/user_detail_screen.dart';
import 'package:go_green/utility/color_utilities.dart';

class AdminUserDetailsPage extends StatelessWidget {
  // Dummy data for demonstration. Replace with your data source.
  final List<Map<String, String>> usersList = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+1234567890',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '+0987654321',
    },
    {
      'name': 'Michael Johnson',
      'email': 'michael.johnson@example.com',
      'phone': '+1122334455',
    },
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+1234567890',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '+0987654321',
    },
    {
      'name': 'Michael Johnson',
      'email': 'michael.johnson@example.com',
      'phone': '+1122334455',
    },
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+1234567890',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'phone': '+0987654321',
    },
    {
      'name': 'Michael Johnson',
      'email': 'michael.johnson@example.com',
      'phone': '+1122334455',
    },
    // Add more user data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: cactusGreen,
      ),
      body: ListView.builder(
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text(
                usersList[index]['name']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${usersList[index]['email']}'),
                  Text('Phone: ${usersList[index]['phone']}'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'View Details') {
                    Get.to(UserDetailScreen(user: usersList[index]));
                  } else if (value == 'Delete') {
                    // Implement delete functionality here
                    print('Delete user: ${usersList[index]['name']}');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'View Details', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ).paddingOnly(bottom: 20),
    );
  }
}