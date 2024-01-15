import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class DietPlansProvider with ChangeNotifier {
  Future<List<RecipiesModel>> getRecipies(String? data) async {
    String url = "${ApiUrl.wm}$data";

    log(url);

    List<RecipiesModel> recipies = [];
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
          recipies.add(
            RecipiesModel(
              id: ele['_id'],
              calories: ele['calories'].toString(),
              name: ele['name'],
              ingredients: ele['description']['ingredients'],
              method: ele['description']['method'],
              durationInMinutes: ele['durationInMinutes'].toString(),
              isActive: ele['isActive'],
              mediaLink: ele['mediaLink'][0] ??
                  "https://imgs.search.brave.com/8Pe1lAkpv8xsy5ES9ddJTo5JwIyp7E7kDs9tiwwvFEs/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly9zaGFo/cG91cnBvdXlhbi5j/b20vd3AtY29udGVu/dC91cGxvYWRzLzIw/MTgvMTAvb3Jpb250/aGVtZXMtcGxhY2Vo/b2xkZXItaW1hZ2Ut/MS5wbmc",
              nutritionId: ele['nutrition'][0]['_id'],
              carbs: ele['nutrition'][0]['carbs'] ?? "0",
              fats: ele['nutrition'][0]['fats'] ?? "0",
              fiber: ele['nutrition'][0]['fiber'] ?? "0",
              protiens: ele['nutrition'][0]['proteins'] ?? "0",
            ),
          );
        }

        log('fetched ${recipies.length} recipies');
        return recipies;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addRecipe(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/recipes';

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
}
