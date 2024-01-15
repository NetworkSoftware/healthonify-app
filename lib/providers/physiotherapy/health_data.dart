import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/physiotherapy/health_model.dart';
import 'package:http/http.dart' as http;

class HealthData with ChangeNotifier {
  List<HealthModel> _bodyParts = [];

  List<HealthModel> get bodyParts {
    return [..._bodyParts];
  }

  Future<void> getBodyParts() async {
    String url = '${ApiUrl.url}get/bodyPart?category=physioTherapy';
    final List<HealthModel> healthCondList = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in responseData) {
          healthCondList.add(
            HealthModel(
              id: ele['_id'],
              name: ele['name'],
              bodyPartImage: ele["bodyPartImage"],
            ),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _bodyParts = healthCondList;
        // log(_bodyParts.toString());
        log('Fetched body parts');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  List<HealthModel> _bodyPartGroups = [];

  List<HealthModel> get bodyPartGroups {
    return [..._bodyPartGroups];
  }

  Future<void> getBodyPartGroups() async {
    String url = '${ApiUrl.wm}get/bodyPartGroup';
    final List<HealthModel> bodyPartGroupList = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in responseData) {
          bodyPartGroupList.add(
            HealthModel(
              id: ele['_id'],
              name: ele['name'],
              bodyPartImage: ele["bodyPartImage"],
            ),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _bodyPartGroups = bodyPartGroupList;
        // log(_bodyParts.toString());
        log('Fetched body part groups');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  List<HealthModel> _healthConditions = [];

  List<HealthModel> get healthConditions {
    return [..._healthConditions];
  }

  Future<void> getHealthConditions() async {
    String url = '${ApiUrl.url}get/healthCondition?category=physioTherapy';
    final List<HealthModel> healthConditionsList = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in responseData) {
          healthConditionsList.add(
            HealthModel(
              id: ele['_id'],
              name: ele['name'],
            ),
          );
        }
        if (response.statusCode >= 400) {
          throw HttpException(responseBody["message"]);
        }
        _healthConditions = healthConditionsList;
        // log(_healthConditions[0]);
        log('Fetched health conditions');
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
