// ignore_for_file: prefer_const_constructors

import 'package:go_green/utility/CommonappBar.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              favorites,
              style: color000000w90038,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Expanded(
            child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: gridItemList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.51,
                ),
                itemBuilder: (context, index) {
                  return Column(
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
                                isFavorite: false,
                                valueChanged: (_isFavorite) {
                                  print(
                                    'Is Favorite $_isFavorite)',
                                  );
                                },
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        gridItemList[index].name ?? '',
                        style: color000000w90020,
                      ),
                      Text(
                        gridItemList[index].price ?? '',
                        style: color999999w40020,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
