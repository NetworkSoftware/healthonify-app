import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/body_measurements_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BodyMeasurementsProvider with ChangeNotifier {
  final User _userData = User();

  User get userData {
    return _userData;
  }

  Future<List<BodyMeasurements>> getBodyMeasurements(String data) async {
    String url = "${ApiUrl.wm}get/bodyMeasurements?$data";
    log(url);
    List<BodyMeasurements> loadedData = [];
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

        log(data.toString());

        for (var ele in data) {
          loadedData.add(
            BodyMeasurements(
              mediaLinks: MediaLinks.fromJson(ele["mediaLinks"]),
              measurements: Measurements.fromJson(ele["measurements"]),
              id: ele["_id"],
              date: DateTime.parse(ele["date"]),
              userId: ele["userId"],
              v: ele["__v"],
              bloodPressure: ele["bloodPressure"],
              bmi: ele["bmi"],
              bmr: ele["bmr"],
              bodyFat: ele["bodyFat"],
              bodyMetabolicAge: ele["bodyMetabolicAge"],
              createdAt: DateTime.parse(ele["created_at"]),
              heartRate: ele["heartRate"],
              muscleMass: ele["muscleMass"],
              note: ele["note"],
              subCutaneous: ele["subCutaneous"],
              updatedAt: DateTime.parse(ele["updated_at"]),
              visceralFat: ele["visceralFat"],
              weightInKg: ele["weightInKg"],
              totalheight: ele["totalheight"],
              bodyMeasurementsId: ele["id"],
            ),
          );
        }

        log('fetched body measurements');
        return loadedData;
        // log(data.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateBodyMeasurements(
    Map<String, dynamic> data,
  ) async {
    String url = '${ApiUrl.wm}post/bodyMeasurements';
    log("url : $url");
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
        log(responseData['message']);
        // log(responseData['data'].toString());
        // notifyListeners();
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
