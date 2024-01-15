import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/custom_page_route.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/auth/login_data.dart';
import 'package:healthonify_mobile/screens/auth/forgot_pass.dart';
import 'package:healthonify_mobile/screens/auth/update_mobile.dart';
import 'package:healthonify_mobile/screens/client_screens/location_details.dart';
import 'package:healthonify_mobile/screens/client_screens/manual_calorie_tracking.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physio_body_parts.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physio_conditions.dart';
import 'package:healthonify_mobile/screens/auth/signup_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/set_calories_target.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GradientButton extends StatelessWidget {
  final String? title;
  final Function? func;
  final Gradient gradient;
  final Widget? icon;

  const GradientButton({
    Key? key,
    required this.title,
    required this.func,
    required this.gradient,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        onTap: () {
          func!();
        },
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: icon!,
                      )
                    : const Text(''),
                Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton2 extends StatelessWidget {
  final String? title;
  final Function? func;
  final Gradient gradient;
  final Widget? icon;

  const GradientButton2({
    Key? key,
    required this.title,
    required this.func,
    required this.gradient,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
      decoration: BoxDecoration(
        gradient: gradient,
        // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell(
        onTap: () {
          func!();
        },
        // borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title!,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                // submit(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ForgotPasswordScreen();
                    },
                  ),
                );
              },
              child: Text(
                'Forgot password?',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final Function submit;
  final bool isLoading;

  const SignInButton({Key? key, required this.submit, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () {
                submit(context);
              },
        child: Container(
          //height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: orange),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ElevatedButton(
          //   style: ButtonStyle(
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //           const RoundedRectangleBorder(
          //               borderRadius: BorderRadius.zero,
          //               side: BorderSide(color: Colors.red)))),
          //   onPressed:
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       'Login',
          //       style: Theme.of(context)
          //           .textTheme
          //           .bodyMedium!
          //           .copyWith(color: whiteColor),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final Function submit;
  final bool isLoading;

  const SignUpButton({Key? key, required this.submit, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 32),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  submit(context);
                },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Sign Up',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyOtp extends StatelessWidget {
  final Function submit;

  const VerifyOtp({Key? key, required this.submit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: MediaQuery.of(context).size.width * 0.35,
      child: ElevatedButton(
        onPressed: () {
          submit(context);
        },
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Verify',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }
}

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 32),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            side: const BorderSide(
              width: 1.15,
              color: orange,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Back to Login',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: orange),
            ),
          ),
        ),
      ),
    );
  }
}

class SignInGoogleButton extends StatefulWidget {
  const SignInGoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInGoogleButton> createState() => _SignInGoogleButtonState();
}

class _SignInGoogleButtonState extends State<SignInGoogleButton> {
  bool isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Map<String, dynamic>? _userData;

  Future<void> facebookLogin() async {
    //FacebookAuth.instance.
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // you are logged
      // final AccessToken accessToken = result.accessToken!;
      await FacebookAuth.instance.getUserData().then((value) {
        log("social media login succesful : ${json.encode(value)}");
        login(value);
      });
    } else {
      log("facebook login status ${result.status}");
      log("facebook login message ${result.message}");
    }

