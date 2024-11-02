// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:go_green/screens/categories_page.dart';
import 'package:go_green/screens/featured_page.dart';
import 'package:go_green/screens/shopping_cart.dart';
import 'package:go_green/screens/widgets/BannerSliderWidget.dart';
import 'package:go_green/screens/widgets/CategoriesWidget.dart';
import 'package:go_green/screens/widgets/HomePageProductWidget.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/cs.dart';
import 'drawer_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      backgroundColor: softWhite,
      appBar: AppBar(
        iconTheme: IconThemeData(color: charcoalBlack),

        // leading: const Icon(
        //   Icons.menu,
        //   size: 30,
        //   color: color000000,
        // ),
        backgroundColor: softWhite,
        elevation: 0,
        title: Text(
          user != null ? 'Hello, ${user!['fullname']}' : 'Hello, Guest',
          style: color000000w90018,
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Get.to(
                  ShoppingCart(),
                );
              },
              icon: Icon(Icons.shopping_cart_rounded),
            ),
          ),
        ],
      ),
      drawer: DrawerScreen(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            fetchUserData();
          });

          // Adding a delay to simulate network request
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 25,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
              //   child: Container(
              //     width: double.infinity,
              //     height: 52,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         border: Border.all(
              //           color: colorCCCCCC,
              //         )),
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.search_outlined,
              //             color: colorCCCCCC,
              //             size: 26,
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text(
              //             search,
              //             style: colorCCCCCCw90018,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categories,
                      style: color000000w90020,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(CategoryPage());
                      },
                      child: Text(
                        seeall,
                        style: color7AFF18w50018,
                      ),
                    ),
                  ],
                ),
              ),

              // Display Category on Home Page
              CategoriesWidget(),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                child: Text(
                  collection,
                  style: color000000w90020,
                ),
              ),

              // Display Banner on Home Page
              BannerSliderWidget(),

              SizedBox(height: 15),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      featured,
                      style: color000000w90020,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(FeauturedScreen());
                      },
                      child: Text(
                        seeall,
                        style: color7AFF18w50018,
                      ),
                    ),
                  ],
                ),
              ),

              // Display Product on Home Page
              HomePageProductWidget(),

              // SizedBox(
              //   height: 350,
              //   child: ListView.builder(
              //     padding: EdgeInsets.symmetric(horizontal: 10),
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: GestureDetector(
              //           onTap: () => Get.to(ProductPage()),
              //           child: Container(
              //             width: 180,
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Stack(
              //                   children: [
              //                     Image(
              //                       image: arrayList[index]['img'],
              //                     ),
              //                     Positioned(
              //                         top: 10,
              //                         right: 12,
              //                         child: FavoriteButton(
              //                           iconColor: Colors.black,
              //                           iconSize: 35,
              //                           isFavorite: true,
              //                           valueChanged: (_isFavorite) {
              //                             print(
              //                               'Is Favorite $_isFavorite)',
              //                             );
              //                           },
              //                         )),
              //                   ],
              //                 ),
              //                 SizedBox(height: 10),
              //                 Text(
              //                   arrayList[index]['name'],
              //                   style: color000000w50020.copyWith(),
              //                   overflow: TextOverflow.ellipsis,
              //                   maxLines: 2,
              //                 ),
              //                 SizedBox(height: 5),
              //                 Text(
              //                   arrayList[index]['price'],
              //                   style: color999999w40016.copyWith(
              //                     fontSize: 18,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //     itemCount: arrayList.length,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
