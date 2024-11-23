import 'package:flutter/material.dart';
import 'package:go_green/admin/screens/orders/components/order_status_widget.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<List<dynamic>> fetchOrders() async {
    final response = await http.get(Uri.parse(liveApiDomain + 'api/orders'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Map<String, dynamic>?> fetchProductDetails(String productId) async {
    final response =
        await http.get(Uri.parse(liveApiDomain + 'api/products/$productId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['product'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetails(int userId) async {
    final response =
        await http.get(Uri.parse(liveApiDomain + 'api/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['user'];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final user = order['user'];
              final address = order['address'];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${order['order_id']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Order Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(order['created_at']))}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Full Name: ${user['fullname']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: ${user['email']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mobile Number: ${user['mobile_number']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Delivery Address: ${address['street_1']}, ${address['street_2']}, ${address['city']}, ${address['state']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total Amount: ₹${order['total_amount']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Shipping Fee: ₹100.00',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      // SizedBox(height: 8),
                      // Text(
                      //   'Order Status: ${order['order_status']}',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: order['order_status'] == 'Processing'
                      //         ? warningColor
                      //         : order['order_status'] == 'Delivered'
                      //             ? successColor
                      //             : order['order_status'] == 'Rejected'
                      //                 ? errorColor
                      //                 : Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      OrderStatusWidget(
                        initialStatus: order['order_status'],
                        orderId: order['order_id'],
                      ),
                      SizedBox(height: 8),
                      // Display order items
                      Text(
                        'Items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: List.generate(
                          order['order_items'].length,
                          (itemIndex) {
                            final item = order['order_items'][itemIndex];

                            return FutureBuilder<Map<String, dynamic>?>(
                              future: fetchProductDetails(
                                item['product_id'].toString(),
                              ),
                              builder: (context, productSnapshot) {
                                if (productSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Placeholder for product name
                                        Expanded(
                                          child: Text(
                                            'Loading...',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Placeholder for quantity
                                        Text(
                                          'Qty: ${item['quantity']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (productSnapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Error message
                                        Expanded(
                                          child: Text(
                                            'Error fetching product details',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Display quantity
                                        Text(
                                          'Qty: ${item['quantity']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  final product = productSnapshot.data;
                                  final productName =
                                      product?['product_name'] ??
                                          'Product not found';
                                  final productPrice =
                                      product?['product_price']?.toString() ??
                                          'N/A';

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Display product name
                                        Expanded(
                                          child: Text(
                                            productName,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Display quantity
                                        Text(
                                          'Qty: ${item['quantity']}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        // Display product price
                                        Text(
                                          '₹${productPrice}.00',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
