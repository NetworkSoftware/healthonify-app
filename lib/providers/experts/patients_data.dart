import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/patients.dart';

class PatientsData with ChangeNotifier {
  List<Patients> _patientData = [];

  List<Patients> get patientData {
    return [..._patientData];
  }

  Future<void> fetchPatientData(Map<String, String> data) async {
    String url = '${ApiUrl.url}getClientList';
    List<Patients> loadedData = [];
    log(url);
    log(data.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseMessage =
          json.decode(response.body) as Map<String, dynamic>;

      // log(responseMessage.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;

        // log(responseData.toString());

        for (var element in responseData) {
          loadedData.add(
            Patients(
                firstName: element['firstName'],
                lastName: element['lastName'],
                email: element['email'],
                mobileNo: element['mobileNo'],
                clientId: element['_id'],
                imageUrl: element['imageUrl']),
          );

          _patientData = loadedData;

          log("clients fetched");
        }
        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      _patientData.clear();
      rethrow;
    }
  }
}
