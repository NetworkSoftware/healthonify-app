import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:healthonify_mobile/models/health_care/health_care_prescriptions_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/health_record_model.dart';

class HealthRecordProvider with ChangeNotifier {
  final HealthRecord _healthRecord = HealthRecord();
  HealthRecord get healthRecord {
    return _healthRecord;
  }

  Future<void> uploadHealthRecord(Map<String, dynamic> healthData) async {
    var dio = Dio();

    try {
      if (healthData['mediaLink'] != null) {
        var response =
            await dio.post("${ApiUrl.wm}post/healthLocker", data: healthData);

        var responseData = response.data;
        log(responseData.toString());
        log('Health Record uploaded');
      } else {
        Fluttertoast.showToast(msg: 'MediaLink is Null');
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to upload health record");
    }
  }

  Future<List<HealthRecord>> getHealthRecords(String userId) async {
    String url = '${ApiUrl.wm}fetch/healthLocker?userId=$userId';

    log(url);

    List<HealthRecord> healthRecordData = [];

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
          healthRecordData.add(
            HealthRecord(
              id: ele["_id"],
              userId: ele["userId"],
              mediaLink: ele["mediaLink"],
              date: DateFormat("MM/dd/yyyy").parse(ele["date"]),
              time: ele["time"],
              reportName: ele["reportName"],
              reportType: ele["reportType"],
            ),
          );
        }
        return healthRecordData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HealthCarePrescriptionModel>> getHealthcarePrescriptions(
      String userId) async {
    String url = '${ApiUrl.wm}fetch/healthLocker?userId=$userId';

    log(url);
    List<HealthCarePrescriptionModel> healthcarePrescriptions = [];

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
        final healthCareData =
            responseData['hcPrescriptionData'] as List<dynamic>;

        for (var ele in healthCareData) {
          healthcarePrescriptions.add(
            HealthCarePrescriptionModel(
              hcMediaLink: ele["hcMediaLink"],
              id: ele["id"],
              reportName: ele["reportName"],
              reportType: ele["reportType"],
              userId: ele["userId"],
              date: DateFormat("MM/dd/yyyy").parse(ele["date"]),
              time: DateFormat("HH:mm").parse(ele["time"]),
            ),
          );
        }

        return healthcarePrescriptions;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future updateHealthRecord(String recordId, Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}put/healthLocker?id=$recordId';

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
        _healthRecord.id = data["_id"];
        _healthRecord.userId = data["userId"];
        _healthRecord.mediaLink = data["mediaLink"];
        _healthRecord.date = DateTime.parse(data["date"]);
        _healthRecord.time = data["time"];
        _healthRecord.reportName = data["reportName"];
        _healthRecord.reportType = data["reportType"];
        _healthRecord.createdAt = DateTime.parse(data["created_at"]);
        _healthRecord.updatedAt = DateTime.parse(data["updated_at"]);
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future deleteHealthRecord(String recordId) async {
    String url = '${ApiUrl.wm}delete/healthLocker?id=$recordId';

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
        log('health record deleted successfully');
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
