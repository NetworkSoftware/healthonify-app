import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lab_models/lab_cities.dart';
import 'package:http/http.dart' as http;

class GetCitiesProvider with ChangeNotifier {
  Future<List<LabCity>> getLabCities() async {
    String url = "${ApiUrl.url}get/city?country=India";

    log(url);
    List<LabCity> loadedData = [];
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
          loadedData.add(
            LabCity(
              id: ele['_id'],
              name: ele['name'],
            ),
          );
        }

        log('fetched cities');
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
