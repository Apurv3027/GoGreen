import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/address/add_new_address_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  int? defaultAddressId;

  String userID = '';
  String fullname = '';
  String mobile_number = '';
  List<dynamic> addresses = [];
  bool isLoading = true;

  List<int> addressesToDelete = [];
  bool showDeleteButton = false;

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
          userID = data['data']['id'].toString();
          fullname = data['data']['fullname'];
          mobile_number = data['data']['mobile_number'];
          addresses = data['data']['addresses'];
          print(data['data']);
          isLoading = false;
        });
        print(data['data']);
        print(userID);
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

  Future<void> selectAddress(int addressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      return;
    }

    final url = liveApiDomain + 'api/user/$userId/select-address';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({'address_id': addressId}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          defaultAddressId = addressId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Failed to select address',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to select address: ${response.reasonPhrase}',
          ),
        ),
      );
    }
  }

  Future<void> deselectAddress(int addressId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      return;
    }

    final url = liveApiDomain + 'api/user/$userId/deselect-address';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'address_id': addressId,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          defaultAddressId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Failed to deselect address',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to deselect address: ${response.reasonPhrase}',
          ),
        ),
      );
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Address',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.more_vert,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       setState(() {
        //         showDeleteButton = !showDeleteButton;
        //       });
        //     },
        //   ),
        // ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refreshPage,
              child: RefreshIndicator(
                onRefresh: refreshPage,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    _buildSearchField(),
                    SizedBox(height: 20),
                    _buildAddNewAddress(),
                    SizedBox(height: 20),
                    if (showDeleteButton) _buildDeleteButton(),
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
                              return _buildAddressCard(
                                id: addresses[index]['id'],
                                addressLabel: fullname,
                                address:
                                    'Address: ${addresses[index]['street_1']}, ${addresses[index]['street_2']},\n${addresses[index]['city']}, ${addresses[index]['state']}',
                                phoneNumber: 'Mobile Number: ' + mobile_number,
                                icon: Icons.home,
                              );
                              // return _buildAddressCard(
                              //   id: addresses[index]['id'],
                              //   addressLabel: fullname,
                              //   address:
                              //       'Address: ${addresses[index]['street_1']}, ${addresses[index]['street_2']},\n${addresses[index]['city']}, ${addresses[index]['state']}',
                              //   phoneNumber: 'Mobile Number: ' + mobile_number,
                              //   icon: Icons.home,
                              //   isChecked: addressesToDelete.contains(addresses[index]['id']),
                              //   onCheckboxChanged: (value) {
                              //     setState(() {
                              //       if (value!) {
                              //         addressesToDelete.add(
                              //             addresses[index]['id']);
                              //       } else {
                              //         addressesToDelete.remove(
                              //             addresses[index]['id']);
                              //       }
                              //     });
                              //   }
                              // );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Find an address...',
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        suffixIcon: Icon(Icons.tune, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildAddNewAddress() {
    return GestureDetector(
      onTap: () {
        Get.to(AddNewAddressScreen());
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
            style: BorderStyle.solid,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              color: Colors.black.withOpacity(0.7),
            ),
            SizedBox(width: 12),
            Text(
              'Add New Address',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return TextButton(
      onPressed: () {
        // Handle delete action here
      },
      style: TextButton.styleFrom(
        backgroundColor: primaryColor.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Delete Selected Addresses',
        style: TextStyle(color: Colors.red),
      ),
    ).paddingOnly(bottom: 10);
  }

  Widget _buildAddressCard({
    required int id,
    required String addressLabel,
    required String address,
    required String phoneNumber,
    required IconData icon,
  }) {
    bool isSelected = defaultAddressId == id;

    return GestureDetector(
      onTap: () {
        if (defaultAddressId == id) {
          setState(() {
            defaultAddressId = null;
          });
          deselectAddress(id);
        } else {
          setState(() {
            defaultAddressId = id;
          });
          selectAddress(id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: defaultAddressId == id ? primaryColor : Colors.grey.shade300,
            width: defaultAddressId == id ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isSelected
                      ? primaryColor.withOpacity(0.1)
                      : Colors.grey.shade200,
                  child: Icon(
                    icon,
                    color: isSelected ? primaryColor : Colors.green,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    addressLabel,
                    style: TextStyle(
                      color: isSelected ? primaryColor : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: primaryColor,
                    size: 20,
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),
            Text(
              phoneNumber,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            if (isSelected)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ).paddingOnly(bottom: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: isSelected
                    ? primaryColor.withOpacity(
                        0.2,
                      )
                    : blackColor.withOpacity(
                        0.2,
                      ),
                child: Icon(
                  Icons.location_pin,
                  color: isSelected ? primaryColor : blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAddressCard({
  //   required int id,
  //   required String addressLabel,
  //   required String address,
  //   required String phoneNumber,
  //   required IconData icon,
  //   required bool isChecked,
  //   required ValueChanged<bool?> onCheckboxChanged,
  // }) {
  //   bool isSelected = defaultAddressId == id;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         defaultAddressId = (defaultAddressId == id) ? null : id;
  //       });
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(bottom: 16),
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: isSelected ? primaryColor : Colors.grey.shade300,
  //           width: isSelected ? 2 : 1,
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 20,
  //                 backgroundColor: isSelected
  //                     ? primaryColor.withOpacity(0.1)
  //                     : Colors.grey.shade200,
  //                 child: Icon(
  //                   icon,
  //                   color: isSelected ? primaryColor : Colors.green,
  //                   size: 20,
  //                 ),
  //               ),
  //               SizedBox(width: 12),
  //               Expanded(
  //                 child: Text(
  //                   addressLabel,
  //                   style: TextStyle(
  //                     color: isSelected ? primaryColor : Colors.black,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //               if (showDeleteButton) // Show checkbox if in delete mode
  //                 Checkbox(
  //                   value: isChecked,
  //                   onChanged: onCheckboxChanged,
  //                 ),
  //               if (isSelected)
  //                 Icon(
  //                   Icons.check_circle,
  //                   color: primaryColor,
  //                   size: 20,
  //                 ),
  //             ],
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             address,
  //             style: TextStyle(color: Colors.grey.shade700),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             phoneNumber,
  //             style: TextStyle(color: Colors.grey.shade700),
  //           ),
  //           if (isSelected)
  //             Align(
  //               alignment: Alignment.topRight,
  //               child: Container(
  //                 margin: EdgeInsets.only(top: 8),
  //                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                 decoration: BoxDecoration(
  //                   color: primaryColor.withOpacity(0.1),
  //                   borderRadius: BorderRadius.only(
  //                     topRight: Radius.circular(12),
  //                     bottomLeft: Radius.circular(12),
  //                   ),
  //                 ),
  //                 child: Text(
  //                   'Default',
  //                   style: TextStyle(
  //                     color: primaryColor,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ),
  //             ).paddingOnly(bottom: 10),
  //           Align(
  //             alignment: Alignment.bottomRight,
  //             child: CircleAvatar(
  //               radius: 20,
  //               backgroundColor: isSelected
  //                   ? primaryColor.withOpacity(
  //                       0.2,
  //                     )
  //                   : blackColor.withOpacity(
  //                       0.2,
  //                     ),
  //               child: Icon(
  //                 Icons.location_pin,
  //                 color: isSelected ? primaryColor : blackColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
