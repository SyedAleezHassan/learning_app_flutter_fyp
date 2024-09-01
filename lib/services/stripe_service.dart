// import 'package:http/http.dart' as http;

// ignore_for_file: avoid_print

// import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import "package:flutter_application_1/constants.dart";
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  Future<void> makePayment(Function onSuccess) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(50, "USD");
      if (paymentIntentClientSecret == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Syeds",
        ),
      );

      // Call processPayment and pass the onSuccess callback
      await processPayment(onSuccess);
    } catch (e) {
      print("Error during payment initialization: $e");
    }
  }

//ye wala working.................
  // Future<void> makePayment(
  //     BuildContext context, String courseName, String price) async {
  //   try {
  //     String? paymentIntentClientSecret = await _createPaymentIntent(50, "USD");
  //     if (paymentIntentClientSecret == null) return;
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntentClientSecret,
  //             merchantDisplayName: "Syeds"));

  //     await processPayment(context, courseName, price);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> makePayment() async {
  //   try {
  //     String? paymentIntentClientSecret = await _createPaymentIntent(50, "USD");
  //     if (paymentIntentClientSecret == null) return;
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntentClientSecret,
  //             merchantDisplayName: "Syeds"));
  //     await processPayment();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency
      };
      // var url = Uri.parse("https://api.stripe.com/v1/payment_intents");
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer ${Constants.stripeSecreteKey}",
            "Content-Type": 'application/x-www-form-urlencoded',
          }));
      if (response.data != null) {
        print(response.data);
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> processPayment(Function onSuccess) async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      Future.delayed(Duration(seconds: 1), () {
        print('@@@@@@maal agy maal agya@@@@@@@@');
        onSuccess(); // Call success dialog after 2 seconds
      });

      // Confirm the payment, throws an error if something goes wrong
      await Stripe.instance.confirmPaymentSheetPayment();

      // If everything succeeds, trigger the onSuccess callback
    } catch (e) {
      print("Payment failed: $e");
      // You can add a failure handler here if you want to show a failure dialog
    }
  }

//working ............
  // Future<void> processPayment(
  //     BuildContext context, String courseName, String price) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //      Future.delayed(Duration(seconds: 2), () {
  //       print('@@@@@@maal agy maal agya@@@@@@@@');
  //       _showSuccessDialog(
  //           context, courseName, price); // Call success dialog after 2 seconds
  //     });
  //     await Stripe.instance.confirmPaymentSheetPayment();
  //     print('@@@@@@@payment done sexesfully');
  //     // Add a delay of 2 seconds after payment is successful

  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> processPayment() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     await Stripe.instance.confirmPaymentSheetPayment();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }

  void _showSuccessDialog(
      BuildContext context, String courseName, String price) {
    // showDialog<String>(
    //   context: context,
    //   builder: (BuildContext context) => AlertDialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(15),
    //     ),
    //     title: Text(
    //       courseName,
    //       style: TextStyle(
    //         fontSize: 20,
    //         fontWeight: FontWeight.bold,
    //         color: appColor.primaryColor,
    //       ),
    //     ),
    //     content: Container(
    //       height: 100,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             "Course bought successfully",
    //             style: TextStyle(
    //               fontSize: 16,
    //               color: Colors.black,
    //             ),
    //           ),
    //           SizedBox(height: 10),
    //           Text(
    //             "Price: $price",
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold,
    //               color: Colors.green,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () => Navigator.pop(context, 'Cancel'),
    //         child: const Text(
    //           'Cancel',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         style: TextButton.styleFrom(
    //           backgroundColor: appColor.primaryColor,
    //         ),
    //       ),
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //           // Additional actions like saving data can be added here
    //         },
    //         child: const Text(
    //           'OK',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         style: TextButton.styleFrom(
    //           backgroundColor: appColor.primaryColor,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
