// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:go_green/screens/add_adress.dart';
import 'package:go_green/screens/payment_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/commonMaterialButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/assets_utility.dart';
import '../utility/cs.dart';
import '../utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdressPage extends StatefulWidget {
  final String userID;
  final String orderID;
  final String totalAmount;
  final List<dynamic> cartItems;
  const AdressPage({
    Key? key,
    required this.userID,
    required this.orderID,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<AdressPage> createState() => _AdressPageState();
}

bool isChecked = false;
bool isChecked1 = false;

class _AdressPageState extends State<AdressPage> {
  String fullname = '';
  List<dynamic> addresses = [];
  int? selectedAddressIndex;
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
          fullname = data['data']['fullname'];
          addresses = data['data']['addresses'];
          print(data['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
            'Error', 'Failed to load addresses: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> refreshPage() async {
    setState(() {
      isLoading = true;
    });
    await fetchUserAddresses();
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
          : RefreshIndicator(
              onRefresh: refreshPage,
              child: SingleChildScrollView(
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
                    addresses.isEmpty
                        ? Center(
                            child: Text(
                              'Address not found.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 18.0),
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
                                        offset: Offset(
                                          0.0,
                                          1,
                                        ),
                                      ),
                                    ],
                                    border: Border.all(
                                        color: color000000, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            fullname,
                                            style: color000000w90020,
                                          ),
                                          // Text(
                                          //   editTxt,
                                          //   style: colorFFCA27w50018.copyWith(
                                          //     fontWeight: FontWeight.w800,
                                          //     fontSize: 19,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: Text(
                                          "Street 1: " +
                                              addresses[index]['street_1'],
                                          style: color000000w90016.copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: Text(
                                          "Street 2: " +
                                              addresses[index]['street_2'],
                                          style: color000000w90016.copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: Text(
                                          "City: " + addresses[index]['city'],
                                          style: color000000w90016.copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 350,
                                        child: Text(
                                          "State: " + addresses[index]['state'],
                                          style: color000000w90016.copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Theme(
                                                child: Checkbox(
                                                  activeColor: cactusGreen,
                                                  focusColor: Colors.black,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -4,
                                                  ),
                                                  checkColor: Colors.white,
                                                  value: selectedAddressIndex ==
                                                      index,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      selectedAddressIndex =
                                                          value! ? index : null;
                                                    });
                                                  },
                                                ),
                                                data: ThemeData(
                                                  primarySwatch: Colors.blue,
                                                  unselectedWidgetColor:
                                                      Colors.grey, // Your color
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: 28,
                                              child: Text(
                                                checkBoxTxt,
                                                style:
                                                    color000000w50020.copyWith(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    if (selectedAddressIndex != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: commonMatButton(
                            width: double.infinity,
                            onPressed: () {
                              final selectedAddressId = addresses[selectedAddressIndex!]['id'];
                              Get.to(
                                PaymentScreen(
                                  userID: widget.userID.toString(),
                                  addressID: selectedAddressId.toString(),
                                  orderID: widget.orderID.toString(),
                                  totalAmount: widget.totalAmount.toString(),
                                  cartItems: widget.cartItems,
                                ),
                              );
                            },
                            txt: confirmOrder,
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
