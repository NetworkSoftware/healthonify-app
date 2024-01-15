import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/auth/signup_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/set_calories_target.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String? email;
  final String? mobile;
  final String roles;

  const OtpScreen(
      {Key? key,
      required this.mobile,
      required this.roles,
      required this.email})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String pin = "";

  void pushExpertise() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        const MainScreen()), (Route<dynamic> route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return const MainScreen();
    // }));
  }

  void pushMainScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const SetCaloriesTarget(
                isAfterLogin: true,
              )),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return const MainScreen(
    //     pushCaloriesScreen: true,
    //   );
    // }));
  }

  // void pushCaloriesCalculatorScreen() {
  //   Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => const SetCaloriesTarget()),
  //       (Route<dynamic> route) => false);
  // }

  void submit(BuildContext context) async {
    try {
      widget.roles == 'corporateEmployee'
          ? await Provider.of<SignUpData>(context, listen: false)
              .otpCheck({"email": widget.email, "otp": pin})
          : await Provider.of<SignUpData>(context, listen: false)
              .otpCheck({"mobileNo": widget.mobile, "otp": pin});
      SharedPrefManager pref = SharedPrefManager();
     // await pref.saveSession(true);
      widget.roles == 'client' || widget.roles == 'corporateEmployee' || widget.roles == 'ROLE_CLIENT'
          ? pushMainScreen.call()
          : pushExpertise.call();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  void resendOtp(BuildContext context) async {
    try {
      await Provider.of<SignUpData>(context, listen: false)
          .optResend(widget.mobile!);
      Fluttertoast.showToast(msg: "OTP Resent");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: " Unable to send OTP");
    }
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Text(
                'Verify your mobile number',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                widget.roles == "corporateEmployee"
                    ? "We have sent an OTP to your email address : ${widget.email}"
                    : 'We have sent on OTP on your mobile number +91-${widget.mobile}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 74),
              child: PinCodeTextField(
                appContext: context,
                controller: controller,
                length: 4,
                keyboardType: TextInputType.phone,
                backgroundColor: Colors.transparent,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 52,
                  fieldWidth: 50,
                  borderRadius: BorderRadius.circular(10),
                  activeFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                onChanged: (value) {
                  pin = value;
                },
                onCompleted: (val) {
                  pin = val;
                  log('Completed: $pin');
                },
              ),
              // child: OTPTextField(
              //   controller: OtpFieldController(),
              //   length: 4,
              //   width: MediaQuery.of(context).size.width,
              //   fieldWidth: 60,
              //   style: TextStyle(
              //     fontSize: 18,
              //   ),
              //   textFieldAlignment: MainAxisAlignment.spaceAround,
              //   fieldStyle: FieldStyle.box,
              //   onChanged: (value) {
              //     pin = value;
              //     log(pin);
              //   },
              //   onCompleted: (value) {
              //     pin = value;
              //     log("Completed: " + pin);
              //   },
              // ),
            ),
            VerifyOtp(submit: submit),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: TextButton(
                onPressed: () {
                  resendOtp(context);
                },
                child: Text(
                  'Resend OTP',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
