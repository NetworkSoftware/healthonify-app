import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/lifestyle_model/lifestyle_model.dart';
import 'package:http/http.dart' as http;

class LifeStyleProviders with ChangeNotifier {
  Future<void> postLifestyleData(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/lifestyle';

    log(url);

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
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LifestyleModel>> getLifestyleData(String userId) async {
    String url = "${ApiUrl.wm}get/lifestyle?userId=$userId";
    log(url);
    List<LifestyleModel> loadedData = [];
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
            LifestyleModel(
              id: ele["_id"],
              userId: ele["userId"],
              v: ele["__v"],
              createdAt: DateTime.parse(ele["created_at"]),
              qna: List<Qna>.from(ele["qna"].map((x) => Qna.fromJson(x))),
              updatedAt: DateTime.parse(
                ele["updated_at"],
              ),
            ),
          );
        }

        log('fetched lifestyle data');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e,trace) {
      log(e.toString());
      log(trace.toString());
      rethrow;
    }
  }
}
