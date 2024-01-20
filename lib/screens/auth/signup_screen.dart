import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/string_constant.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/auth/signup_data.dart';
import 'package:healthonify_mobile/screens/auth/otp_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/signup_text_fields.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupScreen extends StatelessWidget {
  final String? role;

  const SignupScreen({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 0000,
      //width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/healthonify_background.jpg"),
          fit: BoxFit.fill,
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
                SizedBox(height: size.height * 0.3),
                // const AppLogoSignUp(),
                // appLogoSignUp,
                AuthSignUp(
                  roles: role,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthSignUp extends StatefulWidget {
  final String? roles;

  const AuthSignUp({Key? key, required this.roles}) : super(key: key);

  @override
  State<AuthSignUp> createState() => _AuthSignUpState();
}

class _AuthSignUpState extends State<AuthSignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Map<String, String> _authData = {};
  final _now = DateTime.now();
  String gender = "male";
  final TextEditingController _selectDate = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authData = {
      "firstName": "",
      "lastName": "",
      if (widget.roles != "corporateEmployee") "mobileNo": "",
      "email": "",
      "password": "",
      "roles": "",
      "dob": "",
      "gender": "",
    };
  }

  bool checkedValue = false;
  bool checkedGoogleValue = false;

  void getFirstName(String value) => _authData["firstName"] = value;

  void getLastName(String value) => _authData["lastName"] = value;

  void getMobileNo(String value) => _authData["mobileNo"] = value;

  void getEmail(String value) => _authData["email"] = value;

  void getPassword(String value) => _authData["password"] = value;

  void getDoB(String value) => _authData["dob"] = value;

  void getGender(String value) => _authData["gender"] = value;

  void onSubmit(BuildContext context) {
    setState(() => isLoading = true);
    if (!_formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }

    _authData["roles"] = widget.roles!;

    if (!checkedValue) {
      Fluttertoast.showToast(msg: "Please accept the terms and conditions");
      setState(() => isLoading = false);
      return;
    }

    if (!checkedGoogleValue) {
      Fluttertoast.showToast(
          msg: "Please accept the Google API Services User Data Policy");
      setState(() => isLoading = false);
      return;
    }

    _formKey.currentState!.save();
    log(_authData.toString());

    signUp(context);

    setState(() => isLoading = false);
  }

  void pushOtpScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OtpScreen(
            mobile: _authData["mobileNo"] ?? "",
            email: _authData["email"],
            roles: widget.roles!,
          );
        },
      ),
    );
  }

  Future<void> signUp(BuildContext context) async {
    try {
      await Provider.of<SignUpData>(context, listen: false).register(_authData);
      pushOtpScreen.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'First Name',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupFirstNameTextField(
            getValue: getFirstName,
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Last Name',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupLastNameTextField(
            getValue: getLastName,
          ),
          const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Text(
          //     'Email Address',
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          SignupEmailTextField(getValue: getEmail),
          const SizedBox(height: 20),
          widget.roles != "corporateEmployee"
              ? Column(
                  children: [
                    SignupMobileTextField(getValue: getMobileNo),
                    const SizedBox(height: 20),
                  ],
                )
              : const SizedBox(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 4.0,
                ),
              ],
            ),
            height: 50,
            child: TextFormField(
              readOnly: true,
              controller: _selectDate,
              onTap: () => dateTap(context, _selectDate),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Color(0xFFC3CAD9),
                  ),
                ),
                hintText: 'Enter your DOB',
                hintStyle: const TextStyle(
                  color: Color(0xFF959EAD),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'OpenSans',
                ),
              ),
              onSaved: (value) {
                getDoB(value!);
              },
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your dob';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Gender : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              const SizedBox(width: 5),
              Row(
                children: [
                  const Text(
                    "Male",
                    style: TextStyle(color: Colors.black),
                  ),
                  Radio(
                      value: "male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                        getGender(gender);
                      }),
                ],
              ),
              const SizedBox(width: 5),
              Row(
                children: [
                  const Text(
                    "Female",
                    style: TextStyle(color: Colors.black),
                  ),
                  Radio(
                      value: "female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                        getGender(gender);
                      }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SignupPasswordTextField(getValue: getPassword),
          const SizedBox(height: 30),
          Theme(
            data: ThemeData(unselectedWidgetColor: orange),
            child: CheckboxListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Accept terms and conditions.",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: orange),
                  ),
                  InkWell(
                    onTap: () => launchUrl(
                      Uri.parse(
                          'https://healthonify.com/home/page/privacy_policy'),
                    ),
                    child: Text(
                      'Click here to know more',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                    ),
                  )
                ],
              ),
              value: checkedValue,
              //checkColor: Colors.red,
              activeColor: orange,

              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue!;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: orange),
                  child: CheckboxListTile(
                    title: RichText(
                      text: TextSpan(
                          text:
                              '$kAppName use and transfer of information received from Google APIs to any other app will adhere to ',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: orange),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Google API Services User Data Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrl(
                                      Uri.parse(
                                          'https://developers.google.com/terms/api-services-user-data-policy#additional_requirements_for_specific_api_scopes'),
                                    );
                                  }),
                            TextSpan(
                              text: ',including the Limited Use requirements.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: orange),
                            )
                          ]),
                    ),
                    value: checkedGoogleValue,
                    //checkColor: Colors.red,
                    activeColor: orange,
                    onChanged: (newValue) {
                      setState(() {
                        checkedGoogleValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                ),
              ),
              Platform.isAndroid
                  ? Image.asset(
                      'assets/images/google_fit.png',
                      height: 50,
                      width: 50,
                    )
                  : Image.asset(
                      'assets/images/healthkit.png',
                      height: 50,
                      width: 50,
                    ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: BackToLoginButton()),
              const SizedBox(width: 10),
              Expanded(
                child: SignUpButton(
                  submit: onSubmit,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Date Picker
  dateTap(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
}
