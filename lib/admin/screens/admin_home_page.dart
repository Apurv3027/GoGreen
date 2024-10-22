import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/admin_drawer_screen.dart';
import 'package:go_green/admin/screens/banners/admin_banner_details_page.dart';
import 'package:go_green/admin/screens/category/admin_category_details_page.dart';
import 'package:go_green/admin/screens/orders/order_details.dart';
import 'package:go_green/admin/screens/products/admin_product_details_page.dart';
import 'package:go_green/admin/screens/users/admin_user_details_page.dart';
import 'package:go_green/admin/utility/DashboardCard.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:go_green/utility/text_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  int orderCount = 0;
  int productCount = 0;
  int userCount = 0;
  int categoryCount = 0;
  int bannerCount = 0;

  @override
  void initState() {
    super.initState();
    fetchOrderCount().then((count) {
      setState(() {
        orderCount = count;
      });
    });
    fetchProductCount().then((count) {
      setState(() {
        productCount = count;
      });
    });
    fetchUserCount().then((count) {
      setState(() {
        userCount = count;
      });
    });
    fetchCategoryCount().then((count) {
      setState(() {
        categoryCount = count;
      });
    });
    fetchBannerCount().then((count) {
      setState(() {
        bannerCount = count;
      });
    });
  }

  Future<int> fetchOrderCount() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/orders'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['totalOrders'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> fetchProductCount() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['totalProducts'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> fetchUserCount() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/users'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['totalUsers'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> fetchCategoryCount() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/categories'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['totalCategories'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> fetchBannerCount() async {
    try {
      final response = await http.get(Uri.parse(liveApiDomain + 'api/banners'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['totalBanners'];
      } else {
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<List<dynamic>> fetchOrders() async {
    final response = await http.get(Uri.parse(liveApiDomain + 'api/orders'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: charcoalBlack),
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
                    value: '₹ 1,000,000',
                    icon: Icons.monetization_on,
                    color: Colors.blue,
                    onTap: () {
                      // Handle tap
                    },
                  ),
                  DashboardCard(
                    title: 'Orders',
                    value: orderCount.toString(),
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                    onTap: () {
                      Get.to(OrderDetails());
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
                    value: productCount.toString(),
                    icon: Icons.production_quantity_limits,
                    color: Colors.purple,
                    onTap: () {
                      Get.to(AdminProductDetailsPage());
                    },
                  ),
                  DashboardCard(
                    title: 'Users',
                    value: userCount.toString(),
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
                    value: categoryCount.toString(),
                    icon: Icons.category,
                    color: Colors.blue,
                    onTap: () {
                      Get.to(AdminCategoryDetailsPage());
                    },
                  ),
                  DashboardCard(
                    title: 'Banners',
                    value: bannerCount.toString(),
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
              FutureBuilder<List<dynamic>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No orders found.'));
                  }

                  final orders = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ListTile(
                        leading: Icon(Icons.shopping_bag),
                        title: Text('Order #${order['order_id']}'),
                        trailing: Text(
                          'Total: ₹${order['total_amount']}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
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