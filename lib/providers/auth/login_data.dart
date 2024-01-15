import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/auth/login.dart';
import 'package:healthonify_mobile/models/auth/social_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:http/http.dart' as http;

class LoginData with ChangeNotifier {
  bool localSession = false;

  final Login _loginData = Login();

  Login get loginData {
    return _loginData;
  }

  Future<void> login(String mobile, String password,String fcmToken) async {
    String url = "${ApiUrl.url}login";
   // String url = "http://192.168.1.10:3000/login";
    var requestData = json.encode({"mobileNo": mobile, "password": password, "firebaseToken" : fcmToken});

    log("login url $url");
    log("login data $requestData");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestData,
      );
      // print(response.statusCode);

      final responseData = json.decode(response.body);
      log(json.encode(responseData));
      // if (response.statusCode == 200) {
      //   if(responseData["message"] == "User not verified"){
      //     throw HttpException(responseData["message"]);
      //   }
      // }
      if (response.statusCode == 204) {
        throw HttpException("Phone number not found");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      final data = json.decode(response.body) as Map<dynamic, dynamic>;
      // final data = json.decode(response.body)["data"] as List<dynamic>;

      _loginData.status = data["status"];
      _loginData.id = data["data"]["id"];
      _loginData.mobileNo = data["data"]["mobileNo"];
      _loginData.email = data["data"]["email"];
      _loginData.accessToken = data["data"]["accessToken"];
      _loginData.message = data["message"];
      _loginData.error = data["data"]["error"];
      List<String> roles =
          List<String>.from(data["data"]["roles"].map((x) => x));
      _loginData.roles = roles[0];
      SharedPrefManager pref = SharedPrefManager();
      if(_loginData.message == "User not verified"){
        localSession = false;
        await pref.saveLoginDetails(_loginData.id, _loginData.mobileNo,
            _loginData.email, "", _loginData.roles);
      }else{
        localSession = true;
        await pref.saveLoginDetails(_loginData.id, _loginData.mobileNo,
            _loginData.email, _loginData.accessToken, _loginData.roles);
      }

      await pref.saveSession(localSession);
      // log(_loginData.roles.toString());

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> socialMediaLogin(Map<String, dynamic> apiData) async {
    String url = "${ApiUrl.url}googleLogin";
    SocialLoginModel loginModel = SocialLoginModel();

    log("social media login url $url");

    log("social media login data ${json.encode(apiData)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(apiData),
      );
      // print(response.statusCode);

      final responseData = json.decode(response.body);
      log(json.encode(responseData));
      if (response.statusCode == 204) {
        throw HttpException("Phone number not found");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      // loginModel = SocialLoginModel.fromJson(data);

      _loginData.status = data["status"];
      _loginData.id = data["data"]["id"];
      _loginData.email = data["data"]["email"];
      _loginData.accessToken = data["data"]["accessToken"];
      // _loginData.message = data["data"]["message"];
      // _loginData.error = data["data"]["error"];
      List<String> roles =
          List<String>.from(data["data"]["roles"].map((x) => x));
      _loginData.roles = roles[0];
      _loginData.mobileNo = data["data"]["mobileNo"] ?? "";

      if (_loginData.mobileNo == null || _loginData.mobileNo!.isEmpty) {
        return false;
      }

      localSession = true;

      SharedPrefManager pref = SharedPrefManager();
      await pref.saveLoginDetails(_loginData.id, _loginData.mobileNo,
          _loginData.email, _loginData.accessToken, _loginData.roles);
      await pref.saveSession(localSession);
      // log(_loginData.roles.toString());
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePhone(Map<String, dynamic> apiData) async {
    String url = "${ApiUrl.url}social/updateUser";
    print("url : $url");
    log(apiData.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(apiData),
      );
      // print(response.statusCode);

      final responseData = json.decode(response.body);
      log(json.encode(responseData));
      if (response.statusCode == 204) {
        throw HttpException("Phone number not found");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // final data = json.decode(response.body) as Map<String, dynamic>;
      // loginModel = SocialLoginModel.fromJson(data);

      // log(_loginData.roles.toString());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
