import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/batches/batches_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class BatchProvider with ChangeNotifier {
  Future<void> createBatch(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}post/batch';

    log(data.toString());

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

  Future<List<BatchModel>> getBatches(
      [String? expertId, String? userId]) async {
    String url = expertId != null
        ? "${ApiUrl.url}get/batch?isActive=true&&expertId=$expertId"
        : userId != null
            ? "${ApiUrl.url}get/userBatch?isActive=true&userId=$userId"
            : "${ApiUrl.url}get/batch?isActive=true";
    log(url);
    List<BatchModel> loadedData = [];
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
            BatchModel(
              capacity: ele['capacity'].toString(),
              days: ele['days'].toString(),
              endTime: ele['endTime'],
              expertId: ele['expertId'],
              gender: ele['gender'],
              id: ele['_id'],
              info: ele['info'],
              isActive: ele['isActive'],
              name: ele['name'],
              roomName: ele['roomName'],
              service: ele['service'],
              startTime: ele['startTime'],
              userIds: List<String>.from(ele["userIds"].map((x) => x)),
            ),
          );
        }

        log('fetched batches ! No of batches = ${loadedData.length}');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BatchModel>> getUserBatches(String? userId) async {
    String url = "${ApiUrl.url}get/userBatch?isActive=true&userId=$userId";
    log(url);
    List<BatchModel> loadedData = [];
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
            BatchModel(
              endTime: ele['batchId']['endTime'],
              expertId: ele['batchId']['expertId'],
              id: ele['batchId']['_id'],
              info: ele['batchId']['info'],
              isActive: ele['batchId']['isActive'],
              name: ele['batchId']['name'],
              startTime: ele['batchId']['startTime'],
            ),
          );
        }

        log('fetched batches ! No of batches = ${loadedData.length}');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> joinBatch(Map<String, dynamic> data) async {
    String url = '${ApiUrl.url}post/userBatch';

    log(data.toString());

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
