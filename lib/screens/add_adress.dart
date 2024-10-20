import 'package:get/get.dart';
import 'package:go_green/utility/CommonappBar.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/commonMaterialButton.dart';
import '../utility/commonTextField.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController street1Controller = TextEditingController();
  TextEditingController street2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }

      String street1 = street1Controller.text;
      String street2 = street2Controller.text;
      String city = cityController.text;
      String state = stateController.text;

      var data = {
        'street_1': street1,
        'street_2': street2,
        'city': city,
        'state': state,
      };

      // Send the address data to the server
      var response = await http.post(
        Uri.parse(
          liveApiDomain + 'api/user/$userId/address',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address Added Successfully')),
        );

        street1Controller.clear();
        street2Controller.clear();
        cityController.clear();
        stateController.clear();

        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add address')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  addNewAddress,
                  style: color000000w90038,
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: commonTextField(
                  name: street1,
                  suggestionTxt: enterStreet1,
                  controller: street1Controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Street 1';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: commonTextField(
                  name: street2,
                  suggestionTxt: enterStreet2,
                  controller: street2Controller,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: commonTextField(
                  name: city,
                  suggestionTxt: enterCity,
                  controller: cityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter City';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: commonTextField(
                  name: state,
                  suggestionTxt: enterState,
                  controller: stateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter State';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
                child: Align(
                  alignment: Alignment.center,
                  child: commonMatButton(
                    width: double.infinity,
                    onPressed: () {
                      _submitAddress();
                    },
                    txt: addNewAddress1,
                    buttonColor: cactusGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
