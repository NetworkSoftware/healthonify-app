import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/text_styles.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/auth/login_data.dart';
import 'package:healthonify_mobile/screens/auth/otp_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/text%20fields/forgot_pass_fields.dart';
import 'package:provider/provider.dart';

class UpdateMobileScreen extends StatefulWidget {
  final String title;
  const UpdateMobileScreen({
    Key? key,
    this.title = "Phone Number",
  }) : super(key: key);

  @override
  State<UpdateMobileScreen> createState() => _UpdateMobileScreenState();
}

class _UpdateMobileScreenState extends State<UpdateMobileScreen> {
  final _form = GlobalKey<FormState>();
  bool _isloading = false;

  final Map<String, String> authData = {
    "mobileNo": "",
    "userId": "",
  };

  void getMobileNo(String mobileNo) => authData['mobileNo'] = mobileNo;

  void goToChangePasswordScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return OtpScreen(
        email: authData["email"],
        mobile: authData["mobileNo"],
        roles: 'client',
      );
    }));
  }

  Future<void> forgotPass(BuildContext context) async {
    authData["userId"] =
        Provider.of<LoginData>(context, listen: false).loginData.id!;
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isloading = true;
    });
    _form.currentState!.save();
    try {
      await Provider.of<LoginData>(context, listen: false)
          .updatePhone(authData);
      goToChangePasswordScreen.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error forgot password widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          appBarTitle: '',
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppLogoLogin(),

                  // appLogoLogin,
                  const SizedBox(height: 100),
                  Text(widget.title,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: ForgotPassMobileNo(getValue: getMobileNo),
                  ),
                  SendOtpButton(
                    submit: forgotPass,
                    isLoading: _isloading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
