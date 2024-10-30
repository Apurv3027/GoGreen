import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_green/utility/color_utilities.dart';
import 'package:go_green/utility/commonMaterialButton.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

import 'home_page.dart';

class ReceiptScreen extends StatefulWidget {
  final String orderID;
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const ReceiptScreen({
    Key? key,
    required this.orderID,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Receipt',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(HomeScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${widget.orderID}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Total Amount: ₹${widget.totalAmount}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ...widget.cartItems.map((item) {
              return Text(
                'Product ID: ${item['product_id']} - Quantity: ${item['quantity']}',
              );
            }).toList(),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: commonMatButton(
                onPressed: () {
                  generatePdfReceipt(
                    widget.orderID,
                    widget.totalAmount,
                    widget.cartItems,
                  );
                },
                txt: 'Download Receipt',
                buttonColor: cactusGreen,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: commonMatButton(
                onPressed: () {
                  sharePdfReceipt(
                    widget.orderID,
                    widget.totalAmount,
                    widget.cartItems,
                  );
                },
                txt: 'Share Receipt',
                buttonColor: cactusGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generatePdfReceipt(String orderID, double totalAmount,
      List<Map<String, dynamic>> cartItems) async {
    final pdf = pw.Document();

    // Load the font that supports the ₹ symbol
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Order Receipt',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text(
                'Order ID: $orderID',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: ttf,
                ),
              ),
              pw.Text(
                'Total Amount: ₹$totalAmount',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text(
                'Items:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              ...cartItems.map((item) {
                return pw.Text(
                  'Product ID: ${item['product_id']} - Quantity: ${item['quantity']}',
                  style: pw.TextStyle(
                    font: ttf,
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    // Display the PDF for preview and printing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'order_receipt_$orderID.pdf',
    );
  }

  void sharePdfReceipt(String orderID, double totalAmount,
      List<Map<String, dynamic>> cartItems) async {
    final pdf = pw.Document();

    // Load the font that supports the ₹ symbol
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Order Receipt',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Text(
                'Order ID: $orderID',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: ttf,
                ),
              ),
              pw.Text(
                'Total Amount: ₹$totalAmount',
                style: pw.TextStyle(
                  fontSize: 18,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Text(
                'Items:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(
                height: 10,
              ),
              ...cartItems.map((item) {
                return pw.Text(
                  'Product ID: ${item['product_id']} - Quantity: ${item['quantity']}',
                  style: pw.TextStyle(
                    font: ttf,
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    // Save or share the PDF with a custom name
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'order_receipt_$orderID.pdf',  // Custom PDF name
    );
  }
}
