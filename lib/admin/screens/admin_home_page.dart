import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/admin_drawer_screen.dart';
import 'package:go_green/admin/screens/banners/admin_banner_details_page.dart';
import 'package:go_green/admin/screens/category/admin_category_details_page.dart';
import 'package:go_green/admin/screens/products/admin_product_details_page.dart';
import 'package:go_green/admin/screens/users/admin_user_details_page.dart';
import 'package:go_green/admin/utility/DashboardCard.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Admin Dashboard',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.green,
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: charcoalBlack),

        // leading: const Icon(
        //   Icons.menu,
        //   size: 30,
        //   color: color000000,
        // ),
        backgroundColor: cactusGreen,
        elevation: 0,
        title: Text(
          // username,
          admin,
          style: color000000w90018,
        ),
        centerTitle: false,
      ),
      drawer: AdminDrawerScreen(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting or Dashboard Title
              Text(
                'Welcome, Admin!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Overview Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardCard(
                    title: 'Total Sales',
                    value: '\$1,000,000',
                    icon: Icons.monetization_on,
                    color: Colors.blue,
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  DashboardCard(
                    title: 'Orders',
                    value: '150',
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardCard(
                    title: 'Products',
                    value: '320',
                    icon: Icons.production_quantity_limits,
                    color: Colors.purple,
                    onTap: () {
                      Get.to(AdminProductDetailsPage());
                    },
                  ),
                  DashboardCard(
                    title: 'Users',
                    value: '500',
                    icon: Icons.people,
                    color: Colors.green,
                    onTap: () {
                      Get.to(AdminUserDetailsPage());
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardCard(
                    title: 'Categories',
                    value: '320',
                    icon: Icons.category,
                    color: Colors.blue,
                    onTap: () {
                      Get.to(AdminCategoryDetailsPage());
                    },
                  ),
                  DashboardCard(
                    title: 'Banners',
                    value: '500',
                    icon: Icons.image,
                    color: Colors.green,
                    onTap: () {
                      Get.to(AdminBannersDetailsPage());
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Recent Orders Section
              Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.shopping_bag),
                    title: Text('Order #$index'),
                    subtitle: Text('Total: \$${(index + 1) * 100}'),
                    trailing: Text(
                      'Status: Delivered',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}