import 'package:flutter/material.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderStatusWidget extends StatefulWidget {
  final String initialStatus;
  final String orderId;

  const OrderStatusWidget({
    required this.initialStatus,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderStatusWidget> createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  late String selectedStatus;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  Future<void> updateOrderStatus(String newStatus) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(liveApiDomain + 'api/orders/${widget.orderId}');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'order_status': newStatus}),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          selectedStatus = newStatus;
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order status updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order status.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Order Status: ${selectedStatus}',
              style: TextStyle(
                fontSize: 16,
                color: selectedStatus == 'Processing'
                    ? warningColor
                    : selectedStatus == 'Delivered'
                        ? successColor
                        : selectedStatus == 'Rejected'
                            ? errorColor
                            : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                isEditing ? Icons.cancel : Icons.edit,
                color: isEditing ? Colors.red : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
          ],
        ),
        if (isEditing)
          Column(
            children: [
              DropdownButton<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    updateOrderStatus(newValue);
                  }
                },
                items: <String>['Processing', 'Delivered', 'Rejected']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (isLoading) CircularProgressIndicator(),
            ],
          ),
      ],
    );
  }
}
