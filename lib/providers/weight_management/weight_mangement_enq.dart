import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/weight_loss_enq.dart';
import 'package:http/http.dart' as http;

class WMEnqProvider with ChangeNotifier {
  final WeightLossEnq _weightLossEnq = WeightLossEnq();

  WeightLossEnq get weightLossData {
    return _weightLossEnq;
  }

  Future<void> postWMdata(Map data) async {
    String url = '${ApiUrl.wm}wmEnquiry/saveWmEnquiry';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      log(response.body.toString());
      final responseMessage = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }

      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(responseData.toString());

        Fluttertoast.showToast(msg: 'Enquiry submitted successfully');

        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List _wmEnquiryData = [];
  List get wmEnquiryData {
    return [..._wmEnquiryData];
  }

  Future<void> getWmEnquiry(String data) async {
    String url = "${ApiUrl.wm}get/wmEnquiry?$data";

    // log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        _wmEnquiryData = responseData["data"] as List;
        // log(_wmEnquiryData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
      // final eData = json.decode(response.body)['data'];

      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
