import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class BlogsProvider with ChangeNotifier {
  Future<List<BlogsModel>> getAllBlogs({String data =""}) async {
    String url = "${ApiUrl.wm}get/blog$data";
    List<BlogsModel> allBlogs = [];
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
          allBlogs.add(
            BlogsModel(
              blogTitle: ele["blogTitle"],
              date: ele["date"],
              description: ele["description"],
              expertiseId: ele["expertiseId"],
              id: ele["_id"],
              isActive: ele["isActive"],
              mediaLink: ele["mediaLink"],
            ),
          );
        }

        log('fetched all blogs');
        return allBlogs;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
