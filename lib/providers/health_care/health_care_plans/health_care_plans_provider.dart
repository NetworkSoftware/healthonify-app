import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/payment_models/payment_models.dart';
import 'package:http/http.dart' as http;

class HealthCarePlansProvider with ChangeNotifier {
  Future<List<HealthCarePlansModel>> getHealthCarePlans() async {
    String url = "${ApiUrl.url}get/package?flow=healthCare";
    List<HealthCarePlansModel> healthCarePlans = [];
    log("fetch hc plans url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          healthCarePlans.add(
            HealthCarePlansModel(
              id: ele["_id"],
              bodyPart: List<dynamic>.from(ele["bodyPart"].map((x) => x)),
              healthCondition:
                  List<dynamic>.from(ele["healthCondition"].map((x) => x)),
              name: ele["name"],
              description: ele["description"],
              benefits: ele["benefits"],
              price: ele["price"],
              sessionCount: ele["sessionCount"].toString(),
              flow: ele["flow"],
              isActive: ele["isActive"],
              //expertiseId: ele["expertiseId"],
              durationInDays: ele["durationInDays"],
              services: List<Service>.from(
                  ele["services"].map((x) => Service.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
            ),
          );
        }

        log('fetched all health care plans');
        return healthCarePlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }

  Future<List<HealthCarePlansModel>> getHealthCareFreePlans() async {
    String url = "${ApiUrl.url}get/package?flow=healthCare&price=0";
    List<HealthCarePlansModel> healthCarePlans = [];
    log("fetch hc plans url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          healthCarePlans.add(
            HealthCarePlansModel(
              id: ele["_id"],
              bodyPart: List<dynamic>.from(ele["bodyPart"].map((x) => x)),
              healthCondition:
              List<dynamic>.from(ele["healthCondition"].map((x) => x)),
              name: ele["name"],
              description: ele["description"],
              benefits: ele["benefits"],
              price: ele["price"],
              sessionCount: ele["sessionCount"].toString(),
              flow: ele["flow"],
              isActive: ele["isActive"],
              //expertiseId: ele["expertiseId"],
              durationInDays: ele["durationInDays"],
              services: List<Service>.from(
                  ele["services"].map((x) => Service.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
            ),
          );
        }

        log('fetched all health care plans');
        return healthCarePlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }

  Future<List<HealthCarePlansModel>> getAyurvedaPlans() async {
    String url = "${ApiUrl.url}get/package?flow=healthCare&subCategoryId=6368b1870a7fad5713edb4b4";
    //String url = "${ApiUrl.url}get/package?flow=healthCare";
    List<HealthCarePlansModel> healthCarePlans = [];
    log("fetch hc plans url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          healthCarePlans.add(
            HealthCarePlansModel(
              id: ele["_id"],
              bodyPart: List<dynamic>.from(ele["bodyPart"].map((x) => x)),
              healthCondition:
              List<dynamic>.from(ele["healthCondition"].map((x) => x)),
              name: ele["name"],
              description: ele["description"],
              benefits: ele["benefits"],
              price: ele["price"],
              sessionCount: ele["sessionCount"].toString(),
              flow: ele["flow"],
              isActive: ele["isActive"],
              //expertiseId: ele["expertiseId"],
              durationInDays: ele["durationInDays"],
              services: List<Service>.from(
                  ele["services"].map((x) => Service.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
              mediaLink: ele["mediaLink"],
            ),
          );
        }

        log('fetched all health care plans');
        return healthCarePlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }

  Future<List<HealthCarePlansModel>> getAyurvedaConditionPlans({required String ayurvedaId,required String conditionId}) async {
    String url = "${ApiUrl.url}get/package?flow=healthCare&subCategoryId=$ayurvedaId&ayurvedaConditions=$conditionId";
    //String url = "${ApiUrl.url}get/package?flow=healthCare";
    List<HealthCarePlansModel> healthCarePlans = [];
    log("fetch hc plans url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          healthCarePlans.add(
            HealthCarePlansModel(
              id: ele["_id"],
              bodyPart: List<dynamic>.from(ele["bodyPart"].map((x) => x)),
              healthCondition:
              List<dynamic>.from(ele["healthCondition"].map((x) => x)),
              name: ele["name"],
              description: ele["description"],
              benefits: ele["benefits"],
              price: ele["price"],
              sessionCount: ele["sessionCount"].toString(),
              flow: ele["flow"],
              isActive: ele["isActive"],
              //expertiseId: ele["expertiseId"],
              durationInDays: ele["durationInDays"],
              services: List<Service>.from(
                  ele["services"].map((x) => Service.fromJson(x))),
              createdAt: DateTime.parse(ele["created_at"]),
              updatedAt: DateTime.parse(ele["updated_at"]),
              v: ele["__v"],
              mediaLink: ele["mediaLink"],
            ),
          );
        }

        log('fetched all health care plans');
        return healthCarePlans;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }

  Future<PaymentModel> purchaseHealthCarePackage(
      Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}hc/subscribeHcPackage';
    log(url);
    log(data.toString());

    PaymentModel paymentData = PaymentModel();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      log("Payment Data :$responseData");
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
        paymentData.subscriptionId = payData['subscriptionId'];
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
