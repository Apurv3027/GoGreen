// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:go_green/screens/categories_page.dart';
import 'package:go_green/screens/featured_page.dart';
import 'package:go_green/screens/notification.dart';
import 'package:go_green/screens/product_page.dart';
import 'package:go_green/screens/widgets/BannerSliderWidget.dart';
import 'package:go_green/screens/widgets/CategoriesWidget.dart';
import 'package:go_green/screens/widgets/HomePageProductWidget.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:get/get.dart';

import '../utility/cs.dart';
import 'drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          username,
          style: color000000w90018,
        ),
        centerTitle: false,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: InkWell(
        //         onTap: () async {
        //           final result = await Get.to(NotificationBar());
        //           if (result != null) {
        //             print("result====>${result}");
        //           }
        //         },
        //         child: Image(
        //           image: notification,
        //           color: charcoalBlack,
        //         )),
        //   ),
        // ],
      ),
      drawer: DrawerScreen(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: colorCCCCCC,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_outlined,
                        color: colorCCCCCC,
                        size: 26,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        search,
                        style: colorCCCCCCw90018,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    );
  }
}
