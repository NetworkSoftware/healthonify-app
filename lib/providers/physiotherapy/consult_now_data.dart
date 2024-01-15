import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:healthonify_mobile/models/physiotherapy/consult_form.dart';

class ConsultNowData with ChangeNotifier {
  final ConsultNow _paymentData = ConsultNow();
  ConsultNow get payementData {
    return _paymentData;
  }

  Future<void> submitConsultNowForm(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}user/consultNow";

    var requestData = {
      "userId": data["userId"],
      "expertiseId": data["expertiseId"],
      "startDate": data["startDate"].toString(),
      "startTime": data["startTime"],
      "slotNumber": data["slotNumber"],
    };
    // log(requestData);
    log(json.encode(data));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final payData =
            json.decode(response.body)["data"] as Map<String, dynamic>;
        log("hey");
        log(payData.toString());
        _paymentData.consultationId = payData["consultationId"];
      } else {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ConsultNow> initiateFreeConsultNowForm(
      Map<String, dynamic> data) async {
    String url = "${ApiUrl.wm}wm/user/initiateFreeConsult";

    log(json.encode(data));

    // log(data.toString());
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      // log(response.body);
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final payData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(payData.toString());
        // log(_paymentData.rzpOrderId!);
        return _paymentData;
      } else {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  final SubscribePackage _subscribePackage = SubscribePackage();

  Future<SubscribePackage> subscribePackage(
      Map<String, dynamic> data, String flow) async {
    String url;
    log(flow);
    if (flow == "diet") {
      url = "${ApiUrl.wm}wm/user/subscribePackage";
    } else {
      url = "${ApiUrl.url}user/subscribePackage";
    }

    print("URL : $url");
    print("DATA : ${json.encode(data)}");

    // log(requestData);
    // log(json.encode(data));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final payData =
            json.decode(response.body)["data"] as Map<String, dynamic>;
        _subscribePackage.rzpOrderId = payData["paymentData"]["rzpOrderId"];
        _subscribePackage.subscriptionId = payData["subscriptionId"];

        return _subscribePackage;
      } else {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initiateFreeConsultation(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}user/initiateFreeConsult";

    // log(requestData);
    log("free consultaion wm url $url ---- data ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final payData =
            json.decode(response.body)["data"] as Map<String, dynamic>;
        log("free wm consultation response $payData");
      } else {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
