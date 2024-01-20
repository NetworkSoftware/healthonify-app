import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/fitness_tools_models/fitness_tools_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class MacroCalculatorProvider with ChangeNotifier {
  Future<List<DietType>> getDietTypes() async {
    String url = '${ApiUrl.wm}get/dietType';

    final List<DietType> loadedData = [];

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
          loadedData.add(
            DietType(
              dietId: element['_id'],
              dietTypeName: element['dietTypeName'],
            ),
          );
        }
        return loadedData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<List<MacroCalculator>> calculateMacros(
      String userId, String calories) async {
    log('$userId <---> $calories');
    String url = '${ApiUrl.wm}/calculate/fitness?tool=macroCalculator&id=$userId&calories=$calories';
    final List<MacroCalculator> macroData = [];

    try {
      log('try block entered');
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

        macroData.add(
          MacroCalculator(
            carbInGrams: responseData['carbInGrams'],
            fatInGrams: responseData['fatInGrams'],
            proteinInGrams: responseData['proteinInGrams'],
            totalCalories: responseData['totalCalories'],
          ),
        );
        // log(macroData[0].carbInGrams!);
        return macroData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
