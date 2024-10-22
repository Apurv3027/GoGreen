import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import '../utility/color_utilities.dart';
import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      final String url = liveApiDomain + 'api/users/$userId';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final userData = json.decode(response.body);
          setState(() {
            nameController.text = userData['fullname'] ?? '';
            emailController.text = userData['email'] ?? '';
            phoneController.text = userData['mobile_number'] ?? '';
          });
        } else {
          Get.snackbar('Error', 'Failed to fetch user data.',
              snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
      }
    } else {
      Get.snackbar('Error', 'User not logged in.',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      final String url = liveApiDomain + 'api/users/$userId';
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'fullname': nameController.text,
            'email': emailController.text,
            'mobile_number': phoneController.text,
          }),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          Get.back();
          Get.snackbar('Success', 'Profile updated successfully.', snackPosition: SnackPosition.TOP);
        } else {
          final responseBody = json.decode(response.body);
          Get.snackbar('Error', responseBody['message'] ?? 'Failed to update profile.', snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        print(e.toString());
        Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
      }
    } else {
      Get.snackbar('Error', 'User not logged in.', snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                commonTextField(
                  name: nameSuggestion,
                  suggestionTxt: enterName,
                  controller: nameController,
                ),
                SizedBox(
                  height: 30,
                ),
                commonTextField(
                  name: emailSuggestion,
                  suggestionTxt: enterMail,
                  controller: emailController,
                ),
                SizedBox(
                  height: 30,
                ),
                commonTextField(
                  name: phoneSuggestion,
                  suggestionTxt: enterPhone,
                  controller: phoneController,
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Align(
              alignment: Alignment.center,
              child: commonMatButton(
                onPressed: () {
                  updateUserProfile();
                },
                txt: save,
                buttonColor: cactusGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
