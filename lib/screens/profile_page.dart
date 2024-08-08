// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/edit_profile.dart';
import 'package:go_green/screens/home_page.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.offAll(HomeScreen()),
          child: Image(image: backArrow),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: GestureDetector(
                  onTap: () => Get.to(EditProfile()),
                  child: Image(
                    image: edit,
                    height: 60,
                  ),
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              profile,
              style: color000000w90038,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: colorCCCCCC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameSuggestion,
                    style: color999999w40016,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user,
                    style: color000000w90020,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: colorCCCCCC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emailSuggestion,
                    style: color999999w40016,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    mail,
                    style: color000000w90020,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
