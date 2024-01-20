import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/medical_history_models/medical_history_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class MedicalHistoryProvider with ChangeNotifier {
  Future<void> postFamilyHistory(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userFamilyIllnessLogs';

    try {
      final response = await http.post(
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

  Future<List<FamilyHistoryModel>> getFamilyHistory(String userId) async {
    String url = '${ApiUrl.hc}get/userFamilyIllnessLogs?userId=$userId';

    List<FamilyHistoryModel> familyHistoryData = [];

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

        for (var ele in responseData) {
          familyHistoryData.add(
            FamilyHistoryModel(
              comments: ele['comments'],
              condition: ele['condition'],
              relation: ele['relation'],
              sinceWhen: ele['sinceWhen'],
              userId: ele['userId'],
            ),
          );
        }

        return familyHistoryData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<void> postAllergicHistory(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userAllergyLogs';

    try {
      final response = await http.post(
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

  Future<List<AllergicHistoryModel>> getAllergicHistory(String userId) async {
    String url = '${ApiUrl.hc}get/userAllergyLogs?userId=$userId';

    List<AllergicHistoryModel> familyHistoryData = [];

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

        for (var ele in responseData) {
          familyHistoryData.add(
            AllergicHistoryModel(
              description: ele['description'],
              name: ele['name'],
              sinceFrom: ele['sinceFrom'],
              type: ele['type'],
              userId: ele['userId'],
            ),
          );
        }

        return familyHistoryData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<void> postMajorIllness(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userMajorIllnessLogs';

    try {
      final response = await http.post(
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

  Future<List<MajorIllnessModel>> getMajorIllnessHistory(String userId) async {
    String url = '${ApiUrl.hc}get/userMajorIllnessLogs?userId=$userId';

    List<MajorIllnessModel> majorIllnessHistoryData = [];

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

        for (var ele in responseData) {
          majorIllnessHistoryData.add(
            MajorIllnessModel(
              comments: ele['comments'],
              condition: ele['condition'],
              sinceWhen: ele['sinceWhen'],
              userId: ele['userId'],
              onMedication: ele['onMedication'],
            ),
          );
        }

        return majorIllnessHistoryData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<void> postSurgicalHistory(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userSurgery';

    try {
      final response = await http.post(
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

  Future<List<SurgicalHistoryModel>> getSurgicalHistory(String userId) async {
    String url = '${ApiUrl.hc}get/userSurgery?userId=$userId';

    List<SurgicalHistoryModel> surgicalHistoryData = [];

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

        for (var ele in responseData) {
          surgicalHistoryData.add(
            SurgicalHistoryModel(
              comments: ele['comments'],
              date: ele['date'],
              hospitalNameOrDoctorName: ele['hospitalNameOrDoctorName'],
              name: ele['name'],
              userId: ele['userId'],
            ),
          );
        }

        return surgicalHistoryData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }

  Future<void> postSocialHabits(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}/post/userSocialHabits';

    try {
      final response = await http.post(
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

  Future<List<SocialHabitsModel>> getSocialHabits(String userId) async {
    String url = '${ApiUrl.hc}get/userSocialHabits?userId=$userId';

    List<SocialHabitsModel> userSocialHabits = [];

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

        for (var ele in responseData) {
          userSocialHabits.add(
            SocialHabitsModel(
              comments: ele['comments'],
              frequency: ele['frequency'],
              havingFrom: ele['havingFrom'],
              socialHabit: ele['socialHabit'],
              userId: ele['userId'],
            ),
          );
        }

        return userSocialHabits;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error');
    }
  }
}
