// ignore_for_file: prefer_const_constructors

import 'package:go_green/screens/add_adress.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdressPage extends StatefulWidget {
  const AdressPage({Key? key}) : super(key: key);

  @override
  State<AdressPage> createState() => _AdressPageState();
}

bool isChecked = false;
bool isChecked1 = false;

class _AdressPageState extends State<AdressPage> {

  List<dynamic> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserAddresses();
  }

  Future<void> fetchUserAddresses() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      return;
    }

    final url = liveApiDomain + 'api/user/$userId/addresses';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          addresses = data['data']['addresses'];
          print(data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Error', 'Failed to load addresses: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'An error occurred: $e');
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => Get.to(AddAddress()),
              child: Icon(
                Icons.add,
                size: 35,
                color: color000000,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                addressTxt,
                style: color000000w90038,
              ),
            ),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 30),
            // Display fetched addresses
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorFFFFFF,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addresses[index]['fullname'] ?? '',
                          style: color000000w90020,
                        ),
                        SizedBox(height: 10),
                        Text(
                          addresses[index]['street_1'] ?? '',
                          style: color000000w90016.copyWith(fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Text(
                          addresses[index]['street_2'] ?? '',
                          style: color000000w90016.copyWith(fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Text(
                          addresses[index]['city'] ?? '',
                          style: color000000w90016.copyWith(fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Text(
                          addresses[index]['state'] ?? '',
                          style: color000000w90016.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
