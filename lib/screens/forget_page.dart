// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/otp_page.dart';
import 'package:go_green/utility/commonMaterialButton.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/color_utilities.dart';
import '../utility/commonTextField.dart';
import '../utility/text_utils.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 31,
          ),
        ),
        backgroundColor: colorFFFFFF,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forGet,
                style: color000000w90022.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26, right: 80, bottom: 32),
                child: Text(
                  forgetTxt,
                  style: color999999w50018,
                  maxLines: 3,
                ),
              ),
              commonTextField(
                  name: emailSuggestion,
                  suggestionTxt: enterMail,
                  controller: emailController),
              SizedBox(height: 52),
              Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                      onPressed: () {
                        Get.to(OtpVerification());
                      },
                      txt: send,
                      buttonColor: colorFFCA27)),
            ],
          ),
        ),
      ),
    );
  }
}