    // final LoginResult result = await FacebookAuth.instance.login(permissions:['email']);
    //
    //
    // if (result.status == LoginStatus.success) {
    //
    //   final userData = await FacebookAuth.instance.getUserData();
    //
    //   _userData = userData;
    //
    //   print("USerData : $_userData");
    // } else {
    //   print(result.message);
    // }
    //
    //
    //
    // final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
    //
    // final user = FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    //
    // print("USerData1 : $user");
  }

  void pushForgotPasswordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const UpdateMobileScreen(
            title: "Update your phone number",
          );
        },
      ),
    );
  }

  Future<void> login(Map<String, dynamic> data) async {
    setState(() => isLoading = true);
    try {
      bool response = await Provider.of<LoginData>(context, listen: false)
          .socialMediaLogin({
        "email": data["email"],
        "socialAccountId": data["id"],
        "name": data["name"],
        "imageUrl": data["picture"]["data"]["url"] == "" ? "": data["picture"]["data"]["url"],
        "roles": "client"
      });
      if (!response) {
        log("Please update your mobile number");
        pushForgotPasswordScreen();
      } else {
        Navigator.of(
          context, /*rootnavigator: true*/
        ).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (Route<dynamic> route) => false);
      }
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Unable to login, please try again");
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Unable to login, please try again");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);

    try {
      login({
        "email": user.user?.email,
        "id": user.user?.uid,
        "name": user.user?.displayName,
        "picture": {
          "data": {
            "url": user.user?.photoURL,
          }
        }
      });
    } catch (e) {
      print("Error : ${e.toString()}");
      log(e.toString());
    }

    // await _googleSignIn.signIn().then((userData) {
    //   log(json.encode(userData));
    //   if (userData != null) {
    //     login({
    //       "email": userData.email,
    //       "id": userData.id,
    //       "name": userData.displayName,
    //       "picture": {
    //         "data": {
    //           "url": userData.photoUrl,
    //         }
    //       }
    //     });
    //   }
    // }).catchError((e) {
    //   print("Error : ${e.toString()}");
    //   log(e.toString());
    // });
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print(credential.email);
      print(credential.familyName);
      print(credential.givenName);
      print(credential.identityToken);
      print(credential.state);
      print(credential.authorizationCode);
      print(credential.userIdentifier);

      try {
        login({
          "email": credential.email,
          "id": credential.userIdentifier,
          "name": credential.givenName,
          "picture": {
            "data": {
              "url": "",
            }
          }
        });
      } catch (e) {
        print("Error : ${e.toString()}");
        log(e.toString());
      }
    } catch (e) {
      print("Exeption Error : $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //const Text('Or sign in with'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider(color: Color(0xFF959EAD), thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Or",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Color(0xFF959EAD)),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFF959EAD), thickness: 1)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  // facebookLogin();
                  await signInWithGoogle();
                  // log(userCredential.toString());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset(
                        'assets/icons/googlesignin.png',
                        height: 38,
                        width: 38,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Platform.isIOS ?
              GestureDetector(
                onTap: () async {
                  // facebookLogin();
                  await signInWithApple();
                  // log(userCredential.toString());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset(
                        'assets/icons/apple_logo.png',
                        height: 38,
                        width: 38,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ) : const SizedBox(),
              // const SizedBox(width: 10),
              // GestureDetector(
              //   onTap: () {
              //     facebookLogin();
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white,
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Colors.grey,
              //           offset: Offset(0.0, 1.0), //(x,y)
              //           blurRadius: 6.0,
              //         ),
              //       ],
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(6),
              //         child: Image.asset(
              //           'assets/icons/f_logo.png',
              //           height: 38,
              //           width: 38,
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class SignupNowButton extends StatelessWidget {
  const SignupNowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const SignupScreen(role: "client");
            },
          ),
        );
      },
      child: Text(
        'Sign Up Now',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final Function submit;
  final bool isLoading;
  final String? title;

  const SaveButton(
      {Key? key,
      required this.submit,
      required this.isLoading,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 32),
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          onPressed: isLoading ? () {} : () => submit(),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectPlanButton extends StatelessWidget {
  const SelectPlanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF3CE5AB),
                Color(0xFF0BC6F0),
              ],
            ),
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Select Plan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: whiteColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdventureButton extends StatelessWidget {
  const AdventureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: () {},
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    'Adventure',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeisureButton extends StatelessWidget {
  const LeisureButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFBFBFB),
            shadowColor: Colors.transparent,
            elevation: 0,
            side: const BorderSide(
              width: 1.15,
              color: Color(0xFF717579),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.loyalty,
                  color: Color(0xFF717579),
                  size: 28,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    'Leisure',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewMoreButton extends StatelessWidget {
  const ViewMoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.33,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LocationDetailsScreen();
                },
              ),
            );
          },
          child: Center(
            child: Text(
              'View More',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class BuyNowButton1 extends StatelessWidget {
  const BuyNowButton1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.33,
      child: ElevatedButton(
        onPressed: () {},
        child: Center(
          child: Text(
            'Buy Now',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }
}

class BuyNowButton2 extends StatelessWidget {
  const BuyNowButton2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.65,
      child: ElevatedButton(
        onPressed: () {},
        child: Center(
          child: Text(
            'Buy Now',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 32),
      child: SizedBox(
        height: 48,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          onPressed: () {},
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Submit',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  final Function func;
  final Map<String, dynamic> data;

  const SelectButton({Key? key, required this.func, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
      child: TextButton(
        onPressed: () {
          func(context, data);
        },
        child: Text(
          'Select',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: whiteColor),
        ),
      ),
    );
  }
}

class NextButton1 extends StatelessWidget {
  const NextButton1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      title: 'Calculate',
      func: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const BmiResults(

        //       );
        //     },
        //   ),
        // );
      },
      gradient: orangeGradient,
    );
    // return SizedBox(
    //   height: 36,
    //   width: MediaQuery.of(context).size.width * 0.35,
    //   child: ElevatedButton(
    // onPressed: () {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return const ResultsScreen();
    //       },
    //     ),
    //   );
    // },
    //     child: Align(
    //       alignment: Alignment.center,
    //       child: Text(
    //         'Calculate',
    //         style: Theme.of(context)
    //             .textTheme
    //             .bodyMedium!
    //             .copyWith(color: whiteColor),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class NextButton2 extends StatelessWidget {
  const NextButton2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      title: 'Calculate',
      func: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return  CaloriesTargetScreen();
        //     },
        //   ),
        // );
      },
      gradient: orangeGradient,
    );
    // return SizedBox(
    //   height: 36,
    //   width: MediaQuery.of(context).size.width * 0.35,
    //   child: ElevatedButton(
    //     onPressed: () {
    //       Navigator.push(context, MaterialPageRoute(builder: (context) {
    //         return const CaloriesTargetScreen();
    //       }));
    //     },
    //     child: Align(
    //       alignment: Alignment.center,
    //       child: Text(
    //         'Calculate',
    //         style: Theme.of(context)
    //             .textTheme
    //             .bodyMedium!
    //             .copyWith(color: whiteColor),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class ConditionsButton extends StatelessWidget {
  const ConditionsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE9BE0C),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute( builder: (context) {
          //   return PhysioConditionsScreen();
          // }));
          // CustomPageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) =>
          //         PhysioConditionsScreen());
          Navigator.of(context)
              .push(CustomPageRoute(child: const PhysioConditionsScreen()));
        },
        child: Text(
          'Conditions',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: whiteColor),
        ),
      ),
    );
  }
}

