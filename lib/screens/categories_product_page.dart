// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_green/utility/assets_utility.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class CategoriesProductPage extends StatefulWidget {
  const CategoriesProductPage({Key? key}) : super(key: key);

  @override
  State<CategoriesProductPage> createState() => _CategoriesProductPageState();
}

class _CategoriesProductPageState extends State<CategoriesProductPage> with SingleTickerProviderStateMixin {
  TabController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: color000000,
            ),
          ),
          backgroundColor: colorFFFFFF,
          elevation: 1,
          title: Text(
            categoriesTitle,
            style: color000000w90018,
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            // indicatorWeight: double.infinity,

            labelColor: color000000,
            unselectedLabelColor: color999999,
            unselectedLabelStyle: color999999w50020.copyWith(fontSize: 20),
            labelStyle: color000000w90020.copyWith(fontSize: 25),
            controller: _controller,
            tabs: [
              Tab(
                text: featured,
              ),
              Tab(
                text: collection,
              ),
              Tab(
                text: trending,
              ),
              Tab(
                text: featured,
              ),

              // Tab(
              //   text: 'Collection',
              // ),
              // Tab(
              //   text: 'Trends',
              // ),
              // Tab(
              //   text: 'Featured',
              // ),
            ],
          ),
        ),
        body: TabBarView(controller: _controller, children: [
          GridView.builder(
              shrinkWrap: true,
              itemCount: gridItemList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image(
                              image: gridItemList[index].img,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                top: 10,
                                right: 12,
                                child: FavoriteButton(
                                  iconColor: Colors.black,
                                  iconSize: 35,
                                  isFavorite: true,
                                  valueChanged: (_isFavorite) {
                                    print(
                                      'Is Favorite $_isFavorite)',
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        gridItemList[index].name ?? '',
                        style: color000000w90020,
                      ),
                      Text(
                        gridItemList[index].price ?? '',
                        style: color999999w40020,
                      ),
                    ],
                  ),
                );
              }),
          GridView.builder(
              shrinkWrap: true,
              itemCount: gridItemList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image(
                              image: gridItemList[index].img,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                top: 10,
                                right: 12,
                                child: FavoriteButton(
                                  iconColor: Colors.black,
                                  iconSize: 35,
                                  isFavorite: true,
                                  valueChanged: (_isFavorite) {
                                    print(
                                      'Is Favorite $_isFavorite)',
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        gridItemList[index].name ?? '',
                        style: color000000w90020,
                      ),
                      Text(
                        gridItemList[index].price ?? '',
                        style: color999999w40020,
                      ),
                    ],
                  ),
                );
              }),
          GridView.builder(
              shrinkWrap: true,
              itemCount: gridItemList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image(
                              image: gridItemList[index].img,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                top: 10,
                                right: 12,
                                child: FavoriteButton(
                                  iconColor: Colors.black,
                                  iconSize: 35,
                                  isFavorite: true,
                                  valueChanged: (_isFavorite) {
                                    print(
                                      'Is Favorite $_isFavorite)',
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        gridItemList[index].name ?? '',
                        style: color000000w90020,
                      ),
                      Text(
                        gridItemList[index].price ?? '',
                        style: color999999w40020,
                      ),
                    ],
                  ),
                );
              }),
          GridView.builder(
              shrinkWrap: true,
              itemCount: gridItemList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Image(
                              image: gridItemList[index].img,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                                top: 10,
                                right: 12,
                                child: FavoriteButton(
                                  iconColor: Colors.black,
                                  iconSize: 35,
                                  isFavorite: true,
                                  valueChanged: (_isFavorite) {
                                    print(
                                      'Is Favorite $_isFavorite)',
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        gridItemList[index].name ?? '',
                        style: color000000w90020,
                      ),
                      Text(
                        gridItemList[index].price ?? '',
                        style: color999999w40020,
                      ),
                    ],
                  ),
                );
              }),
        ]),
      ),
    );
  }
}
