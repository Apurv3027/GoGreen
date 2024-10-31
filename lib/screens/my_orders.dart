import 'dart:convert';
import 'dart:ui';

import 'package:go_green/utility/CommonappBar.dart';
import 'package:go_green/utility/assets_utility.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/cs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utility/text_utils.dart';
import 'order_details.dart';
import 'package:http/http.dart' as http;

class MyOrders extends StatefulWidget {
  final String userId;
  const MyOrders({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Future<List<dynamic>> fetchOrders() async {
    final response = await http
        .get(Uri.parse(liveApiDomain + 'api/orders/${widget.userId}'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: commonAppBar(),
      body: FutureBuilder<List<dynamic>>(
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(orders.length, (index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0.0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Displaying order details
                        Text(
                          'Order ID: ${order['order_id']}',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total Amount: ₹${order['total_amount']}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(order['created_at']))}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Delivery Address:',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${order['address']['street_1']}${order['address']['street_2']?.isNotEmpty == true ? ', ${order['address']['street_2']}' : ''}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${order['address']['city']}, ${order['address']['state']}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Items:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display each order item's name and quantity
                        Column(
                          children: List.generate(order['order_items'].length,
                              (itemIndex) {
                            final item = order['order_items'][itemIndex];

                            return FutureBuilder<Map<String, dynamic>?>(
                              future: fetchProductDetails(
                                  item['product_id'].toString()),
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
                                      vertical: 4.0,
                                    ),
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
                                              color: Colors.red,
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
                                      ],
                                    ),
                                  );
                                } else {
                                  final product = productSnapshot.data;
                                  final productName = product?[
                                          'product_name'] ??
                                      'Product not found'; // Assuming 'name' is the correct field
                                  final productPrice = product?['product_price']
                                          ?.toString() ??
                                      'N/A'; // Assuming 'product_price' is the correct field

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
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
                                          '₹${productPrice}',
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
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
