import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/store_payment.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/payment_success.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Rzp {
  static String? orderId, subscriptionId;
  static BuildContext? context;
  static String? expertId;
  static String? from;
  static String? userId;
  static void openCheckout(
    String amount,
    String title,
    String rzpKey,
    String oId,
    Razorpay razorpay,
    cId,
    BuildContext ctx,
    String exId,
      {
    String f = "",
    required String uid,
  }) async {
    orderId = oId;
    subscriptionId = cId;
    context = ctx;
    expertId = exId;
    from = f;
    userId = uid;
    try {
      // log("orderid " + orderId);
      // log(amount);
      var data = Provider.of<UserData>(ctx, listen: false).userData;
      var options = {
        'key': rzpKey,
        'amount': amount,
        'order_id': oId,
        'name': 'Healthonify',
        'description': title,
        'timeout': 300,
        'external': {
          'wallets': ['paytm'],
        },
        'prefill': {
          'contact': '+91${data.mobile}',
          'email': '${data.email}',
        }
      };
      log("options $options");
      try {
        razorpay.open(options);
      } catch (e) {
        print("Payment Exception : $e");
      }
    } catch (e) {
      log("payment gateway$e");
      Fluttertoast.showToast(msg: "Error in payment gateway. Please try again");
    }
  }

  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    Map<String, dynamic> storeLabBookingPayment = {};
    print("Signature : ${response.signature}");
    print("Order ID : ${response.signature}");
    print("Payment Id : ${response.paymentId}");
    print("From : $from");
    log(" Success ");
    Fluttertoast.showToast(msg: "Payment Succesful");
    // _checkPaymentStatus(response);
    if (from == "workout") {
      print("3");
      await saveWorkoutPayment(response.paymentId!, response.signature!,
          response.orderId!, subscriptionId!);
      Navigator.of(context!).pop();
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) {
            return PaymentSuccessScreen(
              title: "Done",
              onSubmit: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      );
      return;
    }
    if (from == 'labTests') {
      //! api call to store lab booking payment
      storeLabBookingPayment['razorpay_payment_id'] = response.paymentId;
      storeLabBookingPayment['razorpay_order_id'] = response.orderId;
      storeLabBookingPayment['razorpay_signature'] = response.signature;
      storeLabBookingPayment['labTestId'] = subscriptionId;

      log(storeLabBookingPayment.toString());

      try {
        await StorePayment.storeLabBookingPayment(storeLabBookingPayment);
      } on HttpException catch (e) {
        log("  $e");
        Fluttertoast.showToast(msg: e.message);
      } catch (e) {
        log("Error save payment data $e");
        Fluttertoast.showToast(msg: "Payment failed");
      }
    } else {
      savePaymentDetails(response.paymentId!, response.signature!,
          response.orderId!, subscriptionId!,from!);
    }

    if (from != "packages") {
      // Navigator.of(context!).push(
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return PaymentSuccessScreen(
      //         title: "Chat with expert",
      //         onSubmit: () {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) {
      //                 return ChatScreen(
      //                   expertId: expertId!,
      //                   subscriptionId: subscriptionId!,
      //                   userId: userId!,
      //                 );
      //               },
      //             ),
      //           );
      //           // Navigator.of(context).pop();
      //         },
      //       );
      //     },
      //   ),
      // );
      return;
    }
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) {
          return PaymentSuccessScreen(
            title: "Done",
            onSubmit: () {
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  static void handlePaymentPlanSuccess(PaymentSuccessResponse response) async {
    Map<String, dynamic> storeLabBookingPayment = {};
    print("Signature : ${response.signature}");
    print("Order ID : ${response.signature}");
    print("Payment Id : ${response.paymentId}");
    print("From : $from");
    log(" Success ");
    Fluttertoast.showToast(msg: "Payment Succesful");
    if (from == "workout") {
      print("3");
      await saveWorkoutPayment(response.paymentId!, response.signature!,
          response.orderId!, subscriptionId!);
      Navigator.of(context!).pop();
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) {
            return PaymentSuccessScreen(
              title: "Done",
              onSubmit: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
      );
      return;
    }
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    print("PAYYYYMENT : $response");
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
    log(" failure ");
    log(response.message.toString());
    log(response.code.toString());
    Fluttertoast.showToast(msg: "Payment Cancelled");
  }

  static void handleExternalWallet(
      // ExternalWalletResponse
      response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}", timeInSecForIosWeb: 4);
  }

  static void savePaymentDetails(String payId, String paySign, String orderId,
      String subscriptionId,String note) async {
    Map<String, String> data = {
      "razorpay_payment_id": payId,
      "razorpay_order_id": orderId,
      "razorpay_signature": paySign,
      "subscriptionId": subscriptionId,
      "note": note,
    };

    log(data.toString());

    try {
      await StorePayment.storePayment(data, from!);
    } on HttpException catch (e) {
      log("  $e");
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error save payment data $e");
      Fluttertoast.showToast(msg: "Payment failed");
    }
  }

  static Future<void> saveWorkoutPayment(String payId, String paySign,
      String orderId, String workoutPlanId) async {
    Map<String, String> data = {
      "razorpay_payment_id": payId,
      "razorpay_order_id": orderId,
      "razorpay_signature": paySign,
      "userWorkoutPlanId": workoutPlanId,
    };

    log(data.toString());

    try {
      //await StorePayment.storePayment(data, "diet");
      await StorePayment.storePlanPayment(data, "diet");
      Fluttertoast.showToast(msg: "Payment Succesful");
    } on HttpException catch (e) {
      log("  $e");
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error save payment data $e");
      Fluttertoast.showToast(msg: "Payment failed");
    }
  }
}
