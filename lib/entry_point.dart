import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_green/screens/auth/login_screen.dart';
import 'package:go_green/screens/auth/signup_screen.dart';
import 'package:go_green/screens/category/category_screen.dart';
import 'package:go_green/screens/checkout/cart_screen.dart';
import 'package:go_green/screens/home/home_screen.dart';
import 'package:go_green/screens/profile/profile_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  SharedPreferences? prefs;
  int? userID;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getInt('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      HomeScreen(),
      // CategoryScreen(),
      // LoginScreen(),
      CartScreen(userID: userID.toString(),),
      ProfileScreen(
        userId: userID.toString(),
      ),
      // HomeScreen(),
      // DiscoverScreen(),
      // BookmarkScreen(),
      // // EmptyCartScreen(), // if Cart is empty
      // CartScreen(),
      // ProfileScreen(),
    ];

    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        // floating: true,
        // snap: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Text('GoGreen'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, searchScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Search.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, notificationsScreenRoute);
            },
            icon: SvgPicture.asset(
              "assets/icons/Notification.svg",
              height: 24,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                  BlendMode.srcIn),
            ),
          ),
        ],
      ),
      // body: _pages[_currentIndex],
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index != _currentIndex) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: svgIcon(
                "assets/icons/Shop.svg",
              ),
              activeIcon: svgIcon(
                "assets/icons/Shop.svg",
                color: primaryColor,
              ),
              label: "Shop",
            ),
            // BottomNavigationBarItem(
            //   icon: svgIcon(
            //     "assets/icons/Category.svg",
            //   ),
            //   activeIcon: svgIcon(
            //     "assets/icons/Category.svg",
            //     color: primaryColor,
            //   ),
            //   label: "Category",
            // ),
            // BottomNavigationBarItem(
            //   icon: svgIcon(
            //     "assets/icons/Bookmark.svg",
            //   ),
            //   activeIcon: svgIcon(
            //     "assets/icons/Bookmark.svg",
            //     color: primaryColor,
            //   ),
            //   label: "Bookmark",
            // ),
            BottomNavigationBarItem(
              icon: svgIcon(
                "assets/icons/Bag.svg",
              ),
              activeIcon: svgIcon(
                "assets/icons/Bag.svg",
                color: primaryColor,
              ),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: svgIcon(
                "assets/icons/Profile.svg",
              ),
              activeIcon: svgIcon(
                "assets/icons/Profile.svg",
                color: primaryColor,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
