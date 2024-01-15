import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class UpdateProfile {
 

  static Future<void> updateProfile(
      BuildContext context, Map<String, dynamic> data, {required VoidCallback onSuccess}) async {
    try {
      await Provider.of<UserData>(context, listen: false).putUserData(data);
      onSuccess.call();
     
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error put user $e");
      Fluttertoast.showToast(
          msg: "Not able to save your details, please try again");
    }
  }

  static Future<void> updateFirebasetoken(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      await Provider.of<UserData>(context, listen: false)
          .updateDeviceToken(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error put user token $e");
      Fluttertoast.showToast(
          msg: "Not able to save your details, please try again");
    }
  }

  void getNew() {}
}
