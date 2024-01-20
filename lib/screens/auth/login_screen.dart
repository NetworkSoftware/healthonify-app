import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/auth/login_data.dart';
import 'package:healthonify_mobile/screens/auth/otp_screen.dart';
import 'package:healthonify_mobile/screens/auth/signup_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/login_text_fields.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 0000,
      decoration: const BoxDecoration(
        //color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/healthonify_background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Platform.isAndroid
                    ? SizedBox(height: size.height * 0.28)
                    : SizedBox(height: size.height * 0.30),
                // const AppLogoLogin(),
                // const SizedBox(height: 30),
                const AuthLoginForm(),
                const SignInGoogleButton(),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: orange,
                                fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SignupScreen(role: "client");
                                }));
                              })
                      ]),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SignupScreen(
                              role: "corporateEmployee",
                            );
                          }));
                        },
                        child: Container(
                          //height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: orange),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Corporate Signup',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    const SignupScreen(role: "expert")),
                          );
                        },
                        child: Container(
                          //height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: orange),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Expert Signup',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: TextButton(
                    //     onPressed: () {
                    //
                    //     },
                    //     child: Text(
                    //       'Corporate user signup',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .labelSmall!
                    //           .copyWith(color: orange),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                    // Expanded(
                    //   child: TextButton(
                    //     onPressed: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) {
                    //         return const SignupScreen(role: "client");
                    //       }));
                    //     },
                    //     child: Text(
                    //       'User signup',
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .labelSmall!
                    //           .copyWith(color: orange),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                // const SizedBox(width: 10),
                // Center(
                //   child: TextButton(
                //       onPressed: () {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //               builder: (ctx) =>
                //                   const SignupScreen(role: "expert")),
                //         );
                //       },
                //       child: Text(
                //         "Expert Sign Up",
                //         style: TextStyle(
                //             color:
                //                 Theme.of(context).colorScheme.primaryContainer),
                //       )),
                // ),
                // const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthLoginForm extends StatefulWidget {
  const AuthLoginForm({Key? key}) : super(key: key);

  @override
  State<AuthLoginForm> createState() => _AuthLoginFormState();
}

class _AuthLoginFormState extends State<AuthLoginForm> {
  final _form = GlobalKey<FormState>();
  bool isLoading = false;

  final Map<String, String> _authData = {
    "phoneNo": "",
    "password": "",
    "email": "",
    "firebaseToken": "",
  };

  void onSubmit(BuildContext context) async {
    setState(() => isLoading = true);
    if (!_form.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }
    _form.currentState!.save();
    await login(context);
  }

  void getPhoneNumber(String phone) => _authData["phoneNo"] = phone;

  void getPassword(String password) => _authData["password"] = password;

  Future<void> login(BuildContext context) async {
    try {
      final firebaseId = await FirebaseNotif.getFcmToken();
      _authData['firebaseToken'] = firebaseId!;

      await Provider.of<LoginData>(context, listen: false)
          .login(_authData['phoneNo']!, _authData['password']!,
              _authData['firebaseToken']!)
          .then((value) {
        String? mobile =
            Provider.of<LoginData>(context, listen: false).loginData.mobileNo;
        String? email =
            Provider.of<LoginData>(context, listen: false).loginData.email;
        String? role =
            Provider.of<LoginData>(context, listen: false).loginData.roles;
        preferences.setString("role", role!);
        String? message =
            Provider.of<LoginData>(context, listen: false).loginData.message;

        if (message == "User not verified") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OtpScreen(
              mobile: mobile,
              email: email,
              roles: role,
            );
          }));
        } else {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false);
        }
      });
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e, trace) {
      log("Error login auth widget $e");
      log("Error login auth widget $trace");
      Fluttertoast.showToast(msg: "Unable to login, please try again");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Phone number or Email Id',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          LoginEmailTextField(
            getEmail: getPhoneNumber,
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Password',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          LoginPasswordTextField(
            getPassword: getPassword,
          ),
          const SizedBox(height: 10),
          const ForgotPasswordButton(),
          SignInButton(
            submit: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
