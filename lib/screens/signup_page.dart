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
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isObscure = false;

  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Method to register user
  Future<void> registerUser() async {
    final String apiUrl = liveApiDomain + 'api/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'fullname': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'mobile_number': phoneController.text,
        },
      );

      if (response.statusCode == 200) {
        // Decode the response
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Navigate to OTP Verification screen if registration is successful
          // Get.to(OtpVerification());

          Get.snackbar('Success', 'Register Successfully.',
              snackPosition: SnackPosition.TOP);
          Get.offAll(LogIn());
        } else {
          // Show error message
          Get.snackbar('Error', responseData['message'],
              snackPosition: SnackPosition.TOP);
        }
      } else {
        // Show error message for any other status code
        Get.snackbar('Error', 'Failed to register. Please try again.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      // Handle any other exceptions
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  style: color7AFF18w50018.copyWith(color: cactusGreen),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.offAll(LogIn());
                    })
            ],
          ),
        ),
      ),
      backgroundColor: softWhite,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image(image: backArrow),
        ),
        backgroundColor: softWhite,
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
                style: color000000w90022.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: charcoalBlack,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              commonTextField(
                name: nameSuggestion,
                suggestionTxt: enterName,
                controller: nameController,
                action: TextInputAction.next,
              ),
              SizedBox(
                height: 40,
              ),
              commonTextField(
                name: emailSuggestion,
                suggestionTxt: enterMail,
                controller: emailController,
                action: TextInputAction.next,
              ),
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
                    color: stoneGray,
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
                    // Call the register API method
                    registerUser();

                    // Get.to(
                    //   OtpVerification(),
                    // );
                  },
                  txt: signUp,
                  buttonColor: cactusGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
