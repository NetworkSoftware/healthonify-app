import 'dart:convert';
import 'dart:developer';

import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class MedicalForm {
  String? id, question, conditionName, answer;

  MedicalForm({
    this.id,
    this.question,
    this.conditionName,
    this.answer,
  });
}

class MedicalFormFunc {
  Future<List<MedicalForm>> fetchMedicalHistoryQuestions() async {
    String url = "${ApiUrl.wm}get/medicalHistory";
    List<MedicalForm> loadedData = [];
    log(url);
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
        // log(responseData.toString());

        for (var ele in data) {
          loadedData.add(
            MedicalForm(
              id: ele["_id"],
              conditionName: ele["conditionName"],
              question: ele["questions"].isEmpty ? "" : ele["questions"][0],
            ),
          );
        }
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<MedicalForm>> fetchUserMedicalForm(String userId) async {
    String url = "${ApiUrl.wm}get/userMedicalHistory?userId=$userId";
    List<MedicalForm> loadedData = [];
    log(url);
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
        log(responseData.toString());
        if (json.decode(response.body)['data'].isEmpty) {
          return loadedData;
        }
        final data = json.decode(response.body)['data'][0]['conditions']
            as List<dynamic>;
        for (var ele in data) {
          loadedData.add(
            MedicalForm(
              id: ele["_id"],
              conditionName: ele["conditionId"]["conditionName"],
              question: ele["questions"].isEmpty
                  ? ""
                  : ele["questions"][0]["question"],
              answer:
                  ele["questions"].isEmpty ? "" : ele["questions"][0]["answer"],
            ),
          );
        }
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> submitMedicalForm(
      {required List<String> answers,
      required String note,
      required String userId,
      required List<MedicalForm> medicalFormQuestionsData}) async {
    Map<String, dynamic> payload = {
      "userId": userId,
      "conditions": List.generate(
        answers.length,
        (index) => {
          "conditionId": medicalFormQuestionsData[index].id,
          "questions": [
            {
              "question": medicalFormQuestionsData[index].question,
              "answer": answers[index]
            }
          ]
        },
      ),
      "notes": note
    };
    String url = "${ApiUrl.wm}post/userMedicalHistory";
    log(url);
    // log(json.encode(payload));
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        // final data = json.decode(response.body)['data'] as List<dynamic>;
        // log(responseData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
