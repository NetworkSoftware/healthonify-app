import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/get_chat_details.dart';
import 'package:provider/provider.dart';

class Dummyscreen extends StatefulWidget {
  const Dummyscreen({Key? key}) : super(key: key);

  @override
  State<Dummyscreen> createState() => _DummyscreenState();
}

class _DummyscreenState extends State<Dummyscreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> getChatIds(BuildContext context) async {
    try {
      await Provider.of<GetChatDetails>(context, listen: false).getChatDetails(
          "91gb90d21ebg134380f14b32", "91gb90d21ebg134380f14b32");
      log('fetched chat details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting chat details $e");
      Fluttertoast.showToast(msg: "Unable to fetch chat details");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn().then((userData) {
      log(userData.toString());
    }).catchError((e) {
      log(e.toString());
    });

    final GoogleSignInAuthentication? googleAuth = await user?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getChatIds(context),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text('hey!')),
                      TextButton(
                        onPressed: () {},
                        child: const Text('get consultations'),
                      ),
                      TextButton(
                        onPressed: () async {
                          UserCredential userCredential =
                              await signInWithGoogle();
                          log(userCredential.toString());
                        },
                        child: const Text('Google login?'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// class DummyInheritedWidget extends InheritedWidget {
//   final int? counter;
//   const DummyInheritedWidget({Key? key, required this.counter, required child})
//       : super(key: key, child: child);

//   static int? of(BuildContext context) => context
//       .dependOnInheritedWidgetOfExactType<DummyInheritedWidget>()
//       ?.counter;

//   @override
//   bool updateShouldNotify(DummyInheritedWidget oldWidget) {
//     return oldWidget.counter != counter;
//   }
// }
