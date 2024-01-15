import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/hc_consultations_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class SecondOpinionProvider with ChangeNotifier {
  Future<List<CompletedConsultations>> getCompletedUserConsultations(
      String userId) async {
    String url = '${ApiUrl.hc}user/completedHcConsultations?userId=$userId';

    final List<CompletedConsultations> completedConsultations = [];

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
          completedConsultations.add(
            CompletedConsultations(
              consultationId: element['_id'],
              description: element['description'],
              startDate: element['startDate'],
              startTime: element['startTime'],
              status: element['status'],
              userId: element['userId'][0],
              expertId: element['expertId'][0]['_id'],
              expertEmail: element['expertId'][0]['email'],
              expertFirstName: element['expertId'][0]['firstName'],
              expertLastName: element['expertId'][0]['lastName'],
              expertMobileNumber: element['expertId'][0]['mobileNo'],
              expertiseId: element['expertiseId'][0]['id'],
              expertiseName: element['expertiseId'][0]['name'],
              meetingLink: element['meetingLink'],
            ),
          );
        }
        return completedConsultations;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error: $e');
    }
  }
}
