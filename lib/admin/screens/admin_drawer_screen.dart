// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_green/admin/screens/banners/admin_banner_details_page.dart';
import 'package:go_green/admin/screens/category/admin_category_details_page.dart';
import 'package:go_green/admin/screens/orders/order_details.dart';
import 'package:go_green/admin/screens/products/admin_product_details_page.dart';
import 'package:go_green/admin/screens/users/admin_user_details_page.dart';
import 'package:go_green/screens/logIn_page.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/assets_utility.dart';
import '../../utility/color_utilities.dart';
import '../../utility/text_utils.dart';

class AdminDrawerScreen extends StatelessWidget {
  const AdminDrawerScreen({Key? key}) : super(key: key);

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
                      // user,
                      adminUser,
                      style: colorFFFFFFw80024,
                    ),
                    Text(
                      // mail,
                      adminMail,
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
                    adminDashboard,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(AdminUserDetailsPage());
                  },
                  child: Text(
                    adminUserDetails,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(OrderDetails());
                  },
                  child: Text(
                    adminOrderDetails,
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
                    onTap: () {
                      Get.to(AdminProductDetailsPage());
                    },
                    child: Text(
                      adminProduct,
                      style: color000000w50022,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(AdminCategoryDetailsPage());
                  },
                  child: Text(
                    adminCategory,
                    style: color000000w50022,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(AdminBannersDetailsPage());
                  },
                  child: Text(
                    adminBanners,
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
