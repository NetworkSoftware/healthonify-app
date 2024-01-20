import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:http/http.dart' as http;

class UserData with ChangeNotifier {
  User _userData = User();

  User get userData {
    return _userData;
  }

  void clearUserData() {
    _userData = User();
  }

  Future<void> fetchUserData() async {
    SharedPrefManager pref = SharedPrefManager();
    String userId = await pref.getUserID();

    String url = "${ApiUrl.url}get/user?id=$userId";
    log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      log(response.body);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData['data'][0] as Map<String, dynamic>;
        log(data.toString());
        _userData.location = data.containsKey("location")
            ? List<String>.from(data["location"]["coordinates"].map((x) => x))
            : [];
        _userData.isVerified = data["isVerified"];
        _userData.isAdminApproved = data["isAdminApproved"];
        _userData.roles = List<dynamic>.from(data["roles"].map((x) => x));
        _userData.firstName = data["firstName"];
        _userData.lastName = data["lastName"];
        _userData.id = data["_id"];
        _userData.mobile = data["mobileNo"] ?? "";
        _userData.email = data["email"];
        _userData.address = data["address"];
        _userData.imageUrl = data["imageUrl"];
        _userData.city = data["city"];
        _userData.gender = data["gender"];
        _userData.state = data["state"];
        _userData.pincode = data["pinCode"] ?? 0;
        _userData.country = data["country"];
        _userData.about = data["about"];
        _userData.dob = data["dob"];
        _userData.bmi = data["bmi"] ?? "";
        _userData.bodyFat = data["bodyFat"] ?? "";
        _userData.chest = data["chest"] ?? "";
        _userData.hips = data["hips"] ?? "";
        _userData.waistInCms = data["waistInCms"] ?? "";
        _userData.sleepTime = data["sleepTime"] ?? "";
        _userData.wakeupTime = data["wakeupTime"] ?? "";
        _userData.calorieIntake = data["calorieIntake"] ?? 0;
        _userData.dailyWaterGoal = data["dailyWaterGoal"] ?? "";
        _userData.dailySleepGoalInSeconds =
            data["dailySleepGoalInSeconds"] ?? 0;
        _userData.dailyStepCountGoal = data["dailyStepCountGoal"] ?? 0;
        _userData.breakfastGoal =
            data["mealCaloriesGoal"]["breakfastGoal"] ?? 0;
        _userData.morningSnacksGoal =
            data["mealCaloriesGoal"]["morningSnacksGoal"] ?? 0;
        _userData.afternoonSnacksGoal =
            data["mealCaloriesGoal"]["afternoonSnacksGoal"] ?? 0;
        _userData.lunchGoal = data["mealCaloriesGoal"]["lunchGoal"] ?? 0;
        _userData.dinnerGoal = data["mealCaloriesGoal"]["dinnerGoal"] ?? 0;

        // log(_userData.roles![0]["address"].toString());
        notifyListeners();

        log(userData.firstName!);
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> fetchClientData(String userId) async {
    User clientData = User();
    String url = "${ApiUrl.url}get/user?id=$userId";
    log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData['data'][0] as Map<String, dynamic>;
        log(data.toString());
        clientData.location = data.containsKey("location")
            ? List<String>.from(data["location"]["coordinates"].map((x) => x))
            : [];
        clientData.isVerified = data["isVerified"];
        clientData.isAdminApproved = data["isAdminApproved"];
        clientData.roles = List<dynamic>.from(data["roles"].map((x) => x));
        clientData.firstName = data["firstName"];
        clientData.lastName = data["lastName"];
        clientData.id = data["_id"];
        clientData.mobile = data["mobileNo"] ?? "";
        clientData.email = data["email"];
        clientData.address = data["address"];
        clientData.imageUrl = data["imageUrl"];
        clientData.city = data["city"];
        clientData.gender = data["gender"];
        clientData.state = data["state"];
        clientData.pincode = data["pinCode"];
        clientData.country = data["country"];
        clientData.about = data["about"];
        clientData.dob = data["dob"];
        clientData.bmi = data["bmi"] ?? "";
        clientData.bodyFat = data["bodyFat"] ?? "";
        clientData.chest = data["chest"] ?? "";
        clientData.hips = data["hips"] ?? "";
        clientData.waistInCms = data["waistInCms"] ?? "";
        clientData.sleepTime = data["sleepTime"] ?? "";
        clientData.wakeupTime = data["wakeupTime"] ?? "";
        clientData.calorieIntake = data["calorieIntake"] ?? "";
        clientData.dailyWaterGoal = data["dailyWaterGoal"] ?? "";
        clientData.dailySleepGoalInSeconds =
            data["dailySleepGoalInSeconds"] ?? "";
        clientData.dailyStepCountGoal = data["dailyStepCountGoal"] ?? "";

        return clientData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpertData() async {
    SharedPrefManager pref = SharedPrefManager();
    String userId = await pref.getUserID();

    String url = "${ApiUrl.url}fetch/experts?id=$userId";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData['data'][0] as Map<String, dynamic>;
        _userData.location =
            List<String>.from(data["location"]["coordinates"].map((x) => x));
        _userData.isVerified = data["isVerified"];
        _userData.isAdminApproved = data["isAdminApproved"];
        _userData.roles = List<dynamic>.from(data["roles"].map((x) => x));
        _userData.expertise =
            List<dynamic>.from(data["expertise"].map((x) => x));
        if (data.containsKey('topExpertise')) {
          log("Hey");
          log(data.containsKey('topExpertise').toString());
          if (data['topExpertise']['_id'].isNotEmpty) {
            await pref.saveIsTopExp(true);
            _userData.topLevelExpId = data['topExpertise']['_id'];
            _userData.topLevelExpName = data['topExpertise']['name'];
          }
        }
        _userData.certificates =
            List<dynamic>.from(data["certificates"].map((x) => x));
        _userData.availability =
            List<dynamic>.from(data["availability"].map((x) => x));
        _userData.firstName = data["firstName"];
        _userData.gender = data["gender"];
        _userData.lastName = data["lastName"];
        _userData.id = data["_id"];
        _userData.mobile = data["mobileNo"] ?? "";
        _userData.email = data["email"];
        _userData.consultTime =
            List<dynamic>.from(data["consultTime"].map((x) => x));
        _userData.blockedSlots =
            List<dynamic>.from(data["blockedSlots"].map((x) => x));
        _userData.address = data["address"];
        _userData.city = data["city"];
        _userData.state = data["state"];
        _userData.pincode = data["pinCode"];
        _userData.country = data["country"];
        _userData.about = data["about"];
        _userData.consultationCharge = data["consultationCharge"];
        _userData.dob = data["dob"];
        _userData.registrationNumber = data["registrationNumber"] ?? "";

        // log(_userData.roles![0]["address"].toString());
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putUserData(Map<String, dynamic> data) async {
    SharedPrefManager pref = SharedPrefManager();
    String userId = await pref.getUserID();

    String url = "${ApiUrl.url}put/user?id=$userId";
    // log(userId);

    // log(json.encode(data));
    log("user data response $data");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(json.encode(responseData));

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData['data'];
        _userData.location =
            List<String>.from(data["location"]["coordinates"].map((x) => x));
        _userData.isVerified = data["isVerified"];
        _userData.isAdminApproved = data["isAdminApproved"];
        _userData.expertise =
            List<dynamic>.from(data["expertise"].map((x) => x));
        _userData.certificates =
            List<dynamic>.from(data["certificates"].map((x) => x));
        _userData.firstName = data["firstName"];
        _userData.lastName = data["lastName"];
        _userData.bmi = data["bmi"];
        _userData.gender = data["gender"];
        _userData.bodyFat = data["bodyFat"];
        _userData.chest = data["chest"];
        _userData.hips = data["hips"];
        _userData.waistInCms = data["waistInCms"];
        _userData.id = data["_id"];
        _userData.mobile = data["mobileNo"] ?? "";
        _userData.email = data["email"];
        _userData.consultTime =
            List<dynamic>.from(data["consultTime"].map((x) => x));
        _userData.blockedSlots =
            List<dynamic>.from(data["blockedSlots"].map((x) => x));
        _userData.address = data["address"];
        _userData.city = data["city"];
        _userData.state = data["state"];
        _userData.pincode = data["pinCode"];
        _userData.country = data["country"];
        _userData.about = data["about"];
        _userData.consultationCharge = data["consultationCharge"];
        _userData.dob = data["dob"];
        _userData.topLevelExpName =
            data["topExpertise"] == null ? "" : data["topExpertise"]["name"];
        _userData.topLevelExpId =
            data["topExpertise"] == null ? "" : data["topExpertise"]["_id"];

        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDeviceToken(Map<String, dynamic> data) async {
    SharedPrefManager pref = SharedPrefManager();
    String userId = await pref.getUserID();

    // log(data.toString());
    String url = "${ApiUrl.url}put/user?id=$userId";
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        // final data = responseData['data'];
        // log(data.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<UsersList> _users = [];
  List<UsersList> get users {
    return [..._users];
  }

  Future<void> getUsers(String topExpId) async {
    String url =
        "${ApiUrl.url}get/user?roles=6229b2f153fc7e317ceaf675&topExpertise=$topExpId&isAdminApproved=true";
    List<UsersList> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            UsersList(
                id: element["_id"],
                firstName: element["firstName"],
                lastName: element["lastName"]),
          );
        }
        _users = loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> getExperts() async {
    String url =
        "${ApiUrl.url}get/user?roles=6229b2f153fc7e317ceaf675&isAdminApproved=true";

    List<User> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            User(
              isAdminApproved: element["isAdminApproved"],
              firstName: element["firstName"],
              lastName: element["lastName"],
              id: element["_id"],
              mobile: element["mobileNo"] ?? "",
              email: element["email"],
              imageUrl: element["imageUrl"],
              topExpertise: element["topExpertise"]["name"],
            ),
          );
        }

        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getPhysioTherepists() async {
    String url = "${ApiUrl.url}get/user?topExpertise=6229a980305897106867f787";
    List<User> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          if (element["topExpertise"]["name"].contains("Physiotherapy")) {
            loadedData.add(
              User(
                isAdminApproved: element["isAdminApproved"],
                firstName: element["firstName"],
                lastName: element["lastName"],
                id: element["_id"],
                mobile: element["mobileNo"] ?? "",
                email: element["email"],
                imageUrl: element["imageUrl"],
              ),
            );
          }
        }

        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateSleepTime(String wakeupTime, String sleepTime) {
    _userData.sleepTime = sleepTime;
    _userData.wakeupTime = wakeupTime;
    notifyListeners();
  }
}
