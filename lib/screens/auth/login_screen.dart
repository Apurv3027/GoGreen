import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/admin_home_page.dart';
import 'package:go_green/entry_point.dart';
import 'package:go_green/screens/auth/signup_screen.dart';
import 'package:go_green/theme/button_theme.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Future<void> storeUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  Future<void> loginUser(String email, String password) async{
    final String apiUrl = liveApiDomain + 'api/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Check if the user is an admin based on your user data
          // String email = email;
          print("Email: " + email);

          int userId = responseData['data']['user']['id']; // assuming this is where the user ID is
          await storeUserId(userId);

          if (email == "admin@gmail.com") {
            Get.dialog(
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display GIF
                      Image.asset(
                        'assets/icons/success.gif',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Admin Login Successful!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              barrierDismissible: false,
            );

            // Automatically close the popup after 3 seconds
            Future.delayed(const Duration(seconds: 3), () {
              Get.back();
              Get.offAll(AdminHomeScreen()); // Navigate to the Admin Home screen
            });
          } else {
            print(responseData['message']);

            Get.dialog(
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Display GIF
                      Image.asset(
                        'assets/icons/success.gif',
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'User Login Successful!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              barrierDismissible: false,
            );

            // Automatically close the popup after 3 seconds
            Future.delayed(const Duration(seconds: 3), () {
              Get.back(); // Close the dialog
              // There is 2 more screens while user complete their profile
              Get.offAll(EntryPoint()); // Navigate to the Home screen
            });
          }
        } else {
          // Show error message
          print(responseData['message']);
          Get.dialog(
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Error! Please try again.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: true,
          );
        }
      } else {
        // Show error message for any other status code
        Get.dialog(
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    'Error: Invalid login credentials. Please try again.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: true,
        );
      }
    } catch (e) {
      // Handle any other exceptions
      print(e.toString());
      Get.dialog(
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(
                  'Error! Please try again.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/img/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your data that you intered during your registration.",
                  ),
                  const SizedBox(height: defaultPadding),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (value) => email = value!,
                          validator: emaildValidator.call,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                              child: SvgPicture.asset(
                                "assets/icons/Message.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.3),
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        TextFormField(
                          onSaved: (value) => password = value!,
                          validator: passwordValidator.call,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                              child: SvgPicture.asset(
                                "assets/icons/Lock.svg",
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.3),
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        // Navigator.pushNamed(
                        //     context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height > 700
                        ? size.height * 0.1
                        : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        loginUser(email, password);
                        print("Email: " + email + "\nPassword: " + password);
                      }
                    },
                    child: const Text("Log in"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.to(SignUpScreen());
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
