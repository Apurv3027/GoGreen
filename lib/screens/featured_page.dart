// ignore_for_file: prefer_const_constructors

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class FeauturedScreen extends StatelessWidget {
  const FeauturedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
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
          featured,
          style: color000000w90018,
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
          shrinkWrap: true,
          itemCount: gridItemList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image(
                        image: gridItemList[index].img,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
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
    );
  }
}
