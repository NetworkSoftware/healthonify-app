import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/wm_package.dart';
import 'package:http/http.dart' as http;

class WmPackagesData with ChangeNotifier {
  List<WmPackage> _packagesData = [];
  List<WmPackage> get packagesData {
    return [..._packagesData];
  }

  Future<List<WmPackage>> getAllPackages(String page) async {
    String url = '${ApiUrl.wm}get/wmPackage?limit=20&page=$page';


    print("url : $url");
    final List<WmPackage> loadData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData) {
          loadData.add(
            WmPackage(
              id: element['_id'],
              name: element['name'],
              durationInDays: element['durationInDays'],
              price: element['price'],
              sessionCount: element['sessionCount'],
              description: element['description'],
              benefits: element['benefits'],
              isActive: element['isActive'],
              frequency: element['frequency'],
              customizedDietPlan: element['customizedDietPlan'],
              dietSessionCount: element['dietSessionCount'],
              doctorSessionCount: element['doctorSessionCount'],
              expertId: element['expertId'],
              expertiseId: element['expertiseId'],
              fitnessGroupSessionCount: element['fitnessGroupSessionCount'],
              immunityBoosterCounselling: element['immunityBoosterCounselling'],
              fitnessPlan: element['fitnessPlan'],
              freeGroupSessionAccess: element['freeGroupSessionAccess'],
              packageTypeId: element['packageTypeId'],
            ),
          );
        }
        _packagesData = loadData;
        notifyListeners();
        return _packagesData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      _packagesData.clear();
      throw HttpException('error');
    }
  }

  // Future<List<WmPackage>> getPackagesByCategory({required String expertiseId}) async {
  //   String url = '${ApiUrl.wm}get/package?expertiseId=$expertiseId';
  //   print("url : $url");
  //   final List<WmPackage> loadData = [];
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //
  //     final responseBody = json.decode(response.body);
  //     print("response : ${responseBody}");
  //     print("statuscode : ${response.statusCode}");
  //     if (response.statusCode >= 400) {
  //       throw HttpException(responseBody["message"]);
  //     }
  //     if (responseBody["status"] == 1) {
  //       final responseData = json.decode(response.body)["data"];
  //       for (var element in responseData) {
  //         loadData.add(
  //           WmPackage(
  //             id: element['_id'],
  //             name: element['name'],
  //             durationInDays: element['durationInDays'],
  //             price: element['price'],
  //             sessionCount: element['sessionCount'],
  //             description: element['description'],
  //             benefits: element['benefits'],
  //             isActive: element['isActive'],
  //             frequency: element['frequency'],
  //             customizedDietPlan: element['customizedDietPlan'],
  //             dietSessionCount: element['dietSessionCount'],
  //             doctorSessionCount: element['doctorSessionCount'],
  //             expertId: element['expertId'],
  //             expertiseId: element['expertiseId'],
  //             fitnessGroupSessionCount: element['fitnessGroupSessionCount'],
  //             immunityBoosterCounselling: element['immunityBoosterCounselling'],
  //             fitnessPlan: element['fitnessPlan'],
  //             freeGroupSessionAccess: element['freeGroupSessionAccess'],
  //             packageTypeId: element['packageTypeId'],
  //           ),
  //         );
  //       }
  //       _packagesData = loadData;
  //       notifyListeners();
  //       return _packagesData;
  //     } else {
  //       throw HttpException(responseBody["message"]);
  //     }
  //   } catch (e) {
  //     _packagesData.clear();
  //     throw HttpException('error');
  //   }
  // }

  Future<void> createWmPackage(Map wmData) async {
    String url = '${ApiUrl.wm}post/wmPackage';

    log(wmData.toString());

    try {
      final data = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(wmData),
      );
      // log(data.body.toString());

      final dataResponse = json.decode(data.body);

      if (data.statusCode >= 400) {
        throw HttpException(dataResponse["message"]);
      }
      if (dataResponse["status"] == 1) {
        // final responseData =
        //     json.decode(data.body)["data"] as Map<String, dynamic>;

        // log(responseData.toString());

        notifyListeners();
      } else {
        throw HttpException(dataResponse["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
