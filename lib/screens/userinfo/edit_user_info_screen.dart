import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditUserInfoScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const EditUserInfoScreen({
    super.key,
    required this.userDetails,
  });

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fullnameController.text = widget.userDetails['fullname'] ?? '';
    _emailController.text = widget.userDetails['email'] ?? '';
    _mobileNumberController.text = widget.userDetails['mobile_number'] ?? '';
  }

  Future<void> updateUserDetails(String userId) async {
    print(
      _fullnameController.text.isNotEmpty
          ? _fullnameController.text
          : widget.userDetails['fullname'] ?? '',
    );
    print(
      _emailController.text.isNotEmpty
          ? _emailController.text
          : widget.userDetails['email'] ?? '',
    );
    print(
      _mobileNumberController.text.isNotEmpty
          ? _mobileNumberController.text
          : widget.userDetails['mobile_number'] ?? '',
    );

    final url = liveApiDomain + 'api/users/$userId';

    final Map<String, dynamic> requestData = {
      // 'fullname': _fullnameController.text,
      // 'email': _emailController.text,
      // 'mobile_number': _mobileNumberController.text,

      'fullname': _fullnameController.text.isNotEmpty
          ? _fullnameController.text
          : widget.userDetails['fullname'] ?? '',
      'email': _emailController.text.isNotEmpty
          ? _emailController.text
          : widget.userDetails['email'] ?? '',
      'mobile_number': _mobileNumberController.text.isNotEmpty
          ? _mobileNumberController.text
          : widget.userDetails['mobile_number'] ?? '',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          // widget.userDetails['fullname'] = _fullnameController.text;
          // widget.userDetails['email'] = _emailController.text;
          // widget.userDetails['mobile_number'] = _mobileNumberController.text;
          widget.userDetails['fullname'] = requestData['fullname'];
          widget.userDetails['email'] = requestData['email'];
          widget.userDetails['mobile_number'] = requestData['mobile_number'];
          isLoading = false;
        });
        print(responseData['message'] ?? 'Profile updated successfully.');

        // Success Message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Text('Success'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/icons/success.gif',
                    height: 100,
                    width: 100,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      100,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  responseData['message'] ?? 'Profile updated successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print(response.body);
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error updating profile: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/info.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.bodyLarge!.color!,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              // Info action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  child: Image.asset(
                    'assets/img/person.png',
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      100,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileField(
              icon: Icons.person,
              label: widget.userDetails['fullname'] ?? 'N/A',
              controller: _fullnameController,
            ),
            SizedBox(height: 10),
            _buildProfileField(
              icon: Icons.mail_outline,
              label: widget.userDetails['email'] ?? 'N/A',
              controller: _emailController,
              isEditable: false,
            ),
            // SizedBox(height: 10),
            // _buildProfileField(
            //   icon: Icons.calendar_today,
            //   label: widget.userDetails['dob'] ?? 'N/A',
            // ),
            SizedBox(height: 10),
            _buildProfileField(
              icon: Icons.phone,
              label: widget.userDetails['mobile_number'] ?? 'N/A',
              controller: _mobileNumberController,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                updateUserDetails(widget.userDetails['id'].toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(
                  double.infinity,
                  50,
                ),
              ),
              child: Text(
                isLoading ? 'Update Profile' : 'Done',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool isEditable = true,
  }) {
    return TextField(
      controller: controller,
      enabled: isEditable,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade100,
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   child: Row(
    //     children: [
    //       Icon(icon, color: Colors.black54),
    //       SizedBox(width: 12),
    //       Expanded(
    //         child: TextField(
    //           controller: controller,
    //           decoration: InputDecoration(
    //             hintText: label,
    //             border: InputBorder.none,
    //             isCollapsed: true,
    //           ),
    //           style: TextStyle(fontSize: 16, color: Colors.black),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
