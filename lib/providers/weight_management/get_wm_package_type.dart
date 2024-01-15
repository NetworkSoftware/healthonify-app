import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class GetWmPackageType with ChangeNotifier {
  List<String> _packageId = [];
  List<String> _packageName = [];
  List<String> get packageId {
    return [..._packageId];
  }

  List<String> get packageName {
    return [..._packageName];
  }

  Future<void> getPackageType() async {
    String url = '${ApiUrl.wm}get/wmPackageType';

    final List<String> wmPackageId = [];
    final List<String> wmPackageName = [];

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
        final responseBody = responseData['data'] as List<dynamic>;
        // log(responseBody.toString());
        for (var ele in responseBody) {
          wmPackageId.add(
            ele['_id'],
          );
          wmPackageName.add(
            ele['name'],
          );
        }
        _packageId = wmPackageId;
        _packageName = wmPackageName;

        // log(_packageName.indexOf('Disease management Programs').toString());

        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
