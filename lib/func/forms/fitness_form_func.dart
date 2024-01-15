import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class FitnessFormData {
  String? id, question;
  int? order;
  FitnessFormData({
    this.id,
    this.question,
    this.order,
  });
}

class FitnessFormFunc {
  void submitFitnessForm(Map<String, dynamic> data) async {
    String url = "${ApiUrl.wm}post/fitnessAnswers";
    log(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        // final data = json.decode(response.body)['data'] as List<dynamic>;
        log(responseData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<FitnessFormData>> fetchFitnessQuestions() async {
    String url = "${ApiUrl.wm}get/fitnessQuestions";
    List<FitnessFormData> loadedData = [];
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
            FitnessFormData(
              id: ele["_id"],
              order: ele["order"],
              question: ele["question"],
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
}
