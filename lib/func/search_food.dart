import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/weight_management/dishes_provider.dart';
import 'package:provider/provider.dart';

class SearchFood {
  static Future<List<Dishes>> searchFoodData(
      BuildContext context, String searchValue, int currentPage) async {
    try {
      return await Provider.of<DishProvider>(context, listen: false)
          .getDishes(currentPage, searchValue);
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      rethrow;
    } catch (e) {
      log("Error fetch food $e");
      // Fluttertoast.showToast(msg: "Unable to fetch experts");
      rethrow;
    } finally {}
  }
}