class BodyPartsButton extends StatelessWidget {
  const BodyPartsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF8E4CED),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const PhysioBodyParts();
          }));
        },
        child: Text(
          'Body Parts',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: whiteColor),
        ),
      ),
    );
  }
}

class CalcCalorieIntakeButton extends StatelessWidget {
  const CalcCalorieIntakeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SetCaloriesTarget();
            }));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calculate daily calorie intake',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManualEntryCalorieButton extends StatelessWidget {
  const ManualEntryCalorieButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ManualCalorieTracking();
            }));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manually enter your calorie intake',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StartTrackingButton extends StatelessWidget {
  const StartTrackingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MealPlansScreen();
            }));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start tracking without setting a goal',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnlockTherapies extends StatelessWidget {
  const UnlockTherapies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: const Color(0xFF8E4CED),
        borderRadius: BorderRadius.circular(7),
      ),
      child: TextButton(
        onPressed: () {},
        child: Row(
          children: [
            const Icon(
              Icons.vpn_key_outlined,
              color: Colors.white,
              size: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Unlock all therapies',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: whiteColor),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class TherapiesButtons extends StatelessWidget {
  final String therapy;

  const TherapiesButtons({Key? key, required this.therapy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
        ),
        child: TextButton(
          onPressed: () {},
          child: Row(
            children: [
              const Icon(
                Icons.emoji_people_rounded,
                color: Color(0xFF8E4CED),
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  therapy,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.lock_outline,
                color: Color(0xFF8E4CED),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnquirySubmit extends StatelessWidget {
  final Function submit;

  const EnquirySubmit({required this.submit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => submit(context),
      child: Text(
        'Submit Enquiry',
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: whiteColor),
      ),
    );
  }
}

class ChoosePackageDurationBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const ChoosePackageDurationBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'Choose package duration', getV, 1, 100, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class PackageSessionsBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const PackageSessionsBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'Choose no of sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class DoctorSessionsBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const DoctorSessionsBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class FitnessPlansBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const FitnessPlansBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class GroupFitnessSessionsBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const GroupFitnessSessionsBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class CustomDietBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const CustomDietBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class DietPlansBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const DietPlansBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class ImmunityCounselBtn extends StatelessWidget {
  final Function func;
  final Function getV;
  final int val;

  const ImmunityCounselBtn({
    required this.func,
    required this.getV,
    required this.val,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        func(context, 'No of doctor sessions', getV, 1, 20, val);
      },
      child: Text(
        val.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
