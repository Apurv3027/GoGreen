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

import '../utility/assets_utility.dart';
import '../utility/text_utils.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      user,
                      style: colorFFFFFFw80024,
                    ),
                    Text(
                      mail,
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
                  onTap: () {
                    Get.to(ProfilePage());
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
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: GestureDetector(
                    onTap: () => Get.to(FavoritesPage()),
                    child: Text(
                      favorites,
                      style: color000000w50022,
                    ),
                  ),
                ),
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
