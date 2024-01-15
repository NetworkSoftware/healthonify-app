import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/insurance_model.dart';

class InsuranceProvider with ChangeNotifier {
  final InsuranceModel _insuranceRecord = InsuranceModel();
  InsuranceModel get insuranceRecord {
    return _insuranceRecord;
  }

  Future<void> postInsuranceRecord(Map<String, dynamic> insuranceMap) async {
    var dio = Dio();

    try {
      if (insuranceMap['mediaLink'] != null) {
        var response = await dio.post(
          "${ApiUrl.wm}post/insuranceLocker",
          data: insuranceMap,
        );

        log("${ApiUrl.wm}post/insuranceLocker");

        var responseData = response.data;
        log(responseData.toString());
        log('Insurance Record uploaded');
      } else {
        Fluttertoast.showToast(msg: 'MediaLink is Null');
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload health record");
    }
  }

  Future<List<InsuranceModel>> getHealthRecords(String userId) async {
    String url = '${ApiUrl.wm}get/insuranceLocker?userId=$userId';

    List<InsuranceModel> insuranceRecordData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          insuranceRecordData.add(
            InsuranceModel(
              id: ele['_id'],
              entryDateTime: ele['entryDateTime'],
              expiryDate: ele['expiryDate'],
              insuranceCompanyName: ele['insuranceCompanyName'],
              insuranceType: ele['insuranceType'],
              mediaLink: ele['mediaLink'],
            ),
          );
        }
        return insuranceRecordData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future updateInsuranceRecord(
    String recordId,
    Map<String, dynamic> data,
  ) async {
    String url = '${ApiUrl.wm}put/insuranceLocker?id=$recordId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'];
        _insuranceRecord.id = data["_id"];
        _insuranceRecord.userId = data["userId"];
        _insuranceRecord.mediaLink = data["mediaLink"];
        _insuranceRecord.expiryDate = data["expiryDate"];
        _insuranceRecord.entryDateTime = data["entryDateTime"];
        _insuranceRecord.insuranceCompanyName = data["insuranceCompanyName"];
        _insuranceRecord.insuranceType = data["insuranceType"];

        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteInsuranceRecord(String recordId) async {
    String url = '${ApiUrl.wm}delete/insuranceLocker?id=$recordId';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body);
      log('parsed responsedata');

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log('Insurance record deleted successfully');
        log(responseData['message'].toString());
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
