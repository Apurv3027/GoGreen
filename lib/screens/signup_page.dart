// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/logIn_page.dart';
import 'package:go_green/screens/otp_page.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';

import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/text_utils.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isObscure = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: signUpAccount.tr,
            style: color999999w50018,
            children: [
              TextSpan(
                  text: signIn.tr,
                  style: color7AFF18w50018,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.offAll(LogIn());
                    })
            ],
          ),
        ),
      ),
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image(image: backArrow),
        ),
        backgroundColor: colorFFFFFF,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                signup,
                style: color000000w90022.copyWith(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              SizedBox(
                height: 40,
              ),
              commonTextField(name: nameSuggestion, suggestionTxt: enterName, controller: nameController, action: TextInputAction.next),
              SizedBox(
                height: 40,
              ),
              commonTextField(name: emailSuggestion, suggestionTxt: enterMail, controller: emailController, action: TextInputAction.next),
              SizedBox(
                height: 40,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: passwordSuggestion,
                action: TextInputAction.next,
                suggestionTxt: enterPassword,
                controller: passwordController,
                btn: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: colorFFCA27,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
              SizedBox(
                height: 40,
              ),
              commonTextField(
                action: TextInputAction.done,
                name: phoneSuggestion,
                suggestionTxt: enterPhone,
                controller: phoneController,
                keyBoard: TextInputType.number,
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                      onPressed: () {
                        Get.to(OtpVerification());
                      },
                      txt: signUp,
                      buttonColor: colorFFCA27)),
            ],
          ),
        ),
      ),
    );
  }
}