// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/shopping_cart.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utility/commonMaterialButton.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'categories_page.dart';
import 'featured_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = true;
  // RxInt selectedcolor = 0.obs;
  // List<Color> colors = [
  //   colorDDB692,
  //   color007AFF,
  //   colorFF9500,
  //   colorFF2D55,
  //   color5856D6,
  //   colorE5E5EA,
  //   colorDDB692,
  //   color007AFF,
  //   colorFF9500,
  //   colorFF2D55,
  //   color5856D6,
  //   colorE5E5EA
  // ];

  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
      backgroundColor: softWhite,
      // appBar: AppBar(
      //   toolbarHeight: 80,
      //   // brightness: Brightness.light
      //   leading: GestureDetector(
      //     onTap: () => Get.back(),
      //     child: Image(image: backArrow),
      //   ),
      //   title: Text(
      //     productTxt,
      //     style: color000000w90018,
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Image(image: backArrow),
            ),
            title: Text(
              productTxt,
              style: color000000w90018,
            ),
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 400.0,
            flexibleSpace: const FlexibleSpaceBar(
              background: Image(
                image: demoProduct,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //     child: Center(
          //       child: Text('Scroll to see the SliverAppBar in effect.'),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: 420,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Image(
                    //     image: demoProduct,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 300,
                                child: Text(
                                  productName,
                                  style: color000000w60030.copyWith(),
                                ),
                              ),
                              FavoriteButton(
                                iconColor: Colors.black,
                                iconSize: 45,
                                isFavorite: true,
                                valueChanged: (_isFavorite) {
                                  print(
                                    'Is Favorite $_isFavorite)',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            "₹ " + productPrice,
                            style: colorFF2D55w70026,
                          ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        //   child: Divider(
                        //     color: color000000,
                        //     thickness: 0.3,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 10.0, horizontal: 18),
                        //   child: Text(
                        //     color,
                        //     style: color000000w60020,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        // SizedBox(
                        //   height: 50,
                        //   child: ListView.builder(
                        //     padding:
                        //         const EdgeInsets.symmetric(horizontal: 9.0),
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     // itemCount: colors.length,
                        //     itemBuilder: (context, index) {
                        //       return Obx(
                        //         () {
                        //           return Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 9.0),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 selectedcolor.value = index;
                        //               },
                        //               child: Container(
                        //                 height: 50,
                        //                 width: 50,
                        //                 decoration: BoxDecoration(
                        //                   color: colors[index],
                        //                   borderRadius:
                        //                       BorderRadius.circular(50),
                        //                 ),
                        //                 child: index == selectedcolor.value
                        //                     ? Icon(Icons.done)
                        //                     : SizedBox(),
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       );
                        //     },
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // SizedBox(
                        //   height: 10,
                        //   child: Divider(
                        //     color: color000000,
                        //     thickness: 0.3,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 18.0, vertical: 15),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         like,
                        //         style: color000000w60020,
                        //       ),
                        //       Row(
                        //         children: [
                        //           Text(
                        //             show,
                        //             style: color000000w50016,
                        //           ),
                        //           Icon(Icons.skip_next)
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // SizedBox(
                        //   height: 125,
                        //   child: ListView.builder(
                        //     padding: EdgeInsets.symmetric(horizontal: 9),
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: categoriesList.length,
                        //     itemBuilder: (context, index) {
                        //       return GestureDetector(
                        //         onTap: () => Get.to(CategoryPage()),
                        //         child: Container(
                        //           child: Column(
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsets.symmetric(
                        //                   horizontal: 9.0,
                        //                 ),
                        //                 child: Image(
                        //                   image: categoriesList[index].img,
                        //                   height: 95,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: 5,
                          child: Divider(
                            color: color000000,
                            thickness: 0.3,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 15),
                          child: Text(
                            description,
                            style: color000000w60020,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: SizedBox(
                            width: 450,
                            child: Text(
                              descriptionData,
                              style: color000000w40020.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   sku,
                                  //   style: color999999w50018.copyWith(
                                  //       fontWeight: FontWeight.normal),
                                  // ),
                                  Text(
                                    categories,
                                    style: color999999w50018.copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    tags,
                                    style: color999999w50018.copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  // Text(
                                  //   dimensions,
                                  //   style: color999999w50018.copyWith(
                                  //       fontWeight: FontWeight.normal),
                                  // ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   model,
                                  //   style: color000000w50020,
                                  // ),
                                  Text(
                                    modelDetails,
                                    style: color000000w50020,
                                  ),
                                  Text(
                                    hashtag,
                                    style: color000000w50020,
                                  ),
                                  // Text(
                                  //   dimensionsSize,
                                  //   style: color000000w50020,
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 25,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 18.0, vertical: 10),
                        //   child: Text(
                        //     similarItems,
                        //     style: color000000w60020,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 350,
                        //   child: ListView.builder(
                        //     padding: EdgeInsets.symmetric(horizontal: 10),
                        //     scrollDirection: Axis.horizontal,
                        //     itemBuilder: (context, index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: GestureDetector(
                        //           onTap: () => Get.to(FeauturedScreen()),
                        //           child: Container(
                        //             width: 180,
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Stack(
                        //                   children: [
                        //                     Image(
                        //                       image: gridItemList[index].img,
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
                        //                   gridItemList[index].name ?? '',
                        //                   style: color000000w50020.copyWith(),
                        //                   overflow: TextOverflow.ellipsis,
                        //                   maxLines: 2,
                        //                 ),
                        //                 SizedBox(height: 5),
                        //                 Text(
                        //                   gridItemList[index].price ?? '',
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
                        //     itemCount: gridItemList.length,
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),

      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       SizedBox(
      //         height: 420,
      //         width: MediaQuery.of(context).size.width,
      //         child: Image(
      //           image: demoProduct,
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(
      //               horizontal: 18.0,
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 SizedBox(
      //                   width: 340,
      //                   child: Text(
      //                     productName,
      //                     style: color000000w60030.copyWith(),
      //                   ),
      //                 ),
      //                 FavoriteButton(
      //                   iconColor: Colors.black,
      //                   iconSize: 45,
      //                   isFavorite: true,
      //                   valueChanged: (_isFavorite) {
      //                     print(
      //                       'Is Favorite $_isFavorite)',
      //                     );
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 5,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
      //             child: Text(
      //               productPrice,
      //               style: colorFF2D55w70026,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //             child: Divider(
      //               color: color000000,
      //               thickness: 0.3,
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
      //             child: Text(
      //               color,
      //               style: color000000w60020,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 8,
      //           ),
      //           SizedBox(
      //             height: 50,
      //             child: ListView.builder(
      //                 padding: const EdgeInsets.symmetric(horizontal: 9.0),
      //                 shrinkWrap: true,
      //                 scrollDirection: Axis.horizontal,
      //                 itemCount: colors.length,
      //                 itemBuilder: (context, index) {
      //                   return Obx(() {
      //                     return Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 9.0),
      //                       child: GestureDetector(
      //                         onTap: () {
      //                           selectedcolor.value = index;
      //                         },
      //                         child: Container(
      //                           height: 50,
      //                           width: 50,
      //                           decoration: BoxDecoration(
      //                             color: colors[index],
      //                             borderRadius: BorderRadius.circular(50),
      //                           ),
      //                           child: index == selectedcolor.value ? Icon(Icons.done) : SizedBox(),
      //                         ),
      //                       ),
      //                     );
      //                   });
      //                 }),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           SizedBox(
      //             height: 10,
      //             child: Divider(
      //               color: color000000,
      //               thickness: 0.3,
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(
      //                   like,
      //                   style: color000000w60020,
      //                 ),
      //                 Row(
      //                   children: [
      //                     Text(
      //                       show,
      //                       style: color000000w50016,
      //                     ),
      //                     Icon(Icons.skip_next)
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 10,
      //           ),
      //           SizedBox(
      //             height: 125,
      //             child: ListView.builder(
      //               padding: EdgeInsets.symmetric(horizontal: 9),
      //               shrinkWrap: true,
      //               scrollDirection: Axis.horizontal,
      //               itemCount: categoriesList.length,
      //               itemBuilder: (context, index) {
      //                 return GestureDetector(
      //                   onTap: () => Get.to(CategoryPage()),
      //                   child: Container(
      //                     child: Column(
      //                       children: [
      //                         Padding(
      //                           padding: const EdgeInsets.symmetric(
      //                             horizontal: 9.0,
      //                           ),
      //                           child: Image(
      //                             image: categoriesList[index].img,
      //                             height: 95,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           ),
      //           SizedBox(
      //             height: 5,
      //             child: Divider(
      //               color: color000000,
      //               thickness: 0.3,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 10,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
      //             child: Text(
      //               description,
      //               style: color000000w60020,
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
      //             child: SizedBox(
      //               width: 450,
      //               child: Text(
      //                 descriptionData,
      //                 style: color000000w40020.copyWith(fontWeight: FontWeight.normal, fontSize: 18),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       sku,
      //                       style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
      //                     ),
      //                     Text(
      //                       categories,
      //                       style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
      //                     ),
      //                     Text(
      //                       tags,
      //                       style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
      //                     ),
      //                     Text(
      //                       dimensions,
      //                       style: color999999w50018.copyWith(fontWeight: FontWeight.normal),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       model,
      //                       style: color000000w50020,
      //                     ),
      //                     Text(
      //                       modelDetails,
      //                       style: color000000w50020,
      //                     ),
      //                     Text(
      //                       hashtag,
      //                       style: color000000w50020,
      //                     ),
      //                     Text(
      //                       dimensionsSize,
      //                       style: color000000w50020,
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(
      //             height: 25,
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      //             child: Text(
      //               similarItems,
      //               style: color000000w60020,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 350,
      //             child: ListView.builder(
      //               padding: EdgeInsets.symmetric(horizontal: 10),
      //               scrollDirection: Axis.horizontal,
      //               itemBuilder: (context, index) {
      //                 return Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: GestureDetector(
      //                     onTap: () => Get.to(FeauturedScreen()),
      //                     child: Container(
      //                       width: 180,
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: [
      //                           Stack(
      //                             children: [
      //                               Image(
      //                                 image: gridItemList[index].img,
      //                               ),
      //                               Positioned(
      //                                   top: 10,
      //                                   right: 12,
      //                                   child: FavoriteButton(
      //                                     iconColor: Colors.black,
      //                                     iconSize: 35,
      //                                     isFavorite: true,
      //                                     valueChanged: (_isFavorite) {
      //                                       print(
      //                                         'Is Favorite $_isFavorite)',
      //                                       );
      //                                     },
      //                                   )),
      //                             ],
      //                           ),
      //                           SizedBox(height: 10),
      //                           Text(
      //                             gridItemList[index].name ?? '',
      //                             style: color000000w50020.copyWith(),
      //                             overflow: TextOverflow.ellipsis,
      //                             maxLines: 2,
      //                           ),
      //                           SizedBox(height: 5),
      //                           Text(
      //                             gridItemList[index].price ?? '',
      //                             style: color999999w40016.copyWith(
      //                               fontSize: 18,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 );
      //               },
      //               itemCount: gridItemList.length,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: commonMatButton(
          width: double.infinity,
          onPressed: () {
            Get.to(
              ShoppingCart(),
            );
          },
          txt: addToCart,
          buttonColor: cactusGreen,
        ),
      ),
    );
  }
}
