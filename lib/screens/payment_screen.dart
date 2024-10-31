import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/home_page.dart';
import 'package:go_green/screens/receipt_screen.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/commonMaterialButton.dart';
import 'package:go_green/utility/cs.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  final String userID;
  final String addressID;
  final String orderID;
  final String totalAmount;
  final List<dynamic> cartItems;

  const PaymentScreen({
    Key? key,
    required this.userID,
    required this.addressID,
    required this.orderID,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay razorpay;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    super.initState();

    fetchUserData();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_9krRg98kdpHw85',
      'amount': (double.parse(widget.totalAmount) * 100).toInt(),
      'name': userData!['fullname'],
      'description': 'Payment for order ID: ${widget.orderID}',
      'prefill': {
        'contact': userData!['mobile_number'],
        'email': userData!['email'],
      },
      'theme': {
        'color': '#FF6B8E23',
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchUserData() async {
    final url = liveApiDomain + 'api/users/${widget.userID}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body)['user'];
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success: ${response.paymentId}");
    Fluttertoast.showToast(msg: "Payment Success");

    // Prepare the cart data from the widget's cart items
    final List<Map<String, dynamic>> cartData = widget.cartItems.map((item) {
      return {
        'product_id': item['id'], // Adjust key to match your database
        'quantity': item['quantity'] ?? 1,
      };
    }).toList(); // Prepare the cart data

    // Make a POST request to create the order
    final res = await http.post(
      Uri.parse(liveApiDomain + 'api/orders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': widget.userID,
        'address_id': widget.addressID,
        'order_id': widget.orderID,
        'total_amount': widget.totalAmount,
      }),
    );

    // Check the response status
    if (res.statusCode == 201) {
      final responseData = jsonDecode(res.body);
      Fluttertoast.showToast(
          msg:
              "Order created successfully: ${responseData['data']['order_id']}");
      // Get.offAll(HomeScreen());
      Get.offAll(
        ReceiptScreen(
          orderID: responseData['data']['order_id'],
          totalAmount: double.parse(widget.totalAmount),
          cartItems: cartData,
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Failed to create order: ${res.reasonPhrase}");
    }
  }

  void handlePaymentError(PaymentFailureResponse response) async {
    print("Payment Error: ${response.message}");
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  @override
  void dispose() {
    super.dispose();

    try {
      razorpay.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Summary'),
        backgroundColor: cactusGreen,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  buildDetailRow('Full Name:', userData!['fullname']),
                  buildDetailRow('Email:', userData!['email']),
                  buildDetailRow('Mobile Number:', userData!['mobile_number']),
                  SizedBox(height: 20),
                  Text(
                    'Order Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  buildDetailRow('Order ID:', widget.orderID),
                  buildDetailRow('Total Amount:', '₹${widget.totalAmount}'),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: commonMatButton(
                      onPressed: openCheckout,
                      txt: 'Pay Now: ₹${widget.totalAmount}',
                      buttonColor: cactusGreen,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
