import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/network_image_with_loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController street1Controller = TextEditingController();
  final TextEditingController street2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  bool isLoading = false;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add New Address',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                child: SvgPicture.asset(
                  'assets/icons/Address.svg',
                  height: 50,
                  width: 50,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              _buildTextField(controller: street1Controller, label: 'Street 1'),
              _buildTextField(controller: street2Controller, label: 'Street 2'),
              _buildTextField(controller: cityController, label: 'City'),
              _buildTextField(controller: stateController, label: 'State'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _submitAddress,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
