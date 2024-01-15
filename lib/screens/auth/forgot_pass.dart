import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/forgot_psswd.dart';
import 'package:healthonify_mobile/screens/auth/change_password.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/forgot_pass_fields.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String title;
  const ForgotPasswordScreen({Key? key, this.title = "Phone Number"})
      : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  bool _isloading = false;

  final Map<String, String> _authData = {
    "mobileNo": "",
  };

  void getMobileNo(String mobileNo) => _authData['mobileNo'] = mobileNo;

  void goToChangePasswordScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return ChangePasswordScreen(mobNo: _authData['mobileNo']!);
    }));
  }

  Future<void> forgotPass(BuildContext context) async {
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      _isloading = true;
    });
    _form.currentState!.save();
    try {
      await Provider.of<ForgotPasswordProvider>(context, listen: false)
          .forgotPassword(_authData['mobileNo']!);
      goToChangePasswordScreen.call();
    } on HttpException catch (e) {
      log(" Error forgot password widget $e");
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
    final size = MediaQuery.of(context).size;
    return Container(
      height: 0000,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/healthonify_background.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: const CustomAppBar(
          //   appBarTitle: '',
          // ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _form,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const AppLogoLogin(),
                      // appLogoLogin,
                      SizedBox(height: size.height * 0.4),
                      // Text(widget.title,
                      //     style: Theme.of(context).textTheme.bodyMedium),
                      ForgotPassMobileNo(getValue: getMobileNo),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: BackToLoginButton()),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SendOtpButton(
                              submit: forgotPass,
                              isLoading: _isloading,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
