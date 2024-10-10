// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_green/screens/Favorites.dart';
import 'package:go_green/screens/about_page.dart';
import 'package:go_green/screens/logIn_page.dart';
import 'package:go_green/screens/my_orders.dart';
import 'package:go_green/screens/profile_page.dart';
import 'package:go_green/screens/settings.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      final String url = liveApiDomain + 'api/users/$userId';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          setState(() {
            user = json.decode(response.body)['user'];
          });
        } else {
          print('Failed to load user');
        }
      } catch (error) {
        print('Error fetching user: $error');
      }
    } else {
      Get.snackbar('Error', 'User not logged in.',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: softWhite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image(
                image: drawerBg,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 290,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.clear,
                            color: stoneGray,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      user != null ? 'Hello, ${user!['fullname']}' : 'Hello, Guest',
                      style: colorFFFFFFw80024,
                    ),
                    Text(
                      user != null ? '${user!['email']}' : 'guest@gmail.com',
                      style: colorFFFFFFw50016,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    home,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int? _userId = prefs.getInt('user_id');
                    Get.to(ProfilePage(userId: _userId.toString(),));
                  },
                  child: Text(
                    profile,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(MyOrders());
                  },
                  child: Text(
                    myOrders,
                    style: color000000w50022,
                  ),
                ),
                // SizedBox(
                //   height: 25,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //   },
                //   child: GestureDetector(
                //     onTap: () => Get.to(FavoritesPage()),
                //     child: Text(
                //       favorites,
                //       style: color000000w50022,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(AboutPage());
                  },
                  child: Text(
                    aboutUs,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(Settings());
                  },
                  child: Text(
                    settings,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAll(LogIn());
                  },
                  child: Text(
                    logout,
                    style: color000000w50022,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}