import 'package:flutter/material.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderStatusListScreen extends StatefulWidget {
  final String userId;
  final String orderStatus;

  const OrderStatusListScreen({
    super.key,
    required this.userId,
    required this.orderStatus,
  });

  @override
  State<OrderStatusListScreen> createState() => _OrderStatusListScreenState();
}

class _OrderStatusListScreenState extends State<OrderStatusListScreen> {
  bool isLoading = true;
  List<dynamic> orders = [];
  Map<String, int> orderStatusCounts = {};

  @override
  void initState() {
    super.initState();
    _fetchDeliveredOrders(
      widget.userId,
      widget.orderStatus,
    );
  }

  Future<void> _fetchDeliveredOrders(String userId, String orderStatus) async {
    final url = liveApiDomain + 'api/orders/${orderStatus}/${userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          orders = data['data']['orders'] ?? [];
          orderStatusCounts = {
            orderStatus : orders.length,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showError('Failed to fetch orders');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                      children: _buildOrderStatusItems(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildOrderStatusItems() {
    return orderStatusCounts.entries.map((entry) {
      return _buildOrderStatusItem(
        label: entry.key,
        count: entry.value,
      );
    }).toList();
  }

  Widget _buildOrderStatusItem({
    required String label,
    required int count,
  }) {
    // You can customize this to display icons based on status
    IconData icon = Icons.check_circle; // Example icon
    Color color = Colors.green; // Example color for delivered orders

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
