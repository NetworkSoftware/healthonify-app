import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/fitness_form_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class FitnessFormProvider with ChangeNotifier {
  Future<List<FitnessFormModel>> getFitnessFormData(String userId) async {
    String url = "${ApiUrl.wm}get/fitnessAnswers?userId=$userId";
    log(url);
    List<FitnessFormModel> loadedData = [];
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

        for (var ele in data) {
          loadedData.add(FitnessFormModel.fromJson(ele));
        }

        log('fetched fitness form');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
