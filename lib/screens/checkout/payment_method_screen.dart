import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_green/screens/checkout/confirm_order_screen.dart';
import 'package:go_green/screens/home/components/categories.dart';
import 'package:go_green/screens/payment_screen.dart';
import 'package:go_green/utility/constants.dart';
import 'package:go_green/utility/cs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String userID;
  final String addressID;
  final String orderID;
  final String subTotalAmount;
  final String shippingFeeAmount;
  final String totalAmount;
  final List<dynamic> cartItems;

  const PaymentMethodScreen({
    Key? key,
    required this.userID,
    required this.addressID,
    required this.orderID,
    required this.subTotalAmount,
    required this.shippingFeeAmount,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int activeIndex = 0;

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
    // Check if userData is not null and has valid keys
    if (userData != null &&
        userData!['fullname'] != null &&
        userData!['mobile_number'] != null &&
        userData!['email'] != null) {
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
    } else {
      // Handle the error where userData or its keys are null
      print("Error: user data or required fields are null");
      Fluttertoast.showToast(msg: "Error: User data is incomplete.");
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
    String paymentId = generatePaymentId();
    print("Payment ID: ${paymentId}");

    // Prepare the cart data from the widget's cart items
    final List<Map<String, dynamic>> cartData = widget.cartItems.map((item) {
      return {
        'product_id': item['id'], // Adjust key to match your database
        'quantity': item['quantity'] ?? 1,
      };
    }).toList(); // Prepare the cart data

    // Make a POST request to create the order
    final res = await http.post(
      Uri.parse(liveApiDomain + 'api/create-orders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': widget.userID,
        'address_id': widget.addressID,
        'order_id': widget.orderID,
        'total_amount': widget.totalAmount,
        'payment_type': 'Online Payment',
        'payment_id': paymentId,
      }),
    );

    print(liveApiDomain + 'api/orders');
    print(res.headers['location']);
    print(res.statusCode);
    print(res.body);

    // Check the response status
    if (res.statusCode == 201) {
      final responseData = jsonDecode(res.body);
      Fluttertoast.showToast(
        msg: "Order created successfully: ${responseData['data']['order_id']}",
      );
      // Get.offAll(HomeScreen());
      Get.to(
        ConfirmOrderScreen(
          userID: widget.userID,
          orderID: widget.orderID,
          totalAmount: widget.totalAmount,
          paymentMethod: 0,
          deliveryCharge: 0.0,
          cartItems: widget.cartItems,
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to create order: ${res.reasonPhrase}",
      );
    }
  }

  void handlePaymentError(PaymentFailureResponse response) async {
    print("Payment Error: ${response.message}");
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  String generatePaymentId() {
    const prefix = 'pay_';
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const length = 14;
    final random = Random();

    // Generate a random 14-character string
    String randomString = List.generate(
      length,
      (index) => characters[random.nextInt(
        characters.length,
      )],
    ).join();

    return '$prefix$randomString';
  }

  void confirmOrder() async {
    String paymentId = generatePaymentId();
    print("Payment ID: ${paymentId}");

    // Prepare the cart data from the widget's cart items
    final List<Map<String, dynamic>> cartData = widget.cartItems.map((item) {
      return {
        'product_id': item['id'], // Adjust key to match your database
        'quantity': item['quantity'] ?? 1,
      };
    }).toList(); // Prepare the cart data

    // Make a POST request to create the order
    final res = await http.post(
      Uri.parse(liveApiDomain + 'api/create-orders'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': widget.userID,
        'address_id': widget.addressID,
        'order_id': widget.orderID,
        'total_amount': widget.totalAmount,
        'payment_type': 'Cash on Delivery',
        'payment_id': paymentId,
      }),
    );

    print(liveApiDomain + 'api/orders');
    print(res.headers['location']);
    print(res.statusCode);
    print(res.body);

    // Check the response status
    if (res.statusCode == 201) {
      final responseData = jsonDecode(res.body);
      Fluttertoast.showToast(
        msg: "Order created successfully: ${responseData['data']['order_id']}",
      );
      print(responseData);
      // Get.offAll(HomeScreen());
      Get.to(
        ConfirmOrderScreen(
          userID: widget.userID,
          orderID: widget.orderID,
          totalAmount: activeIndex == 0
              ? widget.totalAmount
              : (double.parse(widget.totalAmount) + 40).toString(),
          paymentMethod: activeIndex == 0 ? 0 : 1,
          deliveryCharge: activeIndex == 0 ? 0.0 : 40.0,
          cartItems: widget.cartItems,
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to create order: ${res.reasonPhrase}",
      );
    }
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
        title: const Text('Payment Method'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/info.svg",
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 20),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SizedBox(width: 10),
            //       ...List.generate(
            //         2,
            //         (index) => Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 10),
            //           child: PaymentMethodCategoryBtn(
            //             svgSrc: index == 0
            //                 ? 'assets/icons/Payonline.svg'
            //                 : 'assets/icons/Cash.svg',
            //             category:
            //                 index == 0 ? 'Online Payment' : 'Cash on Delivery',
            //             isActive: index == activeIndex,
            //             press: () {
            //               setState(() {
            //                 activeIndex = index;
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 10),
            //     ],
            //   ),
            // ),
            SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/Illustration/Illustration-2.png',
                    height: 300,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Online Payment',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pay securely with your credit/debit card or other online payment methods.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            // Center(
            //   child: Column(
            //     children: [
            //       Image.asset(
            //         activeIndex == 0
            //             ? 'assets/Illustration/Illustration-2.png'
            //             : 'assets/Illustration/PayWithCash_lightTheme.png',
            //         height: 300,
            //       ),
            //       SizedBox(height: 30),
            //       Text(
            //         activeIndex == 0 ? 'Online Payment' : 'Cash on Delivery',
            //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
            //               fontSize: 24,
            //             ),
            //       ),
            //       SizedBox(height: 10),
            //       Text(
            //         activeIndex == 0
            //             ? 'Pay securely with your credit/debit card or other online payment methods.'
            //             : 'A GoGreen refundable \₹40.00 will be \ncharged to use cash on delivery, if you want \nto save this amount please switch to Pay with \nCard.',
            //         textAlign: TextAlign.center,
            //         style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //               fontSize: 16,
            //             ),
            //         softWrap: true,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            openCheckout();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Pay Online'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: primaryColor,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //     ),
      //     onPressed: () {
      //       // Handle button press
      //       print('Confirm button pressed');
      //       print(activeIndex == 0
      //           ? widget.totalAmount
      //           : (double.parse(widget.totalAmount) + 40).toString());
      //
      //       activeIndex == 0 ? openCheckout() : confirmOrder();
      //     },
      //     child: Padding(
      //       padding: EdgeInsets.symmetric(vertical: 5),
      //       child: Text(
      //         activeIndex == 0
      //             ? 'Pay Online'.toUpperCase()
      //             : 'Confirm Order'.toUpperCase(),
      //         style: TextStyle(
      //           fontSize: 18,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class PaymentMethodCategoryBtn extends StatelessWidget {
  const PaymentMethodCategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          20,
        ),
      ),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
        ),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
            color:
                isActive ? Colors.transparent : Theme.of(context).dividerColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null)
              const SizedBox(
                width: defaultPadding / 2,
              ),
            Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
