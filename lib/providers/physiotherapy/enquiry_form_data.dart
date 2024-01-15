import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/enquiry_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class EnquiryData with ChangeNotifier {
  Future<List<EnquiryFormModel>> getEnquiryData(
      {required String userId}) async {
    String url = "${ApiUrl.url}get/enquiry?userId=$userId";

    log("get enquiry url $url");

    List<EnquiryFormModel> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        loadedData = List<EnquiryFormModel>.from(
            responseData["data"].map((x) => EnquiryFormModel.fromJson(x)));
      } else {
        throw HttpException(responseData["message"]);
      }
      // final eData = json.decode(response.body)['data'];

      return loadedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitEnquiryForm(Map<String, dynamic> enquiryData) async {
    String url = "${ApiUrl.url}enquiry/saveEnquiry";

    log("submit enquiry $url");


    print("Data : ${json.encode(enquiryData)}");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(enquiryData),
      );
      print("JsonData : ${response.body}");
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
      } else {
        throw HttpException(responseData["message"]);
      }
      // final eData = json.decode(response.body)['data'];

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
