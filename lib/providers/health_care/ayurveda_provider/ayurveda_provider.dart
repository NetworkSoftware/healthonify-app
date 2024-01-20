import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_conditions_model.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:http/http.dart' as http;

class AyurvedaProvider with ChangeNotifier {
  Future<List<AyurvedaConditionsModel>> getAyurvedaConditions() async {
    String url = '${ApiUrl.hc}get/ayurvedaConditions';

    List<AyurvedaConditionsModel> ayurvedaConditions = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        for (var ele in responseData) {
          ayurvedaConditions.add(
            AyurvedaConditionsModel(
              id: ele['_id'],
              isActive: ele['isActive'],
              mediaLink: ele['mediaLink'],
              name: ele['name'],
            ),
          );
        }

        return ayurvedaConditions;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<List<AyurvedaPlansModel>> getAyurvedaPlans(String data) async {
    String url = '${ApiUrl.hc}get/ayurvedaPlans$data';
    log("ayurved plans url $url");
    List<AyurvedaPlansModel> ayurvedaConditions = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        ayurvedaConditions = ayurvedaPlansFromJson(responseData);

        return ayurvedaConditions;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<PaymentModel> purchaseAyurvedaPackage(
      Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}subscribe/ayurvedaPlan';
    log("url purchaseAyurvedaPackage $url");
    log(data.toString());
    PaymentModel paymentData = PaymentModel();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        final payData =
            responseData['data']['paymentData'] as Map<String, dynamic>;
        paymentData.amountDue = payData['amoundDue'];
        paymentData.amountPaid = payData['amountPaid'];
        paymentData.currency = payData['currency'];
        paymentData.discount = payData['discount'];
        paymentData.grossAmount = payData['grossAmount'];
        paymentData.gstAmount = payData['gstAmount'];
        paymentData.id = payData['id'];
        paymentData.subscriptionId = payData['ayurvedaSubscriptionId'];
        paymentData.invoiceNumber = payData['invoiceNumber'];
        paymentData.netAmount = payData['netAmount'];
        paymentData.razorpayOrderId = payData['rzpOrderId'];
        paymentData.status = payData['status'];
        paymentData.userId = payData['userId'];
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
      return paymentData;
    } catch (e) {
      rethrow;
    }
  }
}
