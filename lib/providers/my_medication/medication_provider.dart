import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/medication/medication_model.dart';
import 'package:http/http.dart' as http;

class MedicationData with ChangeNotifier {
  List<UserPrescription> _userPrescriptionList = [];

  List<UserPrescription> get userPrescriptionList {
    return [..._userPrescriptionList];
  }

  Future<void> postPrescription(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userPrescription';

    log(url);

    log(data.toString());

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
        Fluttertoast.showToast(msg: responseData['message']);
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllUploadedPrescription(String userId) async {
    String url = "${ApiUrl.hc}get/userPrescription?userId=$userId";

    log("fetch all user prescription url $url");

    final List<UserPrescription> userPrescription0 = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        // log(data.toString());
        final userPrescription = data["data"] as List<dynamic>;

        for (var ele in userPrescription) {
          userPrescription0.add(
            UserPrescription(
                sId: ele["_id"],
                userId: ele["userId"],
                mediaLink: ele["mediaLink"],
                date: ele["date"],
                name: ele["name"]),
          );
        }

        _userPrescriptionList = userPrescription0;

         log(_userPrescriptionList.length.toString());
        log('user prescription');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
