import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/packages.dart';
import 'package:http/http.dart' as http;

class PhysioPackagesData with ChangeNotifier {
  List<PhysioPackage> _packagesData = [];
  List<PhysioPackage> get packagesData {
    return [..._packagesData];
  }

  Future<void> fetchPacakges({String data = ""}) async {
    String url = "${ApiUrl.url}get/package$data";
     log(url);
    final List<PhysioPackage> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData) {
          loadedData.add(PhysioPackage(
              bodyPart: List<dynamic>.from(responseData.map((x) => x)),
              healthCondition: List<dynamic>.from(responseData.map((x) => x)),
              id: element['_id'],
              name: element['name'],
              expertId: element['expertId'],
              expertiseId: element['expertiseId'],
              price: element['price'],
              packageDurationInWeeks: element['packageDurationInWeeks'],
              sessionCount: element['sessionCount'],
              description: element['description'],
              benefits: element['benefits'],
              isActive: element['isActive'],
              frequency: element['frequency']));
        }
        _packagesData = loadedData;
        // log(_packagesData[0].name.toString());
        notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPackage(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}post/package";
    log(json.encode(data));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseMessage = json.decode(response.body);
      log(responseMessage.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        _packagesData.add(PhysioPackage(
            bodyPart:
                List<dynamic>.from(responseData["bodyPart"].map((x) => x)),
            healthCondition: List<dynamic>.from(
                responseData["healthCondition"].map((x) => x)),
            id: responseData['id'],
            name: responseData['name'],
            expertId: responseData['expertId'],
            expertiseId: responseData['expertiseId'],
            price: responseData['price'],
            packageDurationInWeeks: responseData['packageDurationInWeeks'],
            sessionCount: responseData['sessionCount'],
            description: responseData['description'],
            benefits: responseData['benefits'],
            isActive: responseData['isActive'],
            frequency: responseData['frequency']));

        // log(_packagesData[0].name.toString());
        notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<PhysioPackage> _packagesHealthData = [];
  List<PhysioPackage> get packagesHealthData {
    return [..._packagesHealthData];
  }

  Future<void> getPackageByCondition(Map<String, String> data) async {
    String url = "${ApiUrl.url}getPackageByCondition";
    final List<PhysioPackage> loadedData = [];
    log(data.toString());
    try {
      final response = await http.post(
        Uri.parse(url),
        // headers: {"Content-Type": "application/json"},
        body: data,
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData = json.decode(response.body)["data"]["res"];
        for (var element in responseData) {
          loadedData.add(PhysioPackage(
              bodyPart: List<dynamic>.from(responseData.map((x) => x)),
              healthCondition: List<dynamic>.from(responseData.map((x) => x)),
              id: element['_id'],
              name: element['name'],
              expertId: element['expertId'],
              expertiseId: element['expertiseId'],
              price: element['price'],
              packageDurationInWeeks: element['packageDurationInWeeks'],
              sessionCount: element['sessionCount'],
              description: element['description'],
              benefits: element['benefits'],
              isActive: element['isActive'],
              frequency: element['frequency']));
        }
        _packagesHealthData = loadedData;
        // log(_packagesHealthData[0].name.toString());
        notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      _packagesData.clear();
      _packagesHealthData.clear();
      rethrow;
    }
  }
}
