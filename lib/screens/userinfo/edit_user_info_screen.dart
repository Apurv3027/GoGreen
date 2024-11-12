import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/network_image_with_loader.dart';

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
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: NetworkImageWithLoader(
                      widget.userDetails['profilePicture'] ??
                          'https://i.imgur.com/IXnwbLk.png',
                      radius: 100,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Edit photo action
              },
              child: Text(
                'Edit photo',
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileField(
              icon: Icons.person,
              label: widget.userDetails['fullname'] ?? 'N/A',
            ),
            SizedBox(height: 10),
            _buildProfileField(
              icon: Icons.mail_outline,
              label: widget.userDetails['email'] ?? 'N/A',
            ),
            SizedBox(height: 10),
            _buildProfileField(
              icon: Icons.calendar_today,
              label: widget.userDetails['dob'] ?? 'N/A',
            ),
            SizedBox(height: 10),
            _buildProfileField(
              icon: Icons.phone,
              label: widget.userDetails['mobile_number'] ?? 'N/A',
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Done action
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
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
