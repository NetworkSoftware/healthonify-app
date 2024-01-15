import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/change_password_text_fields.dart';
import 'package:healthonify_mobile/widgets/text%20fields/forgot_pass_fields.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  final String mobNo;
  const ChangePasswordScreen({required this.mobNo, Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final Map<String, String> _authData = {
    "otp": "",
    "newpassword": "",
  };

  final bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  String? mobile;

  void onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    _changePass();
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  void _changePass() async {
    String url = "${ApiUrl.url}updatePassword";
    var requestData = json.encode({
      "otp": _authData['otp'],
      "mobileNo": widget.mobNo,
      "newpassword": _authData["newpassword"],
    });

    log(requestData.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestData,
      );
      final responseData = json.decode(response.body);
      log(responseData.toString());
      if (response.statusCode >= 400) {
        // log(responseData);
        throw (HttpException(responseData["message"]));
      }
      Fluttertoast.showToast(msg: "Password Changed");
      popFunc();
    } on HttpException catch (e) {
      log("ChangePasswordScreen http $e");
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log("ChangePasswordScreen $e");
      Fluttertoast.showToast(msg: "Error");
    }
  }

  void getOtp(String value) => _authData["otp"] = value;
  void getNewPassword(String value) => _authData["newpassword"] = value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OTP',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: UpdatePassOtpField(
                            getValue: getOtp,
                            mobileNo: widget.mobNo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: ConfirmPasswordTextField(
                              getValue: getNewPassword),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SaveButton(
                isLoading: isLoading,
                submit: onSubmit,
                title: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
