// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_green/screens/categories_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

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
          categories,
          style: color000000w90018,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(CategoriesProductPage());
              },
              child: Row(
                children: [
                  Image(
                    image: categoriesList[index].img,
                    height: 120,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoriesList[index].name ?? '',
                        style: color000000w90022,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        categoriesList[index].items ?? '',
                        style: color999999w40018,
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_right,
                    size: 30,
                  ),
                ],
              ),
            );
          },
          itemCount: categoriesList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(),
            );
          },
        ),
      ),
    );
  }
}
