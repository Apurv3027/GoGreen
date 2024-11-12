import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/address/addresses_screen.dart';
import 'package:go_green/screens/auth/login_screen.dart';
import 'package:go_green/screens/profile/components/profile_card.dart';
import 'package:go_green/screens/profile/components/profile_menu_item_list_tile.dart';
import 'package:go_green/screens/userinfo/user_info_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.userId);
  }

  Future<void> fetchUserDetails(String userId) async {
    final url = liveApiDomain + 'api/users/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body)['user'];
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : userData != null
              ? RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView(
                    children: [
                      userData == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ProfileCard(
                              name: userData!['fullname'],
                              email: userData!['email'],
                              imageSrc: "https://i.imgur.com/IXnwbLk.png",
                              // proLableText: "Sliver",
                              // isPro: true, // if the user is pro
                              press: () {
                                Get.to(UserInfoScreen(userDetails: userData!));
                              },
                            ),
                      Divider(
                        thickness: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                        ),
                        child: Text(
                          "Account",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      ProfileMenuListTile(
                        text: "Orders",
                        svgSrc: "assets/icons/Order.svg",
                        press: () {
                          // Navigator.pushNamed(context, ordersScreenRoute);
                        },
                      ),
                      // ProfileMenuListTile(
                      //   text: "Returns",
                      //   svgSrc: "assets/icons/Return.svg",
                      //   press: () {},
                      // ),
                      ProfileMenuListTile(
                        text: "Wishlist",
                        svgSrc: "assets/icons/Wishlist.svg",
                        press: () {},
                      ),
                      ProfileMenuListTile(
                        text: "Addresses",
                        svgSrc: "assets/icons/Address.svg",
                        press: () {
                          Get.to(AddressesScreen());
                        },
                      ),
                      ProfileMenuListTile(
                        text: "Payment",
                        svgSrc: "assets/icons/card.svg",
                        press: () {
                          // Navigator.pushNamed(context, emptyPaymentScreenRoute);
                        },
                      ),
                      // ProfileMenuListTile(
                      //   text: "Wallet",
                      //   svgSrc: "assets/icons/Wallet.svg",
                      //   press: () {
                      //     // Navigator.pushNamed(context, walletScreenRoute);
                      //   },
                      // ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: defaultPadding,
                      //       vertical: defaultPadding / 2),
                      //   child: Text(
                      //     "Personalization",
                      //     style: Theme.of(context).textTheme.titleSmall,
                      //   ),
                      // ),
                      // DividerListTileWithTrilingText(
                      //   svgSrc: "assets/icons/Notification.svg",
                      //   title: "Notification",
                      //   trilingText: "Off",
                      //   press: () {
                      //     // Navigator.pushNamed(context, enableNotificationScreenRoute);
                      //   },
                      // ),
                      // ProfileMenuListTile(
                      //   text: "Preferences",
                      //   svgSrc: "assets/icons/Preferences.svg",
                      //   press: () {
                      //     // Navigator.pushNamed(context, preferencesScreenRoute);
                      //   },
                      // ),
                      // const SizedBox(height: defaultPadding),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2,
                        ),
                        child: Text(
                          "Settings",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      ProfileMenuListTile(
                        text: "Language",
                        svgSrc: "assets/icons/Language.svg",
                        press: () {
                          // Navigator.pushNamed(context, selectLanguageScreenRoute);
                        },
                      ),
                      // ProfileMenuListTile(
                      //   text: "Location",
                      //   svgSrc: "assets/icons/Location.svg",
                      //   press: () {},
                      // ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: defaultPadding,
                      //       vertical: defaultPadding / 2),
                      //   child: Text(
                      //     "Help & Support",
                      //     style: Theme.of(context).textTheme.titleSmall,
                      //   ),
                      // ),
                      // ProfileMenuListTile(
                      //   text: "Get Help",
                      //   svgSrc: "assets/icons/Help.svg",
                      //   press: () {
                      //     // Navigator.pushNamed(context, getHelpScreenRoute);
                      //   },
                      // ),
                      // ProfileMenuListTile(
                      //   text: "FAQ",
                      //   svgSrc: "assets/icons/FAQ.svg",
                      //   press: () {},
                      //   isShowDivider: false,
                      // ),
                      // const SizedBox(height: defaultPadding),

                      // Log Out
                      ListTile(
                        onTap: () {
                          Get.offAll(
                            LoginScreen(),
                          );
                        },
                        minLeadingWidth: 24,
                        leading: SvgPicture.asset(
                          "assets/icons/Logout.svg",
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                            errorColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        title: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: errorColor,
                            fontSize: 14,
                            height: 1,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'User not found',
                  ),
                ),
    );
  }
}
