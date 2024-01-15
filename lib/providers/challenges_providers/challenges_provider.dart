import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/leaderboard_models/leaderboard_models.dart';
import 'package:http/http.dart' as http;

class ChallengesProvider with ChangeNotifier {
  Future<List<ChallengesModel>> getAllChallenges() async {
    String url = '${ApiUrl.hc}get/fitnessChallenge';

    List<ChallengesModel> tempChallenges = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody['message']);
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        for (var ele in responseData) {
          tempChallenges.add(
            ChallengesModel(
              id: ele['_id'],
              challengeCategoryId: ele['challengeCategoryId'],
              description: ele['description'],
              endDate: ele['endDate'],
              endTimeMs: ele['endTimeMs'],
              isActive: ele['isActive'],
              mediaLink: ele['mediaLink'],
              name: ele['name'],
              prizeType: ele['prize']['prizeType'],
              prizeValue: ele['prize']['prizeValue'],
              shortDescription: ele['shortDescription'],
              startDate: ele['startDate'],
              startTimeMs: ele['startTimeMs'],
              needToDo: ele['needToDo'] as List<dynamic>,
            ),
          );
        }
        return tempChallenges;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error: $e');
    }
  }

  Future<void> joinChallenges(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}post/userChallenge';
    print("Url : $url");
    print(json.encode(data));
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

  Future<List<JoinedChallenges>> getJoinedChallenges(String id) async {
    String url = '${ApiUrl.hc}get/userChallenge?userId=$id';

    print("url : $url");
    List<JoinedChallenges> tempChallenges = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody['message']);
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        for (var ele in responseData) {
          tempChallenges.add(
            JoinedChallenges(
              challengeCategoryId: ele['challengeCategoryId']['_id'],
              fitnessChallengeId: ele['fitnessChallengeId']['_id'],
              name: ele['challengeCategoryId']['name'],
            ),
          );
        }
        return tempChallenges;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('error: $e');
    }
  }

  Future<LeaderboardData> fetchLeaderboard(String challengeId) async {
    String url =
        '${ApiUrl.hc}fitnessChallenge/fetchLeaderBoard?fitnessChallengeId=$challengeId';

    log(url);

    LeaderboardData tempData = LeaderboardData();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody['message']);
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        tempData = LeaderboardData(
          fitnessChallengeData: FitnessChallengeData.fromJson(
              responseData["fitnessChallengeData"]),
          usersCount: responseData["usersCount"],
          usersdata: List<LeaderboardUsersData>.from(responseData["usersdata"]
              .map((x) => LeaderboardUsersData.fromJson(x))),
        );

        // log(response.body);
        return tempData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e,trace) {
      log("Trace : $trace");
      throw HttpException('$e');
    }
  }

  Future<void> uploadFoodImages(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}upload/foodChallengeImages';

    log(url);

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

  Future<List<FoodChallengeImages>> fetchFoodChallengeImages(
      String userId) async {
    String url =
        '${ApiUrl.hc}fitnessChallenge/getFoodImages?userId=$userId&fitnessChallengeId=634d4c484f7f66a094c99a36';

    List<FoodChallengeImages> foodChallengeImages = [];

    log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        log(responseBody['message']);
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];

        for (var ele in responseData) {
          foodChallengeImages.add(
            FoodChallengeImages(
              date: ele['date'],
              mediaLinks: ele['mediaLink'],
            ),
          );
        }

        return foodChallengeImages;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('$e');
    }
  }
}
