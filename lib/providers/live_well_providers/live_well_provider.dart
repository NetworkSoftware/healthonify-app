import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:http/http.dart' as http;

class LiveWellProvider with ChangeNotifier {
  Future<List<LiveWellCategories>> getLiveWellCategories(String data) async {
    String url = '${ApiUrl.hc}get/category?$data';

    log("live well $url");

    final List<LiveWellCategories> loadedData = [];

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
            LiveWellCategories(
              id: element['_id'],
              description: element['description'],
              name: element['name'],
              parentCategoryId: element['_id'],
              mediaLink: element['mediaLink'],
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

  Future<List<ContentModel>> getContent(String categoryId) async {
    String url = '${ApiUrl.hc}get/content?categoryId=$categoryId';

    log("live well category $url");

    final List<ContentModel> loadedData = [];

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
            ContentModel(
              id: element['_id'],
              description: element['description'],
              mediaLink: element['mediaLink'],
              thumbnail: element['thumbnail'],
              title: element['title'],
              type: element['type'],
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

  Future<List<ContentModel>> fetchPlayList(String playlistId) async {
    String url = '${ApiUrl.hc}fetch/playlist?id=$playlistId';

    log("live well category $url");

    final List<ContentModel> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);
      print(responseBody["status"]);
      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData['contents']) {
          loadedData.add(
            ContentModel(
                id: element['_id'],
                description: element['description'],
                mediaLink: element['mediaLink'],
                title: element['title'],
                thumbnail: element['thumbnail'],
                format: element['format']),
          );
        }

        print("Length : ${loadedData.length}");
        return loadedData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<void> updateMeditationChallenge(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/uploadMeditationActivity';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
