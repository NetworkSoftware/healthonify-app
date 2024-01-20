import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/experts/GetTherapyList.dart'
    as therapistsList;

import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';

class ExpertiseData with ChangeNotifier {
  List<TopLevelExpertise> _topLevelExpertiseData = [];
  List<TopLevelExpertise> get topLevelExpertiseData {
    return [..._topLevelExpertiseData];
  }

  Future<List<TopLevelExpertise>> fetchTopLevelExpertiseData() async {
    // String url = "${ApiUrl.url}get/expertise?getTopExpertise=true";
    String url = "${ApiUrl.url}get/expertise";
    final List<TopLevelExpertise> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        // log(responseData.toString());
        for (var element in responseData) {
          loadedData.add(
            TopLevelExpertise(
              id: element['_id'],
              name: element['name'],
              parentExpertiseId: element['parentExpertiseId'],
            ),
          );
        }
        _topLevelExpertiseData = loadedData;
        // log(_topLevelExpertiseData.toString());
        // log("Fetched toplevel expertise");
        return _topLevelExpertiseData;
        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<Expertise> _expertise = [];
  List<Expertise> get expertise {
    return [..._expertise];
  }

  Future<void> fetchExpertise(String id) async {
    String url = "${ApiUrl.url}get/expertise?parentExpertiseId=$id";
    log("fetch expertise $url");
    final List<Expertise> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        for (var element in responseData) {
          loadedData.add(Expertise(
              id: element['_id'],
              name: element['name'],
              parentExpertiseId: element['parentExpertiseId']));
        }
        _expertise = loadedData;
        // log(_expertise[0].name.toString());
        log("fetched expertise based on parentExpertiseId");
        notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      _expertise.clear();

      rethrow;
    }
  }

  fetchAssignedExpertsPhysio(String? userId) async {
    String url = "${ApiUrl.url}user/getAssignedExperts";
    log("fetch assigned expertise $url");

    List? responseData;
    List<therapistsList.Data>? dataList = [];
    therapistsList.GetTherapyList? data;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "type": "physio",
          "flow": "consultation",
          "userId": "627dffae862ba3a172f62929"
        }),
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        try {
          // data = therapistsList.GetTherapyList.fromJson(response.body);
          responseData = responseMessage['data'];
          for (int i = 0; i < responseData!.length; i++) {
            dataList.add(therapistsList.Data.fromJson(responseData[i]));
          }
          // log(data.data![0].firstName.toString());
        } catch (e) {
          log('this is the probelm $e');
        }
        // log(_expertise[0].name.toString());
        log("fetched expertise based on parentExpertiseId");
        notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      _expertise.clear();

      rethrow;
    }
    return dataList;
  }
}
