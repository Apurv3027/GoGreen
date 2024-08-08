// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Image(image: backArrow),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              editProfile,
              style: color000000w90038,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                commonTextField(name: nameSuggestion, suggestionTxt: enterName, controller: nameController),
                SizedBox(
                  height: 30,
                ),
                commonTextField(name: emailSuggestion, suggestionTxt: enterMail, controller: emailController),
              ],
            ),
          ),
          Spacer(),
          Align(
              alignment: Alignment.center,
              child: commonMatButton(
                  onPressed: () {
                    Get.back();
                  },
                  txt: save,
                  buttonColor: colorFFCA27)),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
