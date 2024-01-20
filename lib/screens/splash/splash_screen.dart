import 'dart:async';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/screens/auth/login_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool session = false;
  var isLoading = false;

  void getSession() async {
    setState(() {
      isLoading == true;
    });
    SharedPrefManager pref = SharedPrefManager();
    session = await pref.getSession();
    if (session == true) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
    setState(() {
      isLoading == false;
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.forward();

    super.initState();
    getSession();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 000,
        color: Colors.white,
        child: Scaffold(
            //backgroundColor: Colors.transparent,
            body: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                // width: 250,
                // height: 150.0,
                color: Colors.white,
                child: Center(
                    child: ScaleTransition(
                        scale: _animationController,
                        child: Image.asset('assets/logo/splash.gif')))),
          ),
        ])));
  }
}
