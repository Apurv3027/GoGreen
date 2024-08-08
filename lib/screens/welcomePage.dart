import 'package:go_green/screens/logIn_page.dart';
import 'package:go_green/screens/signup_page.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/common_welcome_button.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: welcomeBg, fit: BoxFit.cover),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Image(
              image: welcomeShadow,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(42.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),

                    const Image(
                      image: logo,
                      height: 150,
                    ),
                    const Spacer(),
                    // MaterialButton(
                    //   onPressed: () {},
                    //   child: Text("My text"),
                    //   color: Colors.white,
                    //   minWidth: double.infinity,
                    //   height: 50,
                    // ),

                    commonWelcomeButton(
                        onPressed: () {
                          Get.to(LogIn());
                        },
                        buttonColor: colorFFFFFF,
                        txt: login,
                        minWidth: 500),
                    const SizedBox(
                      height: 15,
                    ),
                    commonWelcomeButton(
                        onPressed: () {
                          Get.to(const SignupPage());
                        },
                        buttonColor: colorFFCA27,
                        txt: signUp,
                        minWidth: 500),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
