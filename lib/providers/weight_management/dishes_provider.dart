import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class DishProvider with ChangeNotifier {
  List<Dishes> _dishes = [];
  List<Dishes> get dishes {
    return [..._dishes];
  }

  Future<List<Dishes>> getDishes(int currentPage, String query) async {
    String url =
        '${ApiUrl.wm}search/dish?limit=20&page=$currentPage&query=$query';

    List<Dishes> tempData = [];
    log("get dish $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          tempData.add(
            Dishes.fromJson(ele),
          );
        }

        _dishes = tempData;
        // log(data.toString());
        return tempData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e, trace) {
      log("Trace : $trace");
      rethrow;
    }
  }
}
