import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_green/admin/screens/orders/order_status_list_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderListScreen extends StatefulWidget {
  final String userId;
  const OrderListScreen({super.key, required this.userId});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  Map<String, int> orderStatusCounts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrderStatusCounts(widget.userId);
  }

  Future<void> _fetchOrderStatusCounts(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          liveApiDomain + 'api/orders/${userId}',
        ),
      );

      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        final counts =
            Map<String, int>.from(data['data']['order_status_counts']);
        setState(() {
          orderStatusCounts = counts;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load order counts');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Find an order...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon:
                          const Icon(Icons.filter_list, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section title
                  const Text(
                    'Orders history',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Order status list
                  Expanded(
                    child: ListView(
                      children: orderStatusCounts.entries.map((entry) {
                        return _buildOrderStatusItem(
                          icon: _getIconForStatus(entry.key),
                          label: entry.key,
                          count: entry.value,
                          color: _getColorForStatus(entry.key),
                          onTap: () {
                            // Get.to(
                            //   OrderStatusListScreen(
                            //     userId: data['data']['orders']['user_id'],
                            //     orderStatus: data['data']['orders']['order_status'],
                            //   ),
                            // );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOrderStatusItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  IconData _getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.delivery_dining;
      case 'returned':
        return Icons.shopping_cart_outlined;
      case 'canceled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return warningColor;
      case 'delivered':
        return successColor;
      case 'returned':
        return errorColor;
      case 'canceled':
        return errorColor;
      default:
        return Colors.grey;
    }
  }
}
