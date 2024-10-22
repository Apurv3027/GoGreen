// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/edit_profile.dart';
import 'package:go_green/screens/home_page.dart';
import 'package:go_green/screens/widgets/ProfileTextWidget.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.userId);
  }

  Future<void> fetchUserDetails(String userId) async {
    final url =
        liveApiDomain + 'api/users/$userId'; // Replace with your API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          user = json.decode(response.body)['user'];
          isLoading = false;
        });
      } else {
        print('Failed to load user');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await fetchUserDetails(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: colorFFFFFF,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            Get.offAll(HomeScreen());
          },
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user != null
              ? RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView(
                    padding: EdgeInsets.all(10.0),
                    children: [
                      Text(
                        profile,
                        style: color000000w90038,
                      ),
                      Divider(height: 1, thickness: 1),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: commonTextDisplay(
                          title: nameSuggestion,
                          value: user!['fullname'],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: commonTextDisplay(
                          title: emailSuggestion,
                          value: user!['email'],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: commonTextDisplay(
                          title: phoneSuggestion,
                          value: user!['mobile_number'],
                        ),
                      ),
                    ],
                  ),
                )
              : Center(child: Text('User not found')),
    );
  }
}
