import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/auth/login_screen.dart';
import 'package:go_green/screens/userinfo/edit_user_info_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/network_image_with_loader.dart';

class UserInfoScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const UserInfoScreen({
    super.key,
    required this.userDetails,
  });

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(
                EditUserInfoScreen(
                  userDetails: widget.userDetails,
                ),
              );
            },
            child: Text(
              'Edit',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile Picture
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/img/person.png',
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      100,
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.userDetails['fullname'],
                style: const TextStyle(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(widget.userDetails['email']),
            ),
            // CircleAvatar(
            //   radius: 40,
            //   backgroundImage: NetworkImage(
            //     widget.userDetails['profilePicture'] ??
            //         'https://i.imgur.com/IXnwbLk.png',
            //   ),
            // ),
            // const SizedBox(height: 10),
            // // User Full Name
            // Text(
            //   widget.userDetails['fullname'] ?? 'Full Name',
            //   style: Theme.of(context).textTheme.headline6,
            // ),
            // const SizedBox(height: 5),
            // // User Email
            // Text(
            //   widget.userDetails['email'] ?? 'Email',
            //   style: const TextStyle(color: Colors.grey),
            // ),
            const SizedBox(height: 20),
            // User Details Section
            const Divider(),
            _buildDetailItem(
                "Full Name", widget.userDetails['fullname'] ?? 'N/A'),
            // const Divider(),
            // _buildDetailItem(
            //     "Date of birth", widget.userDetails['dob'] ?? 'N/A'),
            // const Divider(),
            _buildDetailItem(
                "Phone number", widget.userDetails['mobile_number'] ?? 'N/A'),
            // const Divider(),
            // _buildDetailItem("Gender", widget.userDetails['gender'] ?? 'N/A'),
            // const Divider(),
            _buildDetailItem("Email", widget.userDetails['email'] ?? 'N/A'),
            // const Divider(),
            _buildDetailItem("Password", ""),
            const Divider(),
            const SizedBox(height: 20),
            // Logout Button
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Get.offAll(LoginScreen());
            //   },
            //   icon: SvgPicture.asset(
            //     "assets/icons/Logout.svg",
            //     color: Colors.white,
            //     height: 20,
            //   ),
            //   label: const Text('Log Out'),
            //   style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          title == "Password"
              ? GestureDetector(
                  onTap: () {
                    // Change password action
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
