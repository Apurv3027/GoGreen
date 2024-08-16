import 'package:go_green/admin/screens/admin_home_page.dart';
import 'package:go_green/screens/forget_page.dart';
import 'package:go_green/screens/home_page.dart';
import 'package:go_green/screens/signup_page.dart';
import 'package:go_green/screens/welcomePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  bool _isObscure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: notAccount.tr,
              style: color999999w50018,
              children: [
                TextSpan(
                    text: signup.tr,
                    style: color7AFF18w50018.copyWith(color: cactusGreen),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(const SignupPage());
                      })
              ],
            ),
          ),
          const SizedBox(
            height: 26,
          )
        ],
      ),
      backgroundColor: softWhite,
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Get.offAll(const WelcomePage());
          },
          child: const Image(image: backArrow),
        ),
        backgroundColor: softWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                logIn,
                style: color000000w90022.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: charcoalBlack,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              commonTextField(
                name: emailSuggestion,
                suggestionTxt: enterMail,
                controller: emailController,
                action: TextInputAction.next,
              ),
              const SizedBox(
                height: 40,
              ),
              commonPasswordTextField(
                obsecure: !_isObscure,
                name: passwordSuggestion,
                action: TextInputAction.done,
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
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(const ForgetScreen());
                  },
                  child: Text(
                    forgate,
                    style: color000000w90018.copyWith(color: cactusGreen),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: commonMatButton(
                  // onPressed: () {
                  //   Get.offAll(
                  //     const HomeScreen(),
                  //   );
                  // },
                  onPressed: () {
                    String email = emailController.text.trim();

                    if (email == "admin@gmail.com") {
                      Get.offAll(
                        const AdminHomeScreen(),
                      );
                    } else {
                      Get.offAll(
                        const HomeScreen(),
                      );
                    }
                  },
                  txt: logIn,
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
